import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/Login&Signup/forget_Password.dart';
import 'package:amarRailSheba/services/firebase_service.dart';
import 'All Feautures/Maintainence/about.dart';
import 'Login&Signup/Login.dart';
import 'Login&Signup/sign_up.dart';

class ProfileBar extends StatefulWidget {
  final bool loggedIn;
  const ProfileBar({super.key, required this.loggedIn});

  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  bool isEditing = false;
  Map<String, dynamic>? _user;
  bool _loading = true;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final profile = await FirebaseService().getUserProfile();
    setState(() {
      _user = profile;
      _loading = false;
      if (profile != null) {
        _nameCtrl.text = profile['name'] ?? '';
        _emailCtrl.text = profile['email'] ?? '';
        _phoneCtrl.text = profile['phone'] ?? '';
      }
    });
  }

  Future<void> _logout() async {
    await FirebaseService().logout();
    if (mounted) Get.offAll(() => const _LoggedOutProfile());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final loggedIn = widget.loggedIn && _user != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('My Profile', style: TextStyle(color: Colors.orange)),
        actions: loggedIn
            ? [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.orange),
                  onSelected: (value) {
                    if (value == 'Edit Profile') {
                      setState(() => isEditing = !isEditing);
                    } else if (value == 'Save') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile saved')),
                      );
                      setState(() => isEditing = false);
                    } else if (value == 'Contact us') {
                      Get.to(() => const DeveloperInfoPage());
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'Edit Profile', child: Text('Edit Profile')),
                    PopupMenuItem(value: 'Save', child: Text('Save')),
                    PopupMenuItem(value: 'Contact us', child: Text('Contact us')),
                  ],
                ),
              ]
            : null,
      ),
      body: loggedIn ? _buildProfileContent() : _buildLoginRegisterButtons(),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.orange.shade100,
                    child: const Icon(Icons.person, size: 60, color: Colors.orange),
                  ),
                  if (isEditing)
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.orange,
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _user?['name'] ?? 'User',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                _user?['email'] ?? '',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 24),
              _buildField(Icons.person_outline, 'Full Name', _nameCtrl),
              const SizedBox(height: 12),
              _buildField(Icons.email_outlined, 'Email', _emailCtrl,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildField(Icons.phone_outlined, 'Phone Number', _phoneCtrl,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  icon: const Icon(Icons.lock_outline, color: Colors.white),
                  label: const Text('Update Password',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3A6B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text('Log Out',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(IconData icon, String label, TextEditingController ctrl,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      enabled: isEditing,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1A3A6B)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: !isEditing,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildLoginRegisterButtons() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Sign in to view your profile',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const Login()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3A6B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Login',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignUp()),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1A3A6B)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Register',
                    style: TextStyle(color: Color(0xFF1A3A6B), fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shown after logout
class _LoggedOutProfile extends StatelessWidget {
  const _LoggedOutProfile();
  @override
  Widget build(BuildContext context) => const ProfileBar(loggedIn: false);
}
