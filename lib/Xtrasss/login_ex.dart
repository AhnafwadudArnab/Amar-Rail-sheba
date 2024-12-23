import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginEx extends StatefulWidget {
  const LoginEx({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginExState();
    
  }

}

class _LoginExState extends State<LoginEx> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey,
                Colors.black87,
              ],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset("assets/trainBackgrong/01.png"),
              ),
              const SizedBox(height: 10),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormFields(
                      controller: _emailController,
                      txthint: 'Email',
                      data: Icons.email,
                      obscure: false,
                    ),
                     FormFields(
                      controller: _passwordController,
                      txthint: 'Password',
                      data: Icons.lock,
                      obscure: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print("Clicked on login button");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
               
            ]
        ),
      ),
      ),
    );
  }
}

class FormFields extends StatefulWidget {
  final TextEditingController controller;
  final String txthint;
  final IconData data;
  final bool obscure;

  const FormFields({super.key, 
    required this.controller,
    required this.txthint,
    required this.data,
    this.obscure = true,
  });
  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.all(6),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscure,
        decoration: InputDecoration(
          hintText: widget.txthint,
          prefixIcon: Icon(widget.data, color: Colors.grey),
        ),
      ),
    );
  }
}