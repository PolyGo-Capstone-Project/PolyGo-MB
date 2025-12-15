import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/apis/auth_service.dart';
import '../../data/services/signalr/user_presence.dart';
import '../../main.dart';
import '../../routes/app_routes.dart';
import '../api/api_client.dart';

// Future<void> forceLogout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('token');
//
//   globalNavigatorKey.currentState?.pushNamedAndRemoveUntil(
//     AppRoutes.login,
//         (route) => false,
//   );
// }

Future<void> forceLogout() async {
  try {
    // Stop presence / socket
    await UserPresenceManager().stop();

    // Logout Google (SAFE kể cả chưa login Google)
    await AuthService(ApiClient()).googleSignOut();

    // Clear toàn bộ session local
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate về Login
    globalNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
          (route) => false,
    );
  } catch (e) {
    // fallback tối thiểu
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    globalNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
          (route) => false,
    );
  }
}
