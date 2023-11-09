import 'package:flutter/material.dart';
import 'package:kominfo_dashboard_test/login/class/auth.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Text('Hello ini dashboard!'),
          TextButton(
              onPressed: () {
                Auth.logout(context);
              },
              child: const Text('Back'))
        ],
      )),
    ));
  }
}
