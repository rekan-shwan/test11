import 'dart:math';

import 'package:doc_helin/Backend/api.dart';
import 'package:doc_helin/screens/main_screen.dart';
import 'package:flutter/material.dart';

class Patients extends StatefulWidget {
  const Patients({super.key});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  int hoverIndex = -1;
  Api api = Api();
  Future<List<dynamic>>? patientsFuture;

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
      builder: (context, value, child) => screen.width > 900
          ? _buildBigScreenPatientProfile(screen)
          : _buildSmallScreenPatientProfile(screen),
    );
  }

  //List of patints
  Widget _buildPatientList(Size screen) {
    bool isMobile = screen.width < 500;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                child: const Text('Name'),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: const Text('Phone Number'),
              ),
            ),
            Visibility(
              visible: isMobile,
              child: Expanded(
                flex: 5,
                child: Container(
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
        FutureBuilder(
          future: patientsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            } else if (snapshot.data!.isEmpty) {
              return const Center(child: Text('No patients'));
            } else {
              final patients = snapshot.data;
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return MouseRegion(
                      onEnter: (event) => setState(() => hoverIndex = index),
                      onExit: (event) => setState(() => hoverIndex = -1),
                      child: InkWell(
                        onTap: () {
                          patientMapNotifier.value = snapshot.data?[index];
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
                                child: Container(
                                  child: Text(
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      '${snapshot.data?[index]['pname']} ${snapshot.data?[index]['psecondName']}'),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Text(snapshot.data?[index]['pphone']),
                                ),
                              ),
                              Visibility(
                                visible: isMobile,
                                child: Expanded(
                                  flex: 5,
                                  child: Container(
                                    child:
                                        Text(snapshot.data?[index]['pdisease']),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    api.deletePatient(
                                        snapshot.data?[index]['pid']);
                                    reloadNotifier.value =
                                        !reloadNotifier.value;
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
        ),
      ],
    );
  }

//patient profile screen
  Widget _buildBigScreenPatientProfile(Size screen) {
    return Container(
      width: screen.width,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientProfileHeader(screen),
          _buildPatientProfileSubHeader(screen),
          Container(
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
            child: Container(
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
    return Container(
      width: screen.width,
      height: 1000,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientProfileHeader(screen),
          _buildPatientProfileSubHeader(screen),
          Container(
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
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientProfileAppointmentList(screen,
                      flex: 1, height: 140),
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

  //Patient profile  parts
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
            onPressed: () {},
          ),
          SizedBox(width: 10),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          SizedBox(width: 10),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
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
                    text: patientMapNotifier.value['skinType'] ?? 'Not Exist',
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
            Text(
              '${patientMapNotifier.value['pnote'] ?? 'No notes available'}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientProfileAppointmentList(Size screen,
      {int flex = 1, double height = 180}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFC4D8D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              'Appointment History',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                      Spacer(),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 60),
                          child: Icon(
                            Icons.image,
                            size: 70,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(child: Text('No History')),
          ],
        ),
      ),
    );
  }

// Helper methods to safely access patient data
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
