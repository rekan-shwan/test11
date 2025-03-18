import 'package:doc_helin/Backend/api.dart';
import 'package:doc_helin/screens/dashbord.dart';
import 'package:doc_helin/screens/patients.dart';
import 'package:doc_helin/util/drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

ValueNotifier<bool> reloadNotifier = ValueNotifier(false);
ValueNotifier<int> selectedNavigation = ValueNotifier(0);
ValueNotifier<bool> isPatientShow = ValueNotifier(true);
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
    {
      'name': 'Settings',
      'icon': Icons.settings,
      'widget': Center(
        child: Text('Available soon'),
      ),
      'description': 'Settings',
    },
    {
      'name': 'Services',
      'icon': Icons.add_chart_sharp,
      'widget': Center(
        child: Text('Available soon'),
      ),
      'description': 'Services',
    },
    {
      'name': 'Log out',
      'icon': Icons.account_circle_sharp,
      'widget': Text('Account'),
      'description': 'Log out',
    },
  ];
  late Future<List<dynamic>> fetchDate;

  ScrollController scrollController = ScrollController();
  Api api = Api();

  void _reload() {
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

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    bool bigScreen = screen.width > 1000;
    bool midScreen = screen.width > 700;
    bool smallScreen = screen.width < 550;

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
                        Navigator.pop(context); // Close drawer after selection
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
                      return Container(
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
                                      Container(
                                        height: 100,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${_navigationItems[value]['description']}',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            DropDown(
                                              isIcon: smallScreen,
                                              isSearch: false,
                                              hintText:
                                                  'Search ${screen.width}',
                                              prefixIcon: Icon(Icons.search),
                                              icon: Icons.search,
                                              textEditingController:
                                                  TextEditingController(),
                                              onChoose: (value) {},
                                              list: ['s'],
                                              overlayPortalController:
                                                  OverlayPortalController(),
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
              const SizedBox(height: 100), // Space for app bar/logo
              Expanded(
                child: ListView.builder(
                  itemCount: _navigationItems.length - 1, // Exclude logout
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () async {
                          try {
                            List<dynamic> patients = await api.getAllPatients();
                            patientMapNotifier.value = patients[0];
                          } catch (e) {}
                          print(await api.getAllPatients());

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
              const SizedBox(height: 100), // Space for app bar/logo
              Expanded(
                child: ListView.builder(
                  itemCount: _navigationItems.length - 1, // Exclude logout
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () => selectedNavigation.value = index,
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
