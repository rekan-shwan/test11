import 'package:doc_helin/screens/main_screen.dart';
import 'package:doc_helin/screens/sign_in.dart';
import 'package:doc_helin/util/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MainApp());
}

String token = '';

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final GoRouter route = GoRouter(routes: [
    GoRoute(path: '/', builder: (context, state) => SignIn()),
    GoRoute(path: '/home', builder: (context, state) => MainScreen())
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: route,
      theme: MyTheme.them(),
    );
  }
}
