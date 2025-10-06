import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../routes/app_routes.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  bool _agreeTerms = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)
                .translate("agree_terms_error") ??
                "Bạn phải đồng ý với điều khoản",
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // giả lập API
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)
              .translate("register_success") ??
              "Đăng ký thành công!",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;
    final loc = AppLocalizations.of(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Logo ---
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_add_alt_1_rounded,
                      size: 36, color: Color(0xFF2563EB)),
                ),
              ),
              const SizedBox(height: 20),

              // --- Title ---
              Text(
                loc.translate("signup_title") ?? "Tạo tài khoản PolyGo",
                textAlign: TextAlign.center,
                style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                loc.translate("signup_subtitle") ??
                    "Nhập thông tin để đăng ký tài khoản mới",
                textAlign: TextAlign.center,
                style: t.bodyMedium?.copyWith(color: theme.colorScheme.outline),
              ),
              const SizedBox(height: 32),

              // --- Name ---
              Text(loc.translate("full_name") ?? "Họ và tên",
                  style: t.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Nguyễn Văn A",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (v) =>
                (v == null || v.isEmpty) ? "Vui lòng nhập họ tên" : null,
              ),
              const SizedBox(height: 16),

              // --- Email + OTP ---
              Text(loc.translate("email"), style: t.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "user@example.com",
                        prefixIcon: const Icon(Icons.mail_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (v) => (v == null || !v.contains('@'))
                          ? "Email không hợp lệ"
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            loc.translate("otp_sent") ??
                                "Đã gửi mã OTP đến email",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                    child: Text(
                      loc.translate("send_otp") ?? "Gửi OTP",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- OTP ---
              Text(loc.translate("otp_code") ?? "Mã xác thực OTP",
                  style: t.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: loc.translate("verify_code") ?? "Nhập mã xác nhận",
                  counterText: "",
                  prefixIcon: const Icon(Icons.verified_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (v) =>
                (v == null || v.length != 6) ? "Mã OTP phải gồm 6 số" : null,
              ),
              const SizedBox(height: 16),

              // --- Password ---
              Text(loc.translate("password"), style: t.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (v) =>
                (v == null || v.length < 6) ? "Mật khẩu tối thiểu 6 ký tự" : null,
              ),
              const SizedBox(height: 16),

              // --- Confirm Password ---
              Text(loc.translate("confirm_password") ?? "Xác nhận mật khẩu",
                  style: t.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (v) =>
                (v != _passwordController.text) ? "Mật khẩu không khớp" : null,
              ),
              const SizedBox(height: 12),

              // --- Agree to Terms ---
              Row(
                children: [
                  Checkbox(
                    value: _agreeTerms,
                    onChanged: (v) => setState(() => _agreeTerms = v!),
                  ),
                  Expanded(
                    child: Text(
                      loc.translate("agree_terms") ??
                          "Tôi đồng ý với Điều khoản sử dụng và Chính sách bảo mật",
                      style: t.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Register Button ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading ? null : _onSubmit,
                child: Text(
                  _isLoading
                      ? (loc.translate("signing_up") ?? "Đang đăng ký...")
                      : (loc.translate("signup_button") ?? "Đăng ký"),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),

              // --- Navigate to Login ---
              Text.rich(
                TextSpan(
                  text: (loc.translate("have_account") ?? "Đã có tài khoản? ") + ' ',
                  style: t.bodyMedium?.copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: loc.translate("login_now") ?? "Đăng nhập ngay",
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}
