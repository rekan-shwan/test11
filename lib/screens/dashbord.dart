import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:doc_helin/Backend/api.dart';
import 'package:doc_helin/screens/main_screen.dart';
import 'package:doc_helin/util/dashbord_carts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize the future in initState
    _appointmentsFuture = fetchData(selectedDate);
  }

  void updateSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
      // Create a new future for the new date
      _appointmentsFuture = fetchData(date);
    });
  }

  Future<List<dynamic>> fetchData(DateTime selectedDate) async {
    try {
      // Format the selected date to midnight to ensure proper date comparison
      final formattedSelectedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      // Fetch all patients for the total count
      final allPatients = await api.getAllPatients();

      if (mounted) {
        setState(() {
          numberOfAllPatients = allPatients.length;
        });
      }

      // Fetch patients with appointments
      final patientsWithAppointments = await api.getPatientsWithAppointments();

      print(
          'Total patients with appointments: ${patientsWithAppointments.length}');

      // Filter the patients by selected date
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
          // Format to midnight for comparison (ignoring time component)
          final formattedAppointmentDate = DateTime(
            appointmentDate.year,
            appointmentDate.month,
            appointmentDate.day,
          );

          // Compare dates
          if (formattedAppointmentDate.year == formattedSelectedDate.year &&
              formattedAppointmentDate.month == formattedSelectedDate.month &&
              formattedAppointmentDate.day == formattedSelectedDate.day) {
            filteredPatients.add(patient);
          }
        } catch (e) {
          print("Error parsing date for patient ${patient['pname']}: $e");
        }
      }

      print(
          'Filtered patients for ${DateFormat('yyyy-MM-dd').format(selectedDate)}: ${filteredPatients.length}');
      setState(() {
        selectedDateAppointment = filteredPatients.length;
        totalAppointments = patientsWithAppointments.length;
      });

      // Return the filtered data
      return filteredPatients;
    } catch (error) {
      print("Error fetching data: $error");
      print("Exception details: ${error.toString()}");
      return [];
    }
  }

  void onAddPatint() {
    print('Add Patient');
    // Add your navigation or dialog to add a patient here
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
              title: 'Total Appointments',
              number: totalAppointments,
            )),
          ],
        ),
        SizedBox(height: 20),
        Container(
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
              title: 'Total Appointments',
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
          // List of patients with appointments
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
                              ? Color(0xFF47AEC6).withOpacity(0.1)
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
