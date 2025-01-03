import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trackers/Login&Signup/sign_up.dart';
import 'package:trackers/booking.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 240, 232, 232),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/trainBackgrong/05.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.9,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: const LoginFormWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  LoginFormWidgetState createState() => LoginFormWidgetState();
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40.0),
          // Name field
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.person, color: Colors.black),
            ),
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          // Email field
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.email, color: Colors.black),
            ),
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Password field
          TextFormField(
            controller: passwordController,
            obscureText: isVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
            ),
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 24.0),
            ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 96, 180, 219),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
              bool success = await ApiService().loginUser(
                name: nameController.text,
                email: emailController.text,
                password: passwordController.text,
              );
              if (success) {
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainHomeScreen(),
                ),
                (route) => false,
                );
              } else {
                Fluttertoast.showToast(
                msg: "Login failed, please try again",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
                );
              }
              } else {
              Fluttertoast.showToast(
                msg: "Please fill all the fields correctly",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              }
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            ),
            TextButton(
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUp(),
              ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                color: Colors.black,
                ),
              ),
              SizedBox(width: 4),
              Text(
                "Register",
                style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                ),
              ),
              ],
            ),
            ),

        ],
        ),
    );
  }
}

class ApiService {
  final String baseUrl =
      "http://192.168.68.103:3000"; // Replace with your server's address
//remember there is no 'S' in the http//
  Future<bool> loginUser({
    required String name,
    required String email,
    required String password,
  }) async {
    Map<String, String> requestheaders = {
      "Content-Type": "application/json",
    };
    Map<String, String> requestBody = {
      "name": name,
      "email": email,
      "password": password,
    };
    var response = await http.post(Uri.parse("$baseUrl/user/login"),
        headers: requestheaders, body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
