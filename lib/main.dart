/*
flutter run --web-renderer html
flutter build web --release --web-renderer html
 */

// import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rough_project/Presentation/Desktop/main_screen.dart';
import 'package:rough_project/Upload_Image/fetch_image.dart';
import 'package:rough_project/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Upload_Image/image_upload_page.dart';
import 'features/app/splash_screen/splash_screen.dart';
import 'features/user_auth/presentation/pages/forget_password.dart';
import 'features/user_auth/presentation/pages/home_page.dart';
import 'features/user_auth/presentation/pages/login_page.dart';
import 'features/user_auth/presentation/pages/sign_up_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyC-lMOCmfT9E1kcTnsQRQYcJ33HPbq1lFI",
          appId: "1:295683846127:web:a9350b70f275086613101a",
          messagingSenderId: "295683846127",
          projectId: "rough-project-1720c",
         storageBucket:'rough-project-1720c.appspot.com',
         authDomain: "rough-project-1720c.firebaseapp.com",
         measurementId: "G-3GHC01N2P6",
      )
    );
  }else{
   await Firebase.initializeApp (options: DefaultFirebaseOptions.currentPlatform);
  }


  // FirebaseAuth _auth=FirebaseAuth.instance;
  // try{
  //   await _auth.createUserWithEmailAndPassword(email: "akm123@gmail.com", password: "123456987");
  //  log("inside try bloc");
  // }catch (e){
  //   log("error=$e");
  // }
  // log("user created");
  // log("auth=$_auth");

  runApp( MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home:MainScreen(),
//
//     );
//   }
// }
//
//


class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
  //   return Scaffold(
  //     // appBar: AppBar(title: Text("Gallery"),),
  //     body: MainScreen(),
  //   );
    // return ImageUploadPage();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery App',
      // home: MainScreen(),
      // home: MyHomePage(),
      //   home: ImageUploadPage(),

      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
         child:(FirebaseAuth.instance.currentUser !=null)?   MainScreen():  LoginPage(),
          // child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => MainScreen(),
        '/forgetPassword':(context)=>ForgetPassword(),
      },
    );

  }
}




