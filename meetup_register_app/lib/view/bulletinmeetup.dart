import 'package:flutter/material.dart';

class BulletinMeetUp extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const BulletinMeetUp({super.key, required this.onChangeTheme});

  @override
  State<BulletinMeetUp> createState() => _BulletinMeetUpState();
}

class _BulletinMeetUpState extends State<BulletinMeetUp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
