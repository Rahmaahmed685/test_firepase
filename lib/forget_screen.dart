import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(''),),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("Find Your Account",style: TextStyle(fontSize: 34,fontWeight: FontWeight.w900),),
            Text('Enter Your Email Address',style: TextStyle(fontSize: 20,),),
            SizedBox(height: 10,),
            TextFormField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if(value!.isEmpty){
                  return " Enter a valid email";
                }
                return null;
              },

            ),
            const SizedBox(height: 15),
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                  onPressed: () => resetPassword(),
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Reset Password",style: TextStyle(color: Colors.white),),
                ),
             ),


          ],),
        ),
      ),
      
    );
  }
  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    String email = emailController.text.trim();

     await FirebaseAuth.instance
        .sendPasswordResetEmail(
      email: email,
    ).then((value) {
       Fluttertoast.showToast(msg: "Password Email Sent");
       Navigator.pop(context);
    }).catchError((error) {
      print("Error => ${error}");

      if (error is FirebaseAuthException) {
        print("Error => ${error.code}");
        if (error.code == 'user-not-found') {
          displayToast('No user found for that email.');
        } else if (error.code == 'wrong-password') {
          displayToast('Wrong password provided for that user.');
        } else if (error.code == 'too-many-requests') {
          displayToast(
              'We have blocked all requests from this device due to unusual activity. Try again later.');
        }
      } else {
        Fluttertoast.showToast(msg: error.toString());

      }

    });

  }
  void displayToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}


