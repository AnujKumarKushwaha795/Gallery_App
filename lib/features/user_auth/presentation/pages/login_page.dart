
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rough_project/consts.dart';
import 'package:rough_project/features/user_auth/presentation/pages/forget_password.dart';
import 'package:rough_project/features/user_auth/presentation/pages/sign_up_page.dart';
import '../../firebase_auth_implementation/firebase_auth_services.dart';
import '../widgets/form_container_widget.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Login"),
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
                const Text("Login",
                  style: TextStyle(
                    // color: Theme.of(context).colorScheme.secondary,
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                FormContainerWidget(
                  controller: _emailController,
                  hintText: "Email",
                  isPasswordField: false,
                  labelText: "Enter your email",
                ),
                sizeVer(20),
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true,
                  labelText: "Enter your password",
                ),
                sizeVer(30),
                GestureDetector(
                  onTap: _signIn,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child:Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                  ),
                ),
                sizeVer(20),
                GestureDetector(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ForgetPassword()), (route) => false);
                  },
                  child: const Text("Forget Password",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                ),
                sizeVer(20),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    sizeHor(5),
                    GestureDetector(
                        onTap: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpPage()), (route) => false);
                        },
                        child: const Text("Sign Up",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    try {
      if (user != null) {
        print("User is successfully signedIn");
        Navigator.pushNamed(context, "/home");
      } else {
        print("Some error happened");
      }
    }catch (e){
      toast(e.toString());
      log("error1=$e");
    }
  }
}
