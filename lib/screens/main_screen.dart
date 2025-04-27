import 'package:doc_helin/Backend/api.dart';
import 'package:doc_helin/screens/add_new_patient.dart';
import 'package:doc_helin/screens/dashbord.dart';
import 'package:doc_helin/screens/log_out_screen.dart';
import 'package:doc_helin/screens/patients.dart';
import 'package:doc_helin/util/drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

ValueNotifier<bool> reloadNotifier = ValueNotifier(false);
ValueNotifier<int> selectedNavigation = ValueNotifier(0);
ValueNotifier<bool> isPatientShow = ValueNotifier(false);
ValueNotifier<String> patientPhone = ValueNotifier('');
ValueNotifier<Map<String, dynamic>> patientMapNotifier = ValueNotifier({});

//   "allergies": "aaaa",
//   "skinType": "oil",
//   "nextAppointment": [
//     {"appointmentID": 4, "patientID": 6, "appointmentDate": "2025-03-18"},
//     {"appointmentID": 8, "patientID": 6, "appointmentDate": "2025-03-17"}
//   ],
//   "historyAppointment": [
//     {
//       "appintmentHistoryID": 5,
//       "patientID": 6,
//       "appointmentHistoryDate": "2025-03-18",
//       "drug": "aasef",
//       "appointmentDetail": "efou093u29",
//       "isVisited": true,
//       "tratment": "bbab"
//     },
//     {
//       "appintmentHistoryID": 5,
//       "patientID": 6,
//       "appointmentHistoryDate": "2025-03-18",
//       "drug": "aasef",
//       "appointmentDetail": "efou093u29",
//       "isVisited": true,
//       "tratment": "bbab"
//     },
//     {
//       "appintmentHistoryID": 5,
//       "patientID": 6,
//       "appointmentHistoryDate": "2025-03-18",
//       "drug": "aasef",
//       "appointmentDetail": "efou093u29",
//       "isVisited": true,
//       "tratment": "bbab"
//     },
//     {
//       "appintmentHistoryID": 5,
//       "patientID": 6,
//       "appointmentHistoryDate": "2025-03-18",
//       "drug": "aasef",
//       "appointmentDetail": "efou093u29",
//       "isVisited": true,
//       "tratment": "bbab"
//     },
//     {
//       "appintmentHistoryID": 5,
//       "patientID": 6,
//       "appointmentHistoryDate": "2025-03-18",
//       "drug": "aasef",
//       "appointmentDetail": "efou093u29",
//       "isVisited": true,
//       "tratment": "bbab"
//     },
//     {
//       "appintmentHistoryID": 5,
//       "patientID": 6,
//       "appointmentHistoryDate": "2025-03-18",
//       "drug": "aasef",
//       "appointmentDetail": "efou093u29",
//       "isVisited": true,
//       "tratment": "bbab"
//     },
//     {
//       "appintmentHistoryID": 10,
//       "patientID": 6,
//       "appointmentHistoryDate": "2025-03-17",
//       "drug": "",
//       "appointmentDetail": "",
//       "isVisited": true,
//       "tratment": ""
//     },
//     {
//       "appintmentHistoryID": 11,
//       "patientID": 6,
//       "appointmentHistoryDate": "2025-03-17",
//       "drug": "",
//       "appointmentDetail": "",
//       "isVisited": true,
//       "tratment": ""
//     }
//   ],
//   "pid": 6,
//   "psecondName": " azaddd",
//   "pdisease": "nyaty",
//   "plocation": "sulaimany",
//   "pgender": "gender",
//   "pname": "mahmuuuud",
//   "pphone": "92309280923",
//   "page": "92",
//   "pnote": "efou093u29"
// });

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> _navigationItems = [
    {
      'name': 'Dashboard',
      'icon': Icons.dashboard_outlined,
      'widget': Dashbord(),
      'description': 'Welcome Dr.Helin',
    },
    {
      'name': 'Patients',
      'icon': CupertinoIcons.group_solid,
      'widget': Patients(),
      'description': 'Manage patients',
    },
    // {
    //   'name': 'Reports',
    //   'icon': Icons.show_chart_sharp,
    //   'widget': Center(
    //     child: ReportSection(),
    //   ),
    //   'description': 'Settings',
    // },
    // {
    //   'name': 'Settings',
    //   'icon': Icons.settings,
    //   'widget': Center(
    //     child: SettingsScreen(),
    //   ),
    //   'description': 'Settings',
    // },
    // {
    //   'name': 'Services',
    //   'icon': Icons.add_chart_sharp,
    //   'widget': Center(
    //     child: ServicesScreen(),
    //   ),
    //   'description': 'Services',
    // },
    {
      'name': 'Log out',
      'icon': Icons.login_rounded,
      'widget': LogOutScreen(),
      'description': 'Log out',
    },
  ];
  late Future<List<dynamic>> fetchDate;
  bool isSearchOpen = false;
  TextEditingController phoneNumberCtrl = TextEditingController();
  String errorPhone = '';
  bool isPhoneExest = false;

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
                                    debugPrint('Error fetching patient: $e');
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

  ScrollController scrollController = ScrollController();
  Api api = Api();
  List searchList = [];

  void reload() {
    reloadNotifier.value = !reloadNotifier.value;
  }

  @override
  void initState() {
    super.initState();
    fetchDate = api.getAllPatients();
    reloadNotifier.addListener(() {
      fetchDate = api.getAllPatients();
    });
  }

  Future<List<dynamic>> fetchPatients() async {
    try {
      return api.getAllPatients();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    bool bigScreen = screen.width > 1000;
    bool midScreen = screen.width > 700;
    bool smallScreen = screen.width < 700;

    return ValueListenableBuilder(
        valueListenable: reloadNotifier,
        builder: (context, value, child) {
          return Scaffold(
            key: scaffoldKey,
            endDrawer: Drawer(
              backgroundColor: const Color(0xFF263D43),
              width: 150,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5)),
              ),
              child: ListView.builder(
                itemCount: _navigationItems.length,
                itemBuilder: (context, index) {
                  final item = _navigationItems[index];
                  final bool isSelected = selectedNavigation.value == index;

                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: () {
                        selectedNavigation.value = index;
                        Navigator.pop(context); 
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color.fromARGB(74, 218, 218, 218)
                              : null,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text(
                                item['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(item['icon'], color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            body: FutureBuilder(
              future: fetchDate,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }

                return ValueListenableBuilder(
                    valueListenable: selectedNavigation,
                    builder: (context, value, child) {
                      return SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bigScreen
                                ? _bigNavigation(screen)
                                : midScreen
                                    ? _smallNavigation(screen)
                                    : SizedBox(),
                            Expanded(
                                child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Scrollbar(
                                controller: scrollController,
                                thumbVisibility: false,
                                trackVisibility: false,
                                thickness: 0,
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${_navigationItems[value]['description']}',
                                              style: TextStyle(
                                                  fontSize:
                                                      smallScreen ? 20 : 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Visibility(
                                                visible: !smallScreen ||
                                                    !isSearchOpen,
                                                child: SizedBox(
                                                  width: smallScreen ? 25 : 35,
                                                  height: smallScreen ? 25 : 35,
                                                  child: IconButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor: Colors
                                                            .white, 
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF47AEC6),
                                                      ),
                                                      onPressed: () {
                                                        onAddPatint();
                                                      },
                                                      icon: Icon(Icons.add)),
                                                )),
                                            SizedBox(width: 10),
                                            Visibility(
                                                visible: smallScreen &&
                                                    !isSearchOpen,
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isSearchOpen =
                                                            !isSearchOpen;
                                                      });
                                                    },
                                                    icon: Icon(Icons.search))),
                                            Visibility(
                                              visible: bigScreen || midScreen
                                                  ? true
                                                  : smallScreen && isSearchOpen,
                                              child: DropDown(
                                                fetchData: fetchPatients,
                                                containerWidth:
                                                    smallScreen ? 150 : 300,
                                                containerHieght: 40,
                                                isSearch: true,
                                                onCanle: () {
                                                  setState(() {
                                                    isSearchOpen = false;
                                                  });
                                                },
                                                hintText: 'Search ',
                                                prefixIcon: Icon(Icons.search),
                                                icon: Icons.search,
                                                textEditingController:
                                                    TextEditingController(),
                                                onChoose: (value) {
                                                  patientMapNotifier.value =
                                                      value;
                                                  isPatientShow.value = true;
                                                  selectedNavigation.value = 1;
                                                  setState(() {
                                                    isSearchOpen = false;
                                                  });
                                                },
                                                overlayPortalController:
                                                    OverlayPortalController(),
                                              ),
                                            ),
                                            smallScreen
                                                ? IconButton(
                                                    onPressed: () {
                                                      scaffoldKey.currentState!
                                                          .openEndDrawer();
                                                    },
                                                    icon: Icon(Icons.menu))
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: selectedNavigation.value == 0
                                              ? null
                                              : Color(0xFFDEEAEA),
                                        ),
                                        child: _navigationItems[value]
                                            ['widget'],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
          );
        });
  }

  Widget _bigNavigation(Size size) {
    return Container(
      height: double.infinity,
      width: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF263D43),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 100), 
              Expanded(
                child: ListView.builder(
                  itemCount: _navigationItems.length - 1, 
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () async {
                          try {
                            List<dynamic> patients = await api.getAllPatients();
                            patientMapNotifier.value = patients[0];
                          } catch (e) {
                            debugPrint('Error fetching patients: $e');
                          }

                          isPatientShow.value = false;
                          selectedNavigation.value = index;
                          reloadNotifier.value = !reloadNotifier.value;
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: selectedNavigation.value == index
                                  ? Colors.white24
                                  : Colors.transparent,
                            ),
                            height: 50,
                            child: Row(
                              children: [
                                Icon(
                                  _navigationItems[index]['icon'],
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(_navigationItems[index]['name'],
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            )));
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                context.go('/');
                removeToken();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: selectedNavigation.value == _navigationItems.length - 1
                      ? Colors.white24
                      : Colors.transparent,
                ),
                height: 50,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      _navigationItems.last['icon'],
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _navigationItems.last['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallNavigation(Size size) {
    return Container(
      height: double.infinity,
      width: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF263D43),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 100),
              Expanded(
                child: ListView.builder(
                  itemCount: _navigationItems.length - 1,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          selectedNavigation.value = index;
                          reloadNotifier.value = !reloadNotifier.value;
                          isPatientShow.value = false;
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: selectedNavigation.value == index
                                  ? Colors.white24
                                  : Colors.transparent,
                            ),
                            height: 50,
                            child: Icon(
                              _navigationItems[index]['icon'],
                              color: Colors.white,
                            )));
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                context.go('/');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: selectedNavigation.value == _navigationItems.length - 1
                      ? Colors.white24
                      : Colors.transparent,
                ),
                height: 50,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      _navigationItems.last['icon'],
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
