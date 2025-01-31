import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:trackers/Login&Signup/Login.dart';
import 'package:trackers/Login&Signup/forget_Password.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'All Feautures/Maintainence/about.dart';
import 'Login&Signup/sign_up.dart';
/*
class ProfileBar extends StatefulWidget {
  final bool loggedIn;
  final String userId;
  final String name;
  final String email;
  
  const ProfileBar({
    super.key,
    required this.loggedIn,
    required this.userId,
    required this.name,
    required this.email,
  });

  @override
  ProfileBarState createState() => ProfileBarState();
}

class ProfileBarState extends State<ProfileBar> {
  bool isEditing = false;
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    if (widget.loggedIn) {
     // _fetchUserProfile();
    }
  }

  // Future<void> _fetchUserProfile() async {
  //   try {
  //     final profile = await ApiService().getUserProfile(widget.userId);
  //     setState(() {
  //       userProfile = profile;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to load profile: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('My Profile', style: TextStyle(color: Colors.orange)),
        actions: [_buildPopupMenu()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.loggedIn
            ? (userProfile != null
                ? _buildProfileContent()
                : const Center(child: CircularProgressIndicator()))
            : _buildLoginRegisterButtons(),
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.orange),
      onSelected: (value) {
        if (value == 'Edit Profile') {
          setState(() => isEditing = !isEditing);
        } else if (value == 'Save') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully')),
          );
          setState(() => isEditing = false);
        } else if (value == 'Contact us') {
          Get.to(() => const DeveloperInfoDialog());
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Edit Profile', child: Text('Edit Profile')),
        PopupMenuItem(value: 'Save', child: Text('Save')),
        PopupMenuItem(value: 'Contact us', child: Text('Contact us')),
      ],
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
                backgroundImage: AssetImage('assets/trainBackgrong/profile_user.jpg'),
              ),
            ),
            const SizedBox(height: 16),
            _buildEditableTextField('Name', userProfile!['name']),
            _buildEditableTextField('Email', userProfile!['email']),
            _buildEditableTextField('Mobile Number', userProfile!['mobile_number']),
            _buildEditableTextField('ID Number', userProfile!['id_number']),
            _buildEditableTextField('Date of Birth', userProfile!['date_of_birth']),
            _buildEditableTextField('Post Code', userProfile!['post_code']),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const ForgetPassword()),
              icon: const Icon(Icons.lock_outline_rounded, color: Colors.white),
              label: const Text('Update Password', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const SignUp()),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Log out', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField(String label, String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      enabled: isEditing,
    );
  }

  Widget _buildLoginRegisterButtons() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Get.to(() => const Login()),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Login'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.to(() => const SignUp()),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

// class ApiService {
//   final String baseUrl = 'http://192.168.68.105:3000';

//   Future<Map<String, dynamic>> getUserProfile(String userId) async {
//     final response = await http.get(Uri.parse('$baseUrl/profiles/$userId'));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load profile');
//     }
//   }

//   Future<void> createUserProfile(Map<String, dynamic> profileData) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/profiles'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(profileData),
//     );
//     if (response.statusCode != 201) {
//       throw Exception('Failed to create profile');
//     }
//   }

//   Future<void> updateUserProfile(String userId, Map<String, dynamic> profileData) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/profiles/$userId'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(profileData),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to update profile');
//     }
//   }

//   Future<void> deleteUserProfile(String userId) async {
//     final response = await http.delete(Uri.parse('$baseUrl/profiles/$userId'));
//     if (response.statusCode != 200) {
//       throw Exception('Failed to delete profile');
//     }
//   }

//   Future<Map<String, dynamic>> getProfileBar(String userId) async {
//     final response = await http.get(Uri.parse('$baseUrl/profilebar/$userId'));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load profile bar');
//     }
//   }
// }
*/

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
            _buildEditableTextField('Name', '***** ******'),
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