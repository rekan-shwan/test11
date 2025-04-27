import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:doc_helin/Backend/api.dart';
import 'package:doc_helin/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientRegistrationScreen extends StatefulWidget {
  final String phoneNum;

  const PatientRegistrationScreen({super.key, required this.phoneNum});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController secondnameCtrl = TextEditingController();
  final TextEditingController genderCtrl =
      TextEditingController(text: 'gender');
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController diseaseCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();
  final TextEditingController drugsCtrl = TextEditingController();
  final TextEditingController skintypeCtrl = TextEditingController();
  final TextEditingController treatmentCtrl = TextEditingController();
  final TextEditingController allergiesCtrl = TextEditingController();
  late TextEditingController phoneNumberCtrl;
  late TextEditingController nextAppointmentCtrl;

  String selectedGender = '';

  DateTime selectedDate = DateTime.now();
  OverlayPortalController genderOverlay = OverlayPortalController();
  bool isLoading = false;
  int totalPatientDay = 0;

  final Api api = Api();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    phoneNumberCtrl = TextEditingController(text: widget.phoneNum);
    nextAppointmentCtrl = TextEditingController(text: formatDate(selectedDate));
    getNumPatientsByDate();
  }

  @override
  void dispose() {
   
    nameCtrl.dispose();
    secondnameCtrl.dispose();
    genderCtrl.dispose();
    ageCtrl.dispose();
    addressCtrl.dispose();
    emailCtrl.dispose();
    diseaseCtrl.dispose();
    noteCtrl.dispose();
    drugsCtrl.dispose();
    skintypeCtrl.dispose();
    treatmentCtrl.dispose();
    allergiesCtrl.dispose();
    phoneNumberCtrl.dispose();
    nextAppointmentCtrl.dispose();
    super.dispose();
  }

  Future<void> savePatientData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    try {
      
      final patientResult = await api.savePatient(
        phone: phoneNumberCtrl.text,
        secondname: secondnameCtrl.text,
        name: nameCtrl.text,
        location: addressCtrl.text,
        skintype: skintypeCtrl.text,
        allergies: allergiesCtrl.text,
        diseas: diseaseCtrl.text,
        note: noteCtrl.text,
        gender: selectedGender,
        age: ageCtrl.text,
      );

      final int patientId = patientResult['pid'];

     
      int response = await api.addPatienttoHistiry(
        patientId,
        appointmentDetail: noteCtrl.text,
        drug: drugsCtrl.text,
        date: DateTime.now(),
        tratment: treatmentCtrl.text,
        isVisisted: true,
      );

      
      if (!isDateToday(selectedDate) && selectedDate.isAfter(DateTime.now())) {
        response = await api.addPatientAppointment(patientId, selectedDate);
      }

      if (!context.mounted) return;
      Navigator.pop(context);
      reloadNotifier.value = !reloadNotifier.value;
      showResultMessage(response == 200 || response == 201);
    } catch (e) {
      setState(() => isLoading = false);
      showResultMessage(false, message: 'Error: ${e.toString()}');
    }
  }

  Future<void> getNumPatientsByDate() async {
    try {
      List<dynamic> allPatients = await api.getPatientsWithAppointments();
      String today = DateFormat('yyyy-MM-dd').format(selectedDate);

      List<dynamic> todaysAppointments = allPatients.where((patient) {
        if (patient['nextAppointment'] != null &&
            patient['nextAppointment'].isNotEmpty) {
          String appointmentDate =
              patient['nextAppointment'].first['appointmentDate'];
          return appointmentDate == today;
        }
        return false;
      }).toList();

      setState(() {
        totalPatientDay = todaysAppointments.length;
      });
    } catch (e) {
      showResultMessage(false,
          message: 'Failed to load appointments: ${e.toString()}');
    }
  }

  void showResultMessage(bool isSuccess, {String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        content: Container(
          alignment: Alignment.center,
          height: 20,
          child: Text(
            message ??
                (isSuccess
                    ? 'Patient saved successfully ✅'
                    : 'An error occurred ❌'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  bool isDateToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String formatDate(DateTime date) {
    return isDateToday(date)
        ? 'YYYY-MM-DD' 
        : DateFormat('yyyy-MM-dd').format(date);
  }

  void showDatePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildCalendarWidget(onchooseDate: true),
            const SizedBox(height: 16),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime.now();
                    getNumPatientsByDate();
                  });
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
            )
          ],
        ),
      ),
    );
  }

  CupertinoCalendar buildCalendarWidget({bool onchooseDate = false}) {
    return CupertinoCalendar(
      onDateSelected: (value) {
        setState(() {
          selectedDate = value;
          nextAppointmentCtrl.text = formatDate(value);
          getNumPatientsByDate();
        });

        if (onchooseDate) {
          Navigator.pop(context);
        }
      },
      initialDateTime: selectedDate,
      firstDayOfWeekIndex: 6,
      maxWidth: 100,
      monthPickerDecoration: CalendarMonthPickerDecoration(
        selectedCurrentDayStyle: CalendarMonthPickerSelectedCurrentDayStyle(
          backgroundCircleColor: Colors.greenAccent,
          textStyle: TextStyle(fontSize: 15),
        ),
        selectedDayStyle: CalendarMonthPickerSelectedDayStyle(
          backgroundCircleColor: Colors.green,
          textStyle: TextStyle(fontSize: 15),
        ),
        defaultDayStyle: CalendarMonthPickerDefaultDayStyle(
          textStyle: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
      headerDecoration: CalendarHeaderDecoration(
        backwardButtonColor: Colors.black,
        forwardButtonColor: Colors.black,
        monthDateArrowColor: Colors.green,
        monthDateStyle: TextStyle(
          fontSize: 10,
          color: Colors.black,
        ),
      ),
      type: CupertinoCalendarType.inline,
      mode: CupertinoCalendarMode.date,
      weekdayDecoration: CalendarWeekdayDecoration(
        textStyle: TextStyle(
          fontSize: 15,
          color: Color.fromARGB(129, 0, 0, 0),
        ),
      ),
      minimumDateTime: DateTime(DateTime.now().year),
      maximumDateTime: DateTime(DateTime.now().year + 2),
    );
  }

  Widget buildFormField({
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    int? maxLines,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        validator: (value) {
          if (hintText == 'First Name' || hintText == 'Last Name') {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintText';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 48,
          child: ElevatedButton(
            onPressed: isLoading ? null : savePatientData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          height: 48,
          width: 120,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildResponsiveForm(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Patient Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),

         
          Row(
            children: [
              Expanded(
                child: buildFormField(
                  controller: nameCtrl,
                  hintText: 'First Name',
                ),
              ),
              SizedBox(width: screenWidth >= 675 ? 16 : 8),
              Expanded(
                child: buildFormField(
                  controller: secondnameCtrl,
                  hintText: 'Last Name',
                ),
              ),
            ],
          ),

          buildFormField(
            controller: phoneNumberCtrl,
            hintText: 'Phone Number',
            readOnly: true,
            keyboardType: TextInputType.phone,
          ),

          screenWidth >= 675
              ? Row(
                  children: [
                    Expanded(child: buildGenderDropdown()),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildFormField(
                        controller: ageCtrl,
                        hintText: 'Age',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildFormField(
                        controller: addressCtrl,
                        hintText: 'Address',
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: buildGenderDropdown()),
                        const SizedBox(width: 8),
                        Expanded(
                          child: buildFormField(
                            controller: ageCtrl,
                            hintText: 'Age',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    buildFormField(
                      controller: addressCtrl,
                      hintText: 'Address',
                    ),
                  ],
                ),

          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Medical Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          screenWidth >= 675
              ? Row(
                  children: [
                    Expanded(
                      child: buildFormField(
                        controller: diseaseCtrl,
                        hintText: 'Disease',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildFormField(
                        controller: skintypeCtrl,
                        hintText: 'Skin Type',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildFormField(
                        controller: treatmentCtrl,
                        hintText: 'Treatment',
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildFormField(
                            controller: diseaseCtrl,
                            hintText: 'Disease',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: buildFormField(
                            controller: skintypeCtrl,
                            hintText: 'Skin Type',
                          ),
                        ),
                      ],
                    ),
                    buildFormField(
                      controller: treatmentCtrl,
                      hintText: 'Treatment',
                    ),
                  ],
                ),

          screenWidth >= 675
              ? Row(
                  children: [
                    Expanded(
                      child: buildFormField(
                        controller: allergiesCtrl,
                        hintText: 'Allergies',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildFormField(
                        controller: drugsCtrl,
                        hintText: 'Drugs',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: buildDateSelector()),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildFormField(
                            controller: allergiesCtrl,
                            hintText: 'Allergies',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: buildFormField(
                            controller: drugsCtrl,
                            hintText: 'Drugs',
                          ),
                        ),
                      ],
                    ),
                    buildDateSelector(),
                  ],
                ),

          const SizedBox(height: 16),
          buildFormField(
            controller: noteCtrl,
            hintText: 'Notes and observations',
            maxLines: 5,
          ),

          const SizedBox(height: 24),
          buildActionButtons(),
        ],
      ),
    );
  }

  Widget buildGenderDropdown() {
    return Container(
        height: 45,
        margin: const EdgeInsets.only(bottom: 10),
        child: DropdownButtonFormField<String>(
          value: selectedGender.isNotEmpty
              ? selectedGender
              : null, 
          decoration: InputDecoration(
            hintText: 'Gender',
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue!;
            });
          },
          items:
              ['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
  }

  Widget buildDateSelector() {
    return GestureDetector(
      onTap: showDatePicker,
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.black12,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${formatDate(selectedDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: buildResponsiveForm(context),
    );
  }
}
