import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TabButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;

  const TabButton({
    super.key,
    required this.icon,
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
        dimension: 70,
        child: Container(
          decoration: BoxDecoration(
              color: active ? null : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border:
                  active ? Border.all(width: 2, color: Colors.white) : null),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color:
                      active ? Colors.white : Theme.of(context).primaryColor),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: active ? null : Theme.of(context).primaryColor),
                ),
              )
            ],
          ),
        ));
  }
}
