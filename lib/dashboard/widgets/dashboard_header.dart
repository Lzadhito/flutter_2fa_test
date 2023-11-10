import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kominfo_dashboard_test/dashboard/widgets/tab_button.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(10))),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
      child: const DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('John Doe'),
                  Gap(10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TabButton(
                            icon: Icons.email_rounded,
                            title: 'Email',
                            active: true),
                        TabButton(icon: Icons.qr_code_rounded, title: 'TTE'),
                        TabButton(
                            icon: Icons.lan_rounded, title: 'Virtual Meeting'),
                        TabButton(
                            icon: Icons.public_rounded, title: 'Sub Domain'),
                      ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
