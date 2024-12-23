import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/Login&Signup/forget_Password.dart';
import 'All Feautures/Maintainence/about.dart';
import 'Login&Signup/sign_up.dart';

class ProfileBar extends StatefulWidget {
  final bool loggedIn;
  const ProfileBar({super.key, required this.loggedIn});

  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.orange),
        ),
        actions: [
          DropdownButton<String>(
            underline: Container(),
            icon: const Icon(Icons.more_vert, color: Colors.orange),
            items: const [
              DropdownMenuItem(
                value: 'Edit Profile',
                child: Text('Edit Profile'),
              ),
              DropdownMenuItem(
                value: 'Save',
                child: Text('Save'),
              ),
              DropdownMenuItem(
                value: 'Contact us',
                child: Text('Contact us'),
              ),
            ],
            onChanged: (String? newValue) {
              if (newValue == 'Edit Profile') {
                setState(() {
                  isEditing = !isEditing;
                });
              } else if (newValue == 'Save') {
                // Save action (if needed)
                // Implement save functionality here
                // For example, you can save the edited profile information to a database or backend
                // You can also show a success message to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile saved successfully')),
                );
                setState(() {
                  isEditing = false;
                });
              } else if (newValue == 'Contact us') {
                Get.to(() => const DeveloperInfoDialog());
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.loggedIn
            ? _buildProfileContent()
            : _buildLoginRegisterButtons(),
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.orange,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/trainBackgrong/profile user.jpg'),
              ),
            ),
            const SizedBox(height: 16),
            _buildEditableTextField('Name', 'AHNAF WADUD ARNAB'),
            _buildEditableTextField('Email', '...@bscse.uiu.ac.bd'),
            _buildEditableTextField('Mobile Number', '01234556789'),
            _buildEditableTextField('ID Number', '123456789'),
            _buildEditableTextField('Date of Birth', '1997-05-10'),
            _buildEditableTextField('Post Code', '1212'),/*
            _buildEditableTextField('Address', 'North Badda, Dhaka'),*/
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                Get.to(() => const DeveloperInfoDialog());
              },
              icon: const Icon(Icons.phone),
              label: const Text('Contact Us'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => const ForgetPassword());
              },
              icon: const Icon(Icons.lock_outline_rounded, color: Colors.white),
              label: const Text(
                'Update Password',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 165, 121, 70),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => const SignUp());
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Log out',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 207, 108, 108),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField(String label, String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green[800]),
      ),
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[800]),
      enabled: isEditing,
    );
  }

  Widget _buildLoginRegisterButtons() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to login page
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Login'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to register page
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
