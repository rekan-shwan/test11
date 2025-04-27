import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:doc_helin/Backend/api.dart';
import 'package:doc_helin/screens/add_new_patient.dart';
import 'package:doc_helin/screens/main_screen.dart';
import 'package:doc_helin/util/dashbord_carts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({super.key});

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  Api api = Api();
  DateTime selectedDate = DateTime.now();
  List<dynamic> patientsAppointmentByDate = [];
  int numberOfAllPatients = 0;
  int selectedDateAppointment = 0;
  int totalAppointments = 0;
  late Future<List<dynamic>> _appointmentsFuture;
  int hoverIndex = -1;
  String errorPhone = '';
  bool isPhoneExest = false;

  TextEditingController phoneNumberCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _appointmentsFuture = fetchData(selectedDate);
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

  void updateSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    
      _appointmentsFuture = fetchData(date);
    });
  }

  Future<List<dynamic>> fetchData(DateTime selectedDate) async {
    try {
     
      final formattedSelectedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      
      final allPatients = await api.getAllPatients();

      if (mounted) {
        setState(() {
          numberOfAllPatients = allPatients.length;
        });
      }

      
      final patientsWithAppointments = await api.getPatientsWithAppointments();

     
      List<dynamic> filteredPatients = [];

      for (var patient in patientsWithAppointments) {
        if (patient['nextAppointment'] == null ||
            !(patient['nextAppointment'] is List) ||
            patient['nextAppointment'].isEmpty) {
          continue;
        }

        try {
          final appointmentDateStr =
              patient['nextAppointment'].first['appointmentDate'];
          if (appointmentDateStr == null || appointmentDateStr.isEmpty) {
            continue;
          }

          final appointmentDate = DateTime.parse(appointmentDateStr);
         
          final formattedAppointmentDate = DateTime(
            appointmentDate.year,
            appointmentDate.month,
            appointmentDate.day,
          );

         
          if (formattedAppointmentDate.year == formattedSelectedDate.year &&
              formattedAppointmentDate.month == formattedSelectedDate.month &&
              formattedAppointmentDate.day == formattedSelectedDate.day) {
            filteredPatients.add(patient);
          }
        } catch (e) {
          debugPrint('Error filtering patients: $e');
        }
      }

      setState(() {
        selectedDateAppointment = filteredPatients.length;
        totalAppointments = patientsWithAppointments.length;
      });

     
      return filteredPatients;
    } catch (error) {
      return [];
    }
  }

  Future<Map<String, dynamic>> onPhoneCahnge() async {
    if (phoneNumberCtrl.text.length == 11) {
      try {
        final value = await api.searchByPhone(phoneNumberCtrl.text);

        if (!context.mounted) return {}; 

        setState(() {
          isPhoneExest = value.isNotEmpty;
        });

        return value;
      } catch (e) {
        return {};
      }
    } else {
      if (!context.mounted) return {};

      setState(() {
        isPhoneExest = false;
      });
      return {};
    }
  }

  void addPatient(Size screen) {
    phoneNumberCtrl.clear();
    bool isLoading = false; 
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: screen.width * 0.9,
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  width: screen.width > 600
                      ? screen.width * 0.6
                      : screen.width * 0.9,
                  height: screen.height * 0.6,
                  color: Color(0xFFDEEAEA),
                  padding: EdgeInsets.all(50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    spacing: 20,
                    children: [
                      Text(
                        'Add a Patient',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextField(
                          controller: phoneNumberCtrl,
                          onChanged: (value) async {
                            setState(() {
                              isLoading = true; 
                              errorPhone = ''; 
                            });
                            await onPhoneCahnge(); 
                            setState(() {
                              isLoading = false; 
                              errorPhone = ''; 
                            });
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          decoration: InputDecoration(
                            fillColor: Colors.black12,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(0)),
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.black45),
                          ),
                        ),
                      ),
                      isLoading
                          ? CircularProgressIndicator() 
                          : Text(errorPhone),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.red),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.green),
                              ),
                              onPressed: () async {
                                if (phoneNumberCtrl.text.length < 11) {
                                  setState(() {
                                    errorPhone = 'Phone number is too short';
                                  });
                                  return;
                                }
                                if (isLoading) {
                                  setState(() {
                                    errorPhone = 'Loading...';
                                  });
                                }
                                if (isPhoneExest == false) {
                                  Navigator.pop(context);

                                  addnewPatientDialog(phoneNumberCtrl.text);

                                  setState(() {
                                    errorPhone = '';
                                  });
                                } else if (isPhoneExest == true) {
                                  try {
                                  

                                    final patientData = await api
                                        .searchByPhone(phoneNumberCtrl.text)
                                        .then((value) =>
                                            Map<String, dynamic>.from(value))
                                        .then((data) {
                                      selectedNavigation.value = 1;
                                      patientMapNotifier.value = data;
                                      isPatientShow.value = true;
                                    });

                                   
                                    if (patientData != null &&
                                        patientData.isNotEmpty) {
                                     
                                      await Future.delayed(
                                          Duration(seconds: 1));

                                      if (context.mounted) {}
                                    } else {}
                                  } catch (e) {
                                    debugPrint(
                                        'Error fetching patient data: $e');
                                  }
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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

  void addnewPatientDialog(String phone) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(10),
          child: SizedBox(
            child: Material(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.96,
                  width: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.9
                      : MediaQuery.of(context).size.width * 0.99,
                  child: PatientRegistrationScreen(phoneNum: phone)),
            ),
          ),
        );
      },
    );
  }

  void onAddPatint() {
    
    addPatient(MediaQuery.of(context).size);

    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Dialog(
    //       child: Material(
    //         child: SizedBox(
    //             height: MediaQuery.of(context).size.height * 0.96,
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             child: PatientRegistrationScreen(phoneNum: '83298')),
    //       ),
    //     );
    //   },
    // );
  }

  String _showDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  CupertinoCalendar theCalenderWidget() {
    return CupertinoCalendar(
      onDateSelected: (value) {
        updateSelectedDate(value);
      },
      firstDayOfWeekIndex: 6,
      maxWidth: 900,
      footerDecoration: CalendarFooterDecoration(
        dayPeriodTextStyle: TextStyle(
          fontSize: 39,
          color: Colors.black,
        ),
      ),
      monthPickerDecoration: CalendarMonthPickerDecoration(
        selectedCurrentDayStyle: CalendarMonthPickerSelectedCurrentDayStyle(
          backgroundCircleColor: const Color(0xFF47AEC6),
          textStyle: TextStyle(
            fontSize: 12,
          ),
        ),
        selectedDayStyle: CalendarMonthPickerSelectedDayStyle(
          backgroundCircleColor: const Color(0xFF47AEC6),
          textStyle: TextStyle(fontSize: 12),
        ),
        defaultDayStyle: CalendarMonthPickerDefaultDayStyle(
          textStyle: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
      headerDecoration: CalendarHeaderDecoration(
        backwardButtonColor: Colors.black,
        forwardButtonColor: Colors.black,
        monthDateArrowColor: Colors.black,
        monthDateStyle: TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
      ),
      type: CupertinoCalendarType.inline,
      mode: CupertinoCalendarMode.date,
      weekdayDecoration: CalendarWeekdayDecoration(
        textStyle: TextStyle(
          fontSize: 12,
          color: const Color.fromARGB(129, 0, 0, 0),
        ),
      ),
      minimumDateTime: DateTime(DateTime.now().year),
      maximumDateTime: DateTime(DateTime.now().year + 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    return screen.width > 940
        ? _buildBigScreen(screen, api)
        : _buildSmallScreen(screen, api);
  }

  Widget _buildBigScreen(Size screen, Api api) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: DashbordCarts(
              title: 'All Patients',
              number: numberOfAllPatients,
              icon: CupertinoIcons.group_solid,
            )),
            SizedBox(width: 10),
            Expanded(
                child: DashbordCarts(
              icon: CupertinoIcons.person_2_fill,
              title:
                  "${DateFormat('yyyy-MM-dd').format(selectedDate) == _showDate(DateTime.now()) ? 'Today' : _showDate(selectedDate)}'s Appointments",
              number: selectedDateAppointment,
            )),
            SizedBox(width: 10),
            Expanded(
                child: DashbordCarts(
              icon: Icons.timelapse_sharp,
              title: 'Appointments',
              number: totalAppointments,
            )),
          ],
        ),
        SizedBox(height: 20),
        SizedBox(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildListAppointmentPatientList(screen, api),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                      height: 370,
                      decoration: BoxDecoration(
                          color: Color(0xFFDEEAEA),
                          borderRadius: BorderRadius.circular(10)),
                      child: theCalenderWidget())),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScreen(Size screen, Api api) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: DashbordCarts(
              title: 'All Patients',
              number: numberOfAllPatients,
              icon: CupertinoIcons.group_solid,
            )),
            SizedBox(width: 10),
            SizedBox(width: 10),
            Expanded(
                child: DashbordCarts(
              icon: Icons.timelapse_sharp,
              title: 'Appointments',
              number: totalAppointments,
            )),
          ],
        ),
        SizedBox(height: 20),
        DashbordCarts(
          width: double.infinity,
          icon: CupertinoIcons.person_2_fill,
          title:
              "${DateFormat('yyyy-MM-dd').format(selectedDate) == _showDate(DateTime.now()) ? 'Today' : _showDate(selectedDate)}'s Appointments",
          number: selectedDateAppointment,
        ),
        SizedBox(height: 20),
        _buildListAppointmentPatientList(screen, api),
        SizedBox(width: 10),
        Container(
            height: 370,
            decoration: BoxDecoration(
                color: Color(0xFFDEEAEA),
                borderRadius: BorderRadius.circular(10)),
            child: theCalenderWidget()),
      ],
    );
  }

  Widget _buildListAppointmentPatientList(Size screen, Api api) {
    return Container(
      height: 370,
      margin: EdgeInsets.symmetric(vertical: 14),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFDEEAEA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text.rich(
                TextSpan(
                  text:
                      '${DateFormat('yyyy-MM-dd').format(selectedDate) == _showDate(DateTime.now()) ? 'Today' : _showDate(selectedDate)} ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(
                      text: 'Appointment List',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: 40,
                height: 20,
                child: IconButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    backgroundColor: Color(0xFF47AEC6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: onAddPatint,
                  icon: Icon(
                    Icons.add,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.black26,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Text('Name',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 5,
                  child: Text('Phone Number',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Visibility(
                visible: screen.width > 650,
                child: Expanded(
                    flex: 5,
                    child: Text('Deasease',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ),
              Expanded(flex: 1, child: SizedBox()),
            ],
          ),
          SizedBox(height: 10),
          
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _appointmentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF47AEC6),
                        ),
                        SizedBox(height: 16),
                        Text('Loading appointments...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Error loading appointments: ${snapshot.error}'),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _appointmentsFuture = fetchData(selectedDate);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF47AEC6),
                          ),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final patients = snapshot.data ?? [];

                if (patients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No appointments found for this date',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return MouseRegion(
                      onEnter: (event) {
                        setState(() {
                          hoverIndex = index;
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          hoverIndex = -1;
                        });
                      },
                      child: InkWell(
                        onTap: () {
                          selectedNavigation.value = 1;
                          isPatientShow.value = true;
                          patientMapNotifier.value = patient;
                        },
                        child: Container(
                          color: hoverIndex == index
                              ? Color.fromARGB(138, 71, 175, 198)
                              : Colors.transparent,
                          margin: EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    patient['pname'] ?? 'N/A',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(patient['pphone'] ?? 'N/A'),
                                ),
                                Visibility(
                                  visible: screen.width > 650,
                                  child: Expanded(
                                    flex: 5,
                                    child: Text(patient['pdisease'] ?? 'N/A'),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 18,
                                    color: Color(0xFF47AEC6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
