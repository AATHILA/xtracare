import 'package:flutter/material.dart';

class ProfilesWidget extends StatefulWidget {
  const ProfilesWidget({super.key});

  @override
  State<ProfilesWidget> createState() => _ProfilesWidgetState();
}

class _ProfilesWidgetState extends State<ProfilesWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Profile"),
    );
  }
}
