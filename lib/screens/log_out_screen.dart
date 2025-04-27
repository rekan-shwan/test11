import 'package:doc_helin/Backend/api.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogOutScreen extends StatelessWidget {
  const LogOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            context.go('/');
            removeToken();
          },
          child: Text('Log Out')),
    );
  }
}
