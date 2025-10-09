import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_client.dart';
import '../../../data/models/auth/me_response.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  MeResponse? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
      return;
    }

    try {
      final repo = AuthRepository(AuthService(ApiClient()));
      final user = await repo.me(token);
      if (!mounted) return;
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      await prefs.remove('token');
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 60,
                // backgroundImage: _user!.avatarUrl != null
                //     ? NetworkImage(_user!.avatarUrl!)
                //     : const AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                _user!.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),

              // Email
              Text(
                _user!.mail,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Info card
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow("Role", _user!.role),
                      _infoRow("Merit Level", _user!.meritLevel.toString()),
                      _infoRow("Experience Points", _user!.experiencePoints.toString()),
                      _infoRow("Gender", _user!.gender == 0 ? "Male" : "Female"),
                      _infoRow("ID", _user!.id),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Logout button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
