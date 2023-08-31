
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../consts.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Uint8List webImage = Uint8List(0);
  bool b=false;
  StoreAndFetchImage storeAndFetchImage=StoreAndFetchImage();
  String currentUser=FirebaseAuth.instance.currentUser!.uid;

// Get Download Url of images of current users
   Future<List<String>>? imageUrls;
   Future<List<String>> getDownloadUrls() async {
    try {
      ListResult result = await FirebaseStorage.instance.ref().child('users/$currentUser').listAll();
      List<String> urls = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
  @override
  void initState() {
    super.initState();
    imageUrls = getDownloadUrls();
  }

  // void handleFileInputChange(html.File file) async {
  //   if (file != null) {
  //     final html.FileReader reader = html.FileReader();
  //     reader.readAsArrayBuffer(file);
  //     reader.onLoad.listen((event) async {
  //       final Uint8List uint8list = Uint8List.fromList(reader.result as List<int>);
  //       setState(() {
  //         b=true;
  //       webImage = uint8list;
  //       });
  //     });
  //   }
  // }
  // void fun(){
  //   html.FileUploadInputElement input = html.FileUploadInputElement()
  //     ..accept = 'image/*';
  //   input.click();
  //   input.onChange.listen((event) {
  //     handleFileInputChange(input.files!.first);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.pinkAccent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Gallery"),

        actions: [
          // TextField(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,30,0),
            child: InkWell(
              onTap: (){
                 storeAndFetchImage.fun();
               // fun();
              },
                child: Icon(Icons.add)
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black54)
                  
            ),
            // height: 2,
            width: 200,
            child: TextFormField(
              decoration: InputDecoration(
              hintText: "Search",
               hintStyle: TextStyle(color: primaryColor),
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
              },
              child: Icon(Icons.search),
            ),
          )
        ],
        // leading: Icon(Icons.add),
      ),
     body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 // const Text("Content"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,width: 120,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       InkWell(
                         onTap: (){
                         },
                         child: Row(
                           children: [
                             Icon(Icons.photo_album),
                             sizeHor(20),
                             Text("Photos",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),),
                           ],
                         ),
                       ),
                       sizeVer(30),
                       InkWell(
                         onTap: (){
                         },
                         child: Row(
                           children: [
                             Icon(Icons.video_settings),
                             sizeHor(20),
                             Text("Videos",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),),

                           ],
                         ),
                       ),
                       sizeVer(30),
                       InkWell(
                         onTap: (){
                         },
                         child: Row(
                           children: [
                             Icon(Icons.settings),
                             sizeHor(20),
                             Text("Setting",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),),

                           ],
                         ),
                       ),
                       sizeVer(30),
                       InkWell(
                         onTap: (){
                         },
                         child: Row(
                           children: [
                             Container(
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 border: Border.all(color: Colors.red)
                               ),
                               child: Icon(Icons.person),
                             ),
                             sizeHor(20),
                             Text("Profile",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),),
                           ],
                         ),
                       ),
                       sizeVer(30),
                       InkWell(
                         onTap: (){
                         },
                         child: Row(
                           children: [
                             Container(
                               decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   border: Border.all(color: Colors.lightBlueAccent)
                               ),
                               child: Icon(Icons.dark_mode),
                             ),
                             sizeHor(20),
                             Text("Dark Mode",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),),
                           ],
                         ),
                       ),
                       sizeVer(30),
                       InkWell(
                         onTap: (){
                           FirebaseAuth.instance.signOut();
                           Navigator.pushNamed(context, "/login");
                         },
                         child: Row(
                           children: [
                             Container(
                               decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   // border: Border.all(color: Colors.red)
                               ),
                               child: Icon(Icons.logout_outlined),
                             ),
                             sizeHor(20),
                             Text("LogOut",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),),
                           ],
                         ),
                       ),
                     ],
                    ),
                  ),
                ],
              ),
            ),
        Expanded(
         child: FutureBuilder<List<String>>(
           future: imageUrls,
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return Center(child: CircularProgressIndicator());
             } else if (snapshot.hasError) {
               return Center(child: Text('Error loading images'));
             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
               return Center(child: Text('No images available'));
             } else {
               return Container(
                 width: double.infinity,
                 decoration: BoxDecoration(
                   color: Color.fromRGBO(255, 20, 147, 0.3),
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       GridView.builder(
                         itemCount: snapshot.data!.length,
                         physics: ScrollPhysics(),
                         shrinkWrap: true,
                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 4,
                           crossAxisSpacing: 5,
                           mainAxisSpacing: 5,
                         ),
                         itemBuilder: (context, index) {
                           String imageUrl = snapshot.data![index];
                           return InkWell(
                              onTap: (){
                                 log("Current Image Url=${imageUrl.toString()}");
                              },
                             child: CachedNetworkImage(
                               imageUrl: imageUrl,
                               imageBuilder: (context, imageProvider) => Container(
                                 decoration: BoxDecoration(
                                   color: Colors.grey, // Placeholder color
                                   borderRadius: BorderRadius.circular(5),
                                   image: DecorationImage(
                                     image: imageProvider,
                                     fit: BoxFit.cover,
                                   ),
                                 ),
                               ),
                               placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                               errorWidget: (context, url, error) => Icon(Icons.error),
                             ),
                           );
                         },
                       ),
                     ],
                   ),
                 ),
               );
             }
           },
         ),
        ),
          ],
        ),
     ),
    );
  }
}




class StoreAndFetchImage{

  String currentUserUid=FirebaseAuth.instance.currentUser!.uid;
  Future<String> uploadImageToFirebase(String fileName,Uint8List imageBytes) async {
    try {
      final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('users/$currentUserUid/$fileName.jpg');
      log(ref.toString());
      final firebase_storage.UploadTask uploadTask = ref.putData(imageBytes);
      final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadURL = await taskSnapshot.ref.getDownloadURL();
      // await fetchImageFromFirebase(downloadURL); // Fetch and display the uploaded image
      return downloadURL;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
    }
  }
  void handleFileInputChange(String fileName,html.File file) async {
    if (file != null) {
      final html.FileReader reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first; // Wait for the reader to load the file

      final Uint8List uint8list = Uint8List.fromList(reader.result as List<int>);

      final String downloadURL = await uploadImageToFirebase(fileName,uint8list);
      // setState(() {
      //   b = true;
      //   webImage = uint8list;
      // });
      print('Image uploaded to: $downloadURL');
    }
  }

  void fun(){
    html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      // input.files!.first.name
      handleFileInputChange(input.files!.first.name.toString(),input.files!.first);
    });
  }


}
