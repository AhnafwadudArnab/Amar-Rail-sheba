import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/Login&Signup/Login.dart';
import 'package:amarRailSheba/services/firebase_service.dart';
import 'package:amarRailSheba/utils/responsive.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
          onPressed: () => Navigator.pop(context),
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
                      color: Colors.white.withValues(alpha: 0.97),
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
                    child: const _SignUpForm(),
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

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, IconData icon) {
    final r = R.of(context);
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: r.fs13),
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding:
          EdgeInsets.symmetric(horizontal: r.sp16, vertical: r.sp14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.person_add_outlined, size: r.sp40, color: const Color(0xFF1A3A6B)),
          SizedBox(height: r.sp8),
          Text(
            'Create Account',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: r.fs24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A3A6B)),
          ),
          Text(
            'Register to book your tickets',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: r.fs13, color: Colors.grey),
          ),
          SizedBox(height: r.sp24),

          // Name
          TextFormField(
            controller: _nameCtrl,
            style: TextStyle(fontSize: r.fs14),
            decoration: _dec('Full Name', Icons.person_outline),
            validator: (v) =>
                v == null || v.isEmpty ? 'Please enter your name' : null,
          ),
          SizedBox(height: r.sp12),

          // Email
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: r.fs14),
            decoration: _dec('Email', Icons.email_outlined),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your email';
              if (!EmailValidator.validate(v)) return 'Enter a valid email';
              return null;
            },
          ),
          SizedBox(height: r.sp12),

          // Phone
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            style: TextStyle(fontSize: r.fs14),
            decoration: _dec('Phone Number', Icons.phone_outlined),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your phone';
              final bd = RegExp(r'^01[3-9]\d{8}$');
              if (!bd.hasMatch(v.trim())) {
                return 'Enter a valid BD number (01XXXXXXXXX)';
              }
              return null;
            },
          ),
          SizedBox(height: r.sp12),

          // Password
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            style: TextStyle(fontSize: r.fs14),
            decoration: _dec('Password', Icons.lock_outline).copyWith(
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter a password';
              if (v.length < 6) return 'Minimum 6 characters';
              return null;
            },
          ),
          SizedBox(height: r.sp24),

          // Register button
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
                  : Text('Register',
                      style: TextStyle(
                          fontSize: r.fs16, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: r.sp12),

          // Login link
          TextButton(
            onPressed: () => Get.to(() => const Login()),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: r.fs13, color: Colors.grey[700]),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Login',
                    style: TextStyle(
                      color: const Color(0xFF1A3A6B),
                      fontWeight: FontWeight.bold,
                      fontSize: r.fs14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await FirebaseService().register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      password: _passCtrl.text,
    );
    setState(() => _loading = false);
    if (ok) {
      Fluttertoast.showToast(
          msg: 'Registered successfully!', backgroundColor: Colors.green);
      Get.offAll(() => const Login());
    }
  }
}
