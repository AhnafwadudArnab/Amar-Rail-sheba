import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/Login&Signup/Login.dart';
import 'package:amarRailSheba/services/firebase_service.dart';
import 'package:amarRailSheba/utils/responsive.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () => Get.to(() => const Login()),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/trainBackgrong/05.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: r.isPhone ? 20 : r.isTablet ? 80 : 0,
                  vertical: r.sp24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(r.sp24),
                    child: const _ForgetPasswordForm(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgetPasswordForm extends StatefulWidget {
  const _ForgetPasswordForm();

  @override
  _ForgetPasswordFormState createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<_ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await FirebaseService().resetPassword(_emailCtrl.text.trim());
    setState(() { _loading = false; _sent = true; });
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Icon(Icons.lock_reset, size: r.sp40, color: const Color(0xFF1A3A6B)),
          SizedBox(height: r.sp8),
          Text(
            'Reset Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.fs22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A3A6B),
            ),
          ),
          SizedBox(height: r.sp6),
          Text(
            'Enter your email and we\'ll send you a reset link',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: r.fs13, color: Colors.grey[600]),
          ),
          SizedBox(height: r.sp24),

          if (_sent) ...[
            Container(
              padding: EdgeInsets.all(r.sp16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: r.sp10),
                  Expanded(
                    child: Text(
                      'Reset link sent! Check your email.',
                      style: TextStyle(color: Colors.green, fontSize: r.fs13),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: r.sp16),
          ],

          // Email field
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: r.fs14),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(fontSize: r.fs13),
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: r.sp16, vertical: r.sp14),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: r.sp20),

          // Submit button
          SizedBox(
            height: r.btnH,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text('Send Reset Link',
                      style: TextStyle(
                          fontSize: r.fs15, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: r.sp12),

          // Back to login
          TextButton(
            onPressed: () => Get.to(() => const Login()),
            child: Text(
              'Back to Login',
              style: TextStyle(
                  color: const Color(0xFF1A3A6B),
                  fontSize: r.fs13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// Keep old class name for backward compat
class ForgetPasswordFormWidget extends StatelessWidget {
  const ForgetPasswordFormWidget({super.key});
  @override
  Widget build(BuildContext context) => const _ForgetPasswordForm();
}
