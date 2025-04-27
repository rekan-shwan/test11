import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:doc_helin/Backend/api.dart';
import 'package:doc_helin/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Patients extends StatefulWidget {
  const Patients({super.key});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  int hoverIndex = -1;
  Api api = Api();
  Future<List<dynamic>>? patientsFuture;
  TextEditingController nameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  TextEditingController skinTypeController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController appointmentDateController = TextEditingController();
  late DateTime selectedDate = DateTime.now();

  void reload() {
    reloadNotifier.value = !reloadNotifier.value;
  }

  int selectedAppointment = 0;
 

  @override
  void initState() {
    reloadNotifier.addListener(() {
      patientsFuture = api.getAllPatients();
    });

    super.initState();
    patientsFuture = api.getAllPatients();
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
                  backgroundColor: Color(0xFF47AEC6),
                ),
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime.now();
                    appointmentDateController.text = formatDate(selectedDate);
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
          appointmentDateController.text = formatDate(value);
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

  Widget buildDateSelector() {
    if (patientMapNotifier.value['nextAppointment'] != null &&
        patientMapNotifier.value['nextAppointment'].isNotEmpty) {
      selectedDate = DateTime.parse(
        patientMapNotifier.value['nextAppointment'].first['appointmentDate'],
      );
      appointmentDateController.text = formatDate(selectedDate);
    } else {
      selectedDate = DateTime.now();
    }

    return TextField(
      controller: appointmentDateController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Appointment Date',
        border: OutlineInputBorder(borderSide: BorderSide.none),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: showDatePicker,
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
        ? 'yyyy/mm/dd' 
        : DateFormat('yyyy-MM-dd').format(date);
  }

  void onAdd(int patientID) {
    TextEditingController treatmentCtrl = TextEditingController();
    TextEditingController drugsCtrl = TextEditingController();

   
    selectedDate = DateTime.now();
    appointmentDateController.text = formatDate(selectedDate);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Patient Info',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: treatmentCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Treatment',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: drugsCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Drug',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildDateSelector(),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            
                            DateTime appointmentDate = isDateToday(selectedDate)
                                ? DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day)
                                : DateTime(selectedDate.year,
                                    selectedDate.month, selectedDate.day);

                           
                            DateTime nowDate = DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day);

                            
                            if (appointmentDate.isBefore(nowDate)) {
                              showResultMessage(
                                false,
                                message:
                                    'Appointment date cannot be in the past',
                              );
                              Navigator.pop(context);
                              return;
                            }

                            
                            bool hasContent =
                                drugsCtrl.text.trim().isNotEmpty ||
                                    treatmentCtrl.text.trim().isNotEmpty;
                            if (hasContent) {
                              await api.addPatienttoHistiry(
                                patientID,
                                date: DateTime.now(),
                                drug: drugsCtrl.text,
                                tratment: treatmentCtrl.text,
                              );
                            }

                           
                            var nextAppointments =
                                patientMapNotifier.value['nextAppointment'];

                            
                            bool isToday =
                                appointmentDate.year == nowDate.year &&
                                    appointmentDate.month == nowDate.month &&
                                    appointmentDate.day == nowDate.day;

                            if (nextAppointments != null &&
                                nextAppointments.isNotEmpty) {
                              int appointmentID =
                                  nextAppointments.first['appointmentID'];

                              
                              if (hasContent) {
                                patientMapNotifier
                                    .value['historyAppointments'] ??= [];
                                patientMapNotifier.value['historyAppointments']
                                    .add(nextAppointments.first);
                              }

                             
                              try {
                                await api
                                    .deleteFutureAppointment(appointmentID);
                              } catch (deleteError) {
                                debugPrint(
                                    'Error deleting appointment: $deleteError');
                              }

                              
                              patientMapNotifier.value['nextAppointment'] = [];

                            
                              if (!isToday) {
                                

                                await api.addPatientAppointment(
                                    patientID, appointmentDate);
                              } else {}
                            } else if (!isToday) {
                             

                              await api.addPatientAppointment(
                                  patientID, appointmentDate);
                            }

                            
                            if (!context.mounted) return;
                            Navigator.pop(context);

                            patientMapNotifier.value =
                                await api.getPatientByID(patientID);
                            reload();
                            setState(() {});
                          } catch (e) {
                            debugPrint('Error in appointment process: $e');

                            showResultMessage(
                              false,
                              message:
                                  'Failed to update appointment: ${e.toString()}',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPastDatePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPastCalendarWidget(onchooseDate: true),
            const SizedBox(height: 16),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedDate =
                        DateTime.now().subtract(const Duration(days: 1));
                    appointmentDateController.text = formatDate(selectedDate);
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  CupertinoCalendar buildPastCalendarWidget({bool onchooseDate = false}) {
    return CupertinoCalendar(
      onDateSelected: (value) {
        setState(() {
          selectedDate = value;
          appointmentDateController.text = formatDate(value);
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
          backgroundCircleColor:
              Color(0xFF47AEC6), 
          textStyle: TextStyle(fontSize: 15),
        ),
        selectedDayStyle: CalendarMonthPickerSelectedDayStyle(
          backgroundCircleColor:
              Color(0xFF47AEC6), 
          textStyle: TextStyle(fontSize: 15),
        ),
        defaultDayStyle: CalendarMonthPickerDefaultDayStyle(
          textStyle: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
      headerDecoration: CalendarHeaderDecoration(
        backwardButtonColor: Colors.black,
        forwardButtonColor: Colors.black,
        monthDateArrowColor: Color(0xFF47AEC6), 
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
      minimumDateTime: DateTime(2000),
      maximumDateTime: DateTime.now()
          .subtract(const Duration(days: 1)), 
    );
  }


  String formatPastDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }


  void onAddPastAppointment(int patientID) {
    TextEditingController treatmentCtrl = TextEditingController();
    TextEditingController drugsCtrl = TextEditingController();

    selectedDate = DateTime.now().subtract(const Duration(days: 1));
    appointmentDateController.text = formatPastDate(selectedDate);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Past Appointment',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: treatmentCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Treatment',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: drugsCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Drug',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
               
                TextField(
                  controller: appointmentDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Appointment Date',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: showPastDatePicker,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                           
                            DateTime appointmentDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day);

                           
                            DateTime nowDate = DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day);

                          
                            if (appointmentDate.isAfter(nowDate) ||
                                appointmentDate.isAtSameMomentAs(nowDate)) {
                              showResultMessage(
                                false,
                                message: 'Appointment date must be in the past',
                              );
                              Navigator.pop(context);
                              return;
                            }

                            
                            if (treatmentCtrl.text.trim().isEmpty &&
                                drugsCtrl.text.trim().isEmpty) {
                              showResultMessage(
                                false,
                                message:
                                    'Please enter treatment or drug information',
                              );
                              return;
                            }

                            await api.addPatienttoHistiry(
                              patientID,
                              date: appointmentDate,
                              drug: drugsCtrl.text,
                              tratment: treatmentCtrl.text,
                            );

                            if (!context.mounted) return;
                            Navigator.pop(context);

                            
                            patientMapNotifier.value =
                                await api.getPatientByID(patientID);
                            reload();
                            setState(() {});

                            showResultMessage(
                              true,
                              message: 'Past appointment added successfully',
                            );
                          } catch (e) {
                            debugPrint('Error adding past appointment: $e');

                            showResultMessage(
                              false,
                              message:
                                  'Failed to add past appointment: ${e.toString()}',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void edit(Map<String, dynamic> selectedPatient) {
    nameController.text = selectedPatient['pname'] ?? '';
    secondNameController.text = selectedPatient['psecondName'] ?? '';
    phoneController.text = selectedPatient['pphone'] ?? '';
    genderController.text = selectedPatient['pgender'] ?? '';
    ageController.text = selectedPatient['page'] ?? '';
    locationController.text = selectedPatient['plocation'] ?? '';
    diseaseController.text = selectedPatient['pdisease'] ?? '';
    skinTypeController.text = selectedPatient['skintype'] ?? '';
    allergiesController.text = selectedPatient['allergies'] ?? '';
    noteController.text = selectedPatient['pnote'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(10),
              child: Material(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Edit Patient', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration:
                                  InputDecoration(hintText: 'First Name'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: secondNameController,
                              decoration:
                                  InputDecoration(hintText: 'Last Name'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              decoration:
                                  InputDecoration(hintText: 'Phone Number'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: ageController,
                              decoration: InputDecoration(hintText: 'Age'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: locationController,
                        decoration: InputDecoration(hintText: 'Location'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: diseaseController,
                              decoration: InputDecoration(
                                  hintText: 'Disease/Condition'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: skinTypeController,
                              decoration:
                                  InputDecoration(hintText: 'Skin Type'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: allergiesController,
                        decoration: InputDecoration(hintText: 'Allergies'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: noteController,
                        maxLines: 5,
                        decoration: InputDecoration(hintText: 'Note'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text("Cancel",
                                style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    Map<String, dynamic> updatedFields = {};
                                    if (nameController.text.isNotEmpty)
                                      updatedFields['pname'] =
                                          nameController.text;
                                    if (secondNameController.text.isNotEmpty)
                                      updatedFields['psecondName'] =
                                          secondNameController.text;
                                    if (phoneController.text.isNotEmpty)
                                      updatedFields['pphone'] =
                                          phoneController.text;
                                    if (genderController.text.isNotEmpty)
                                      updatedFields['pgender'] =
                                          genderController.text;
                                    if (ageController.text.isNotEmpty)
                                      updatedFields['page'] =
                                          ageController.text;
                                    if (locationController.text.isNotEmpty)
                                      updatedFields['plocation'] =
                                          locationController.text;
                                    if (diseaseController.text.isNotEmpty)
                                      updatedFields['pdisease'] =
                                          diseaseController.text;
                                    if (skinTypeController.text.isNotEmpty)
                                      updatedFields['skinType'] =
                                          skinTypeController.text;
                                    if (allergiesController.text.isNotEmpty)
                                      updatedFields['allergies'] =
                                          allergiesController.text;
                                    if (noteController.text.isNotEmpty)
                                      updatedFields['pnote'] =
                                          noteController.text;

                                    if (updatedFields.isNotEmpty) {
                                      await api.updatePatient(
                                          selectedPatient['pid'],
                                          updatedFields);
                                    }
                                    patientMapNotifier.value =
                                        await api.getPatientByID(
                                            patientMapNotifier.value['pid']);

                                    reload();

                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (!context.mounted) return;
                                    Navigator.pop(context);

                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Patient updated successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    this.setState(
                                        () {}); 
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text("Save",
                                    style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return ValueListenableBuilder(
      valueListenable: isPatientShow,
      builder: (context, value, child) {
        return ValueListenableBuilder(
            valueListenable: reloadNotifier,
            builder: (context, value, child) => SingleChildScrollView(
                child: isPatientShow.value
                    ? _buildPatientProfile(screen)
                    : _buildPatientList(screen)));
      },
    );
  }

  Widget _buildPatientProfile(Size screen) {
    return ValueListenableBuilder(
      valueListenable: patientMapNotifier,
      builder: (context, value, child) => screen.width > 1200
          ? _buildBigScreenPatientProfile(screen)
          : _buildSmallScreenPatientProfile(screen),
    );
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

 
  Widget _buildPatientList(Size screen) {
    bool isMobile = screen.width < 500;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: SizedBox(
                child: const Text('Name'),
              ),
            ),
            Expanded(
              flex: 5,
              child: SizedBox(
                child: const Text('Phone Number'),
              ),
            ),
            Visibility(
              visible: !isMobile,
              child: Expanded(
                flex: 5,
                child: SizedBox(
                  child: const Text('Disease'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
        const Divider(),
        ValueListenableBuilder(
            valueListenable: reloadNotifier,
            builder: (context, value, child) {
              return FutureBuilder(
                future: patientsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No patients'));
                  } else {
                    final patients = snapshot.data!;
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                         
                          final patient = patients[index];
                          final String firstName =
                              patient['pname']?.toString() ?? '';
                          final String lastName =
                              patient['psecondName']?.toString() ?? '';
                          final String phoneNumber =
                              patient['pphone']?.toString() ?? '';
                          final String disease =
                              patient['pdisease']?.toString() ?? 'N/A';
                          final dynamic patientId = patient[
                              'pid']; 
                          return MouseRegion(
                            onEnter: (event) =>
                                setState(() => hoverIndex = index),
                            onExit: (event) => setState(() => hoverIndex = -1),
                            child: InkWell(
                              onTap: () {
                                patientMapNotifier.value = patient;
                                isPatientShow.value = true;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: hoverIndex == index
                                      ? Colors.black38
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: SizedBox(
                                        child: Text(
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          '$firstName $lastName',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: SizedBox(
                                        child: Text(phoneNumber),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !isMobile,
                                      child: Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          child: Text(disease),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          if (patientId != null) {
                                            final result = await api
                                                .deletePatient(patientId);
                                            reloadNotifier.value =
                                                !reloadNotifier.value;
                                            isPatientShow.value = false;
                                            patientsFuture =
                                                api.getAllPatients();

                                            setState(() {
                                              patients;
                                            });
                                            showResultMessage(result,
                                                message:
                                                    'Patient deleted successfully');
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            }),
      ],
    );
  }


  Widget _buildBigScreenPatientProfile(Size screen) {
    return SizedBox(
      width: screen.width,
      height: 700,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientProfileHeader(screen),
          _buildPatientProfileSubHeader(screen),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPatientProfileInfo(screen),
                SizedBox(width: 10),
                _buildPatientProfileNote(screen),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientProfileAppointmentList(screen),
                  SizedBox(width: 10),
                  _buildPatientProfileAppointmentDetail(screen),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallScreenPatientProfile(Size screen) {
    return SizedBox(
      width: screen.width,
      height: 1200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientProfileHeader(screen),
          _buildPatientProfileSubHeader(screen),
          SizedBox(
            width: double.infinity,
            height: 470,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPatientProfileInfo(screen),
                SizedBox(height: 10),
                _buildPatientProfileNote(screen),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientProfileAppointmentList(screen,
                      flex: 1, height: 130),
                  SizedBox(height: 10),
                  _buildPatientProfileAppointmentDetail(screen, flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPatientProfileHeader(Size screen) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              isPatientShow.value = false;
            },
          ),
          Spacer(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              onAdd(patientMapNotifier.value['pid']);
            },
          ),
          SizedBox(width: 10),
          IconButton(
              onPressed: () {
                edit(patientMapNotifier.value);
              },
              icon: const Icon(Icons.edit)),
          SizedBox(width: 10),
          IconButton(
              onPressed: () async {
                final patientId = patientMapNotifier.value['pid'];

                final aa = await api.deletePatient(patientId);
                reloadNotifier.value = !reloadNotifier.value;
                isPatientShow.value = false;
                setState(() {});
                showResultMessage(aa, message: 'Patient deleted successfully');
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }

  Widget _buildPatientProfileSubHeader(Size screen) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.person,
            size: 60,
          ),
          Text(
            '${patientMapNotifier.value['pname'] ?? ''} ${patientMapNotifier.value['psecondName'] ?? ''}',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientProfileInfo(Size screen) {
    return Expanded(
      child: Container(
        height: 230,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFC4D8D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            Text.rich(
              TextSpan(
                text: 'Phone: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: patientMapNotifier.value['pphone'] ?? 'Not Exist',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Age: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: patientMapNotifier.value['page'] ?? 'Not Exist',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Gender: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: patientMapNotifier.value['pgender'] ?? 'Not Exist',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Location: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: patientMapNotifier.value['plocation'] ?? 'Not Exist',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Disease: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: patientMapNotifier.value['pdisease'] ?? 'Not Exist',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Skin Type: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: patientMapNotifier.value['skintype'] ?? 'Not Exist',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Allergies: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: patientMapNotifier.value['allergies'] ?? 'N/A',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Next Appointment: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: _getNextAppointmentDate(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientProfileNote(Size screen) {
    return Expanded(
      child: Container(
        height: 230,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFC4D8D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Note',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '${patientMapNotifier.value['pnote'] ?? 'No notes available'}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientProfileAppointmentList(Size screen,
      {int flex = 1, double height = 170}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFC4D8D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Appointment History',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton.filled(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF47AEC6),
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        onAddPastAppointment(patientMapNotifier.value['pid']);
                      },
                      icon: Icon(Icons.add)),
                ),
              ],
            ),
            Divider(),
            _hasHistoryAppointments()
                ? SizedBox(
                    height: height,
                    child: ListView.builder(
                      itemCount: _getHistoryAppointmentLength(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedAppointment = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedAppointment == index
                                  ? Colors.black38
                                  : Colors.transparent,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              _getHistoryAppointmentDate(index) ??
                                  'Unknown Date',
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(child: Text('No History')),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientProfileAppointmentDetail(Size screen, {int flex = 3}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFC4D8D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            _hasHistoryAppointments() &&
                    selectedAppointment < _getHistoryAppointmentLength()
                ? Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Date: ${_getHistoryAppointmentDate(selectedAppointment) ?? 'Unknown'}'),
                          Text(
                              'Drug: ${_getHistoryAppointmentDrug(selectedAppointment) ?? 'None'}'),
                          Text(
                              'Treatment: ${_getHistoryAppointmentTreatment(selectedAppointment) ?? 'None'}'),
                        ],
                      ),
                    ],
                  )
                : const Center(child: Text('No History')),
          ],
        ),
      ),
    );
  }


  String _getNextAppointmentDate() {
    final nextAppointments = patientMapNotifier.value['nextAppointment'];
    if (nextAppointments == null ||
        !(nextAppointments is List) ||
        nextAppointments.isEmpty) {
      return 'No Next Appointment';
    }

    final appointment = nextAppointments.first;
    if (appointment == null ||
        !(appointment is Map) ||
        !appointment.containsKey('appointmentDate')) {
      return 'No Next Appointment';
    }

    return appointment['appointmentDate'] ?? 'No Date Set';
  }

  bool _hasHistoryAppointments() {
    final history = patientMapNotifier.value['historyAppointment'];
    return history != null && history is List && history.isNotEmpty;
  }

  int _getHistoryAppointmentLength() {
    final history = patientMapNotifier.value['historyAppointment'];
    if (history == null || !(history is List)) {
      return 0;
    }
    return history.length;
  }

  String? _getHistoryAppointmentDate(int index) {
    final history = patientMapNotifier.value['historyAppointment'];
    if (history == null ||
        !(history is List) ||
        history.isEmpty ||
        index >= history.length) {
      return null;
    }

    final appointment = history[index];
    if (appointment == null || !(appointment is Map)) {
      return null;
    }

    return appointment['appointmentHistoryDate'];
  }

  String? _getHistoryAppointmentDrug(int index) {
    final history = patientMapNotifier.value['historyAppointment'];
    if (history == null ||
        !(history is List) ||
        history.isEmpty ||
        index >= history.length) {
      return null;
    }

    final appointment = history[index];
    if (appointment == null || !(appointment is Map)) {
      return null;
    }

    return appointment['drug'];
  }

  String? _getHistoryAppointmentTreatment(int index) {
    final history = patientMapNotifier.value['historyAppointment'];
    if (history == null ||
        !(history is List) ||
        history.isEmpty ||
        index >= history.length) {
      return null;
    }

    final appointment = history[index];
    if (appointment == null || !(appointment is Map)) {
      return null;
    }

    return appointment['tratment'];
  }
}



