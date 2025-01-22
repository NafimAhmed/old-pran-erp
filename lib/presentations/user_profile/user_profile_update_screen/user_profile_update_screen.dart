import 'package:flutter/material.dart';

class UserProfileUpdateScreen extends StatelessWidget {
  const UserProfileUpdateScreen({super.key});
  static const String routeName = "user-profile-update-screen";
  static const String routePath = "user-profile-update-screen";
  @override
  Widget build(BuildContext context) {
    return const UserProfileUpdateScreenBody();
  }
}

class UserProfileUpdateScreenBody extends StatefulWidget {
  const UserProfileUpdateScreenBody({super.key});

  @override
  State<UserProfileUpdateScreenBody> createState() =>
      _UserProfileUpdateScreenBodyState();
}

class _UserProfileUpdateScreenBodyState
    extends State<UserProfileUpdateScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
