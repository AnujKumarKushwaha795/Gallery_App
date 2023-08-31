
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rough_project/consts.dart';

import '../../firebase_auth_implementation/firebase_auth_services.dart';
import '../widgets/form_container_widget.dart';
import 'login_page.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("SignUp"),
      // ),
      body: Center(
        child: Container(

          height: double.infinity,width: 350,

          decoration: BoxDecoration(
            gradient: lightPinkBackground,
            // color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                    // color: Theme.of(context).colorScheme.secondary,
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sizeVer(30),
                FormContainerWidget(
                controller: _usernameController,
                  hintText: "Username",
                  isPasswordField: false,
                  labelText: "Username",
                ),
                sizeVer(20),
                FormContainerWidget(
                controller: _emailController,
                  hintText: "Email",
                  isPasswordField: false,
                  labelText: "Email",
                ),
               sizeVer(20),
                FormContainerWidget(
                controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true,
                  labelText: "Password",
                ),
               sizeVer(30),
                GestureDetector(
                  onTap: _signUp,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                SizedBox(height: 20,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    sizeHor(5),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                        },
                        child: Text("Login", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
     log("start signUp");
     User? user = await _auth.signUpWithEmailAndPassword(email, password);
     log(user.toString());

     if (user!= null){
      print("User is successfully created");
      Navigator.pushNamed(context, "/home");
    } else{
      print("Some error happend");
    }

  }

}
