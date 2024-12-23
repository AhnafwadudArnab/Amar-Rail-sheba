import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/Login&Signup/Login.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

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
        Get.to(() => const Login());
          },
        ),
      ),
      body: Stack(
        children: [
          // Image background
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
          // Transparent container for form fields
          Container(
            margin: const EdgeInsets.only(top: 22.0, left: 20.0, right: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // box location up->down//
                  const SizedBox(height: 280.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      //box height//
                      height: MediaQuery.of(context).size.height / 3.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      child: const ForgetPasswordFormWidget(),
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

class ForgetPasswordFormWidget extends StatefulWidget {
  const ForgetPasswordFormWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgetPasswordFormWidgetState createState() =>
      _ForgetPasswordFormWidgetState();
}

class _ForgetPasswordFormWidgetState extends State<ForgetPasswordFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 70.0),
        // Email field
        TextFormField(
        controller: emailTextController,
        decoration: const InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Roboto'), // Set label text color and font size to black
          prefixIcon: Icon(Icons.email, color: Colors.black), // Set icon color to black
        ),
        style: const TextStyle(color: Colors.black, fontSize: 20), // Set input text color and font size to black
        validator: (value) {
          if (value == null || value.isEmpty) {
          return 'Please enter your email';
          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
          }
          return null;
        },
        ),
            const SizedBox(height: 24.0),
            ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:const Color.fromARGB(255, 96, 180, 219), // Set the button color to brown
            ),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
              // Handle forget password logic here
              Get.snackbar('Success', 'Password reset link sent to your email');
              }
            },
            child: const Text('Reset Password', style: TextStyle(color: Colors.white,)),
            ),
            const SizedBox(height: 16.0),

        ],
        ),
    );
  }
  }
  