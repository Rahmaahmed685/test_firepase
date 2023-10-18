
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_firepase/forget_screen.dart';
import 'package:test_firepase/home_screen.dart';
import 'package:test_firepase/regist.dart';
import 'package:test_firepase/register_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Login",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: //Container(
       // color: Colors.blue,
       // child:
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(50),
              child: Icon(
                Icons.person,
                size: 55,
                color: Colors.white,
              ),
            ),
             Expanded(
               child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      // Vertical   => Main
                      // Horizontal => Cross

                      children: [
                        TextFormField(
                         controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email required";
                            }
                            // Not contain @ OR Not contain .
                            if (!value.contains("@") || !value.contains(".")) {
                              return "Invalid email!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                obscureText = !obscureText;
                                setState(() {});
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password required";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Container(
                          alignment: AlignmentDirectional.centerEnd,
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder:
                                      (context)=> ForgetScreen(),)
                              );
                            },
                            child:
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Forget password ?",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          // Main  => Horizontal
                          // Cross => Vertical
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => login(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                    shape: const StadiumBorder()),
                                child: const Text("Login"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => navToRegisterScreen(),
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder()),
                                child: const Text("Register"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
             ),
            
          ],
        ),
      //),
    );
  }

  navToRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> RegisterScreen(),)
    );
  }

  // Define a controller
  // Bind a controller with TextFormFiled
  // Get data from the controller
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    String email = emailController.text;
    String password = passwordController.text;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
    }  on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        displayToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        displayToast('Wrong password provided for that user.');
      } else if (e.code == 'too many request') {
        displayToast('we blocked you,try again');
      }

      else {

      }
    }
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

  void displaySnackBar(String message) {
    var snackBar = SnackBar(
      content: Text(message),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}