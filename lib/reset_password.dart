import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextFormField(
          controller: passwordController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Enter Password',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10,),
        TextFormField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(),
          ),
        ),
      ],),
    );
  }
}
