import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kominfo_dashboard_test/login/class/auth.dart';

import 'widgets/dashboard_header.dart';

List<String> titles = <String>[
  'Cloud',
  'Beach',
  'Sunny',
];

class ListItem {
  final String title;
  final String subtitle;

  const ListItem({
    required this.title,
    required this.subtitle,
  });
}

List<ListItem> items = [
  const ListItem(title: "Title1", subtitle: "Lorem ipsum sir dolor amet"),
  const ListItem(title: "Title2", subtitle: "Lorem ipsum sir dolor amet"),
  const ListItem(title: "Title3", subtitle: "Lorem ipsum sir dolor amet"),
  const ListItem(title: "Title4", subtitle: "Lorem ipsum sir dolor amet"),
  const ListItem(title: "Title5", subtitle: "Lorem ipsum sir dolor amet"),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Text('Selamat Datang'),
        actions: [
          IconButton(
              onPressed: () => {},
              icon: const Icon(
                Icons.account_circle_outlined,
                size: 25,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengajuan',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'List pengajuan yang aktif',
                  style: TextStyle(color: Colors.grey),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.subtitle),
                    );
                  },
                ),
              ],
            ),
          ),
          const Gap(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Auth.logout(context);
                  },
                  child: const Text('Logout')),
            ],
          )
        ],
      ),
    ));
  }
}
