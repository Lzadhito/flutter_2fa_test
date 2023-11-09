import 'package:flutter/material.dart';

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
                Navigator.pop(context);
              },
              child: const Text('Back'))
        ],
      )),
    ));
  }
}
