import 'package:flutter/material.dart';
import '../widgets/user_info.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Info"),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body: UserInfo(),
    );
  }
}
