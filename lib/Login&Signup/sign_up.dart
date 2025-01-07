import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trackers/Login&Signup/Login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () {
            Navigator.pop(context);
          },
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
          if (kIsWeb)
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )
          else
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          Container(
            margin: const EdgeInsets.only(top: 22.0, left: 20.0, right: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 200.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      height: MediaQuery.of(context).size.height / 1.9,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2.0,
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: const LoginFormWidget(),
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
}

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  bool isLoading = false;
  String? responseMessage;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Email field
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.email, color: Colors.black),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Phone field
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.phone, color: Colors.black),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Password field
          TextFormField(
            controller: passwordController,
            obscureText: isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
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
              if (_formKey.currentState!.validate()) {
                bool isRegistered = await ApiService().registerUser(
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  password: passwordController.text,
                );

                if (isRegistered) {
                  Fluttertoast.showToast(
                    msg: "User registered successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  // working this one//
                  Get.offAll(() => const Login());
                } else {
                  Fluttertoast.showToast(
                    msg: "Registration failed",
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
                  msg: "Please fill all the fields",
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
              'Register',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.to(() => const Login());
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 4),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20.0,
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
  final String baseUrl = "http://192.168.68.103:3000";
  // final String baseUrl = "http://10.15.11.216:3000";//university wifi ip//

  Future<bool> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    Map<String, String> requestheaders = {
      "Content-Type": "application/json",
    };
    Map<String, String> requestBody = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
    };
    var response = await http.post(Uri.parse("$baseUrl/user/register"),
        headers: requestheaders, body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
