import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  static const String routeName = "user-profile-screen";
  static const String routePath = "user-profile-screen";
  @override
  Widget build(BuildContext context) {
    return const UserProfileScreenBody();
  }
}

class UserProfileScreenBody extends StatefulWidget {
  const UserProfileScreenBody({super.key});

  @override
  State<UserProfileScreenBody> createState() => _UserProfileScreenBodyState();
}

class _UserProfileScreenBodyState extends State<UserProfileScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
