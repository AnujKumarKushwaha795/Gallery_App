import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rough_project/consts.dart';
import 'package:http/http.dart' as http;

// import 'dart:typed_data';
// import 'dart:convert';
class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  Uint8List webImage = Uint8List(0);
  bool b=false;
  late firebase_storage.Reference _storageReference;
  Uint8List fetchedImage=Uint8List(0);
  String downloadUrl="";
  List<String> imageUrls = []; // List to store image URLs

  @override
  void initState() {
    super.initState();
    fetchImageUrlsFromFirebase();
  }
  Future<void>getDownloadUrls()async{
    try{
      String? imgUrl=await FirebaseStorage.instance.ref().child('users/1693379836649.jpg').getDownloadURL();
      log("Download url=$imgUrl");
      setState(() {
        downloadUrl=imgUrl.toString();
      });
    }catch(e){
      log(e.toString());
    }
  }

  Future<void> fetchImageUrlsFromFirebase() async {
    try {
      final firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref('images/').listAll();

      for (final firebase_storage.Reference ref in result.items) {
        final String downloadURL = await ref.getDownloadURL();
        log("Image url form firebase=>$downloadURL");
        setState(() {
          imageUrls.add(downloadURL);
        });
      }
    } catch (error) {
      print('Error fetching image URLs: $error');
    }
  }
  Future<void> fetchImageFromFirebase(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List uint8list = response.bodyBytes;
        setState(() {
          fetchedImage = uint8list;
        });
      } else {
        print("Error fetching image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching image: $e");
    }
  }

  // Future<void> fetchImageFromFirebase(String imageUrl) async {
  //   try {
  //     final response = await Dio().get(
  //       imageUrl,
  //       options: Options(responseType: ResponseType.bytes),
  //     );
  //     if (response.statusCode == 200) {
  //       final Uint8List uint8list = Uint8List.fromList(response.data);
  //       setState(() {
  //         webImage = uint8list;
  //       });
  //     } else {
  //       print("Error fetching image: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error fetching image: $e");
  //   }
  // }


  /*
  Future<void> fetchImageFromFirebase(String imageUrl) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List uint8list = response.bodyBytes;
        setState(() {
          fetchedImage = uint8list;
        });
      } else {
        print("Error fetching image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching image: $e");
    }
  }
*/
  // Future<void> fetchImageFromFirebase(String imageUrl) async {
  //   try {
  //     final response = await http.get(Uri.parse(imageUrl));
  //     if (response.statusCode == 200) {
  //       final Uint8List uint8list = response.bodyBytes;
  //       setState(() {
  //         fetchedImage = uint8list;
  //       });
  //     } else {
  //       print("Some error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error in fetching image: $e");
  //   }
  // }

  // Future<void> fetchImageFromFirebase(String imageUrl) async {
  //   try {
  //     // final html.HttpRequest request = await html.HttpRequest.request(imageUrl, responseType: 'arraybuffer');
  //     final headers = {'Accept': 'image/*'};
  //     final html.HttpRequest request = await html.HttpRequest.request(imageUrl, responseType: 'arraybuffer', requestHeaders: headers);
  //
  //     print("Response status code: ${request.status}");
  //     print("Response: ${request.response}");
  //
  //     if (request.status == 200) {
  //       final Uint8List uint8list = Uint8List.fromList(request.response as List<int>);
  //       print("Fetched image from Firebase. Length: ${uint8list.length}");
  //       // or if you want to log it as a hex string
  //       print("Image data as hex: ${uint8list.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join()}");
  //       setState(() {
  //         fetchedImage = uint8list;
  //       });
  //     } else {
  //       print("Some error");
  //     }
  //   } catch (e) {
  //     print("Error in fetching image: $e");
  //   }
  // }

  // Future<void> fetchImageFromFirebase(String imageUrl) async {
  //   try {
  //     final html.HttpRequest request = await html.HttpRequest.request(imageUrl, responseType: 'blob');
  //     if (request.status == 200) {
  //       final blob = request.response as html.Blob;
  //       final Uint8List uint8list = await blob.slice(0, blob.size).readAsArrayBuffer().then(Uint8List.view);
  //       print("Fetched image from Firebase: $uint8list");
  //       setState(() {
  //         fetchedImage = uint8list;
  //       });
  //     } else {
  //       print("Some error");
  //     }
  //   } catch (e) {
  //     print("Error in fetching image: $e");
  //   }
  // }



/*
  Future<void> fetchImageFromFirebase(String imageUrl) async {
    try{
      final html.HttpRequest request = await html.HttpRequest.request(imageUrl);
      if (request.status == 200) {
        final Uint8List uint8list = Uint8List.fromList(request.response);
        log("fetched image form firebase=$uint8list");
        setState(() {
          fetchedImage = uint8list;
        });
      }
      else{
        log("Some error");
      }

    }catch(e){
      log("error in fetching image=>$e");
    }
  }
*/





  Future<String> uploadImageToFirebase(Uint8List imageBytes) async {
    try {
      final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('users/${DateTime.now().millisecondsSinceEpoch}.jpg');
      log(ref.toString());
      final firebase_storage.UploadTask uploadTask = ref.putData(imageBytes);
      final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      final String downloadURL = await taskSnapshot.ref.getDownloadURL();
      await fetchImageFromFirebase(downloadURL); // Fetch and display the uploaded image
      return downloadURL;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
    }
  }

  _uploadFile(Uint8List image)async{
    try{
      firebase_storage.UploadTask uploadTask;
      firebase_storage.Reference ref=firebase_storage.FirebaseStorage.instance.ref().child("UserImage").child('/');
      final metadata=firebase_storage.SettableMetadata(contentType: 'image/jpg');

      uploadTask= ref.putData(image,metadata);
      // await _storageReference.putFile(image as File);
      String imageUrl=await ref.getDownloadURL();
      log("image Url=$imageUrl");
      log('Image uploaded successfully');
    }catch(e){
      log("error in uploading=$e");
    }

  }


  Future<void> uploadImage(Uint8List image) async {
    try {
      // _storageReference = firebase_storage.FirebaseStorage.instance
      //     .ref('users/${DateTime.now().millisecondsSinceEpoch}.jpg');
       log("image=$image");
      _storageReference = firebase_storage.FirebaseStorage.instanceFor(bucket: 'users')
          .ref('users/${DateTime.now().millisecondsSinceEpoch}.jpg');
       log("uploaded");
       final metadata=firebase_storage.SettableMetadata(contentType: 'image/jpg');
       await _storageReference.putData(image,metadata);
      // await _storageReference.putFile(image as File);

      print('Image uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
    }
    setState(() {});
  }

  // void handleFileInputChange(html.File file) async {
  //   if (file != null) {
  //     final html.FileReader reader = html.FileReader();
  //     reader.readAsArrayBuffer(file);
  //
  //     reader.onLoad.listen((event) async {
  //       final Uint8List uint8list = Uint8List.fromList(reader.result as List<int>);
  //       setState(() {
  //         b=true;
  //         webImage = uint8list;
  //       });
  //       _uploadFile(uint8list);
  //       // await uploadImage(uint8list);
  //     });
  //   }
  // }
  void handleFileInputChange(html.File file) async {
    if (file != null) {
      final html.FileReader reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      await reader.onLoad.first; // Wait for the reader to load the file

      final Uint8List uint8list = Uint8List.fromList(reader.result as List<int>);

      final String downloadURL = await uploadImageToFirebase(uint8list);

      setState(() {
        b = true;
        webImage = uint8list;
      });

      print('Image uploaded to: $downloadURL');
    }
  }

   void fun(){
     html.FileUploadInputElement input = html.FileUploadInputElement()
       ..accept = 'image/*';
     input.click();
     input.onChange.listen((event) {
       handleFileInputChange(input.files!.first);
     });
   }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Column(
        children: [
          Container(
            child: ElevatedButton(
              onPressed: () {
                  // fun();
                getDownloadUrls();
                  // fetchImageFromFirebase("https://firebasestorage.googleapis.com/v0/b/rough-project-1720c.appspot.com/o/users%2F1693391089522?alt=media&token=2db72b5c-5107-4d50-be89-318b728468f6");
                  // fetchImageUrlsFromFirebase();
                // html.FileUploadInputElement input = html.FileUploadInputElement()
                //   ..accept = 'image/*';
                // input.click();
                // input.onChange.listen((event) {
                //   handleFileInputChange(input.files!.first);
                // });
              },
              child: Text('Pick and Upload Image'),
            ),
          ),
          sizeVer(20),
          // Container(
          //   // height: 200,
          //   // width: 200,
          //   child:b==true?Image.memory(webImage, fit: BoxFit.fill):Container(height: 0,width: 0,),
          // ),
          Container(height: 200,width: 200,
            // child: Image.memory(Uint8List.fromList("")),
            child:downloadUrl!=""? Image.network(downloadUrl):Container(height: 0,width: 0,),
          ),
          sizeVer(10),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: GridView.builder(
                itemCount: imageUrls.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(imageUrls[index], fit: BoxFit.cover);
                },
              ),
            ),
          ),

          // if (imageUrls.isNotEmpty)
          //   Column(
          //     children: imageUrls.map((imageUrl) => Image.network(imageUrl)).toList(),
          //   ),
          // sizeVer(20),
          Container(
            // height: 200,
            // width: 200,
            child:fetchedImage.isNotEmpty?Image.memory(fetchedImage, fit: BoxFit.fill):Container(height: 0,width: 0,),
          ),
        ],
      ),
    );
  }
}

class StoreAndFetchImage{




  Future<String> uploadImageToFirebase(String fileName,Uint8List imageBytes) async {
    try {
      final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('users/${DateTime.now().millisecondsSinceEpoch}.jpg');
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
      handleFileInputChange(input.files!.first.name,input.files!.first);
    });
  }


}





/*
/*
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
// import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_picker_web/image_picker_web.dart';
import 'fetch_image.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';


class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {

  /*
  final ImagePicker _imagePicker = ImagePicker();
  late firebase_storage.Reference _storageReference;

  Future<void> uploadImage(File image) async {
    try {
      // Initialize a reference to the Firebase Storage bucket
      _storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file to Firebase Storage
      await _storageReference.putFile(image);
      print('Image uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
    }
    setState(() {});
  }

  Future<void> pickAndUploadImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await uploadImage(imageFile);
    }
  }
*/

  final ImagePickerWeb _imagePicker = ImagePickerWeb();
  Uint8List webImage=Uint8List(8);

  late firebase_storage.Reference _storageReference;

  Future<void> uploadImage(dynamic image) async {
    try {
      _storageReference = firebase_storage.FirebaseStorage.instance
          .ref('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      if (image is Uint8List) {
        await _storageReference.putData(image);
      }

      print('Image uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
    }
    setState(() {});
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker _picker=ImagePicker();
    XFile? image=await _picker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      var f=await image.readAsBytes();
      setState(() {
        webImage=f;
      });
    }else{
      log("No image has been picker");
    }

    // if (kIsWeb) {
    //   final html.InputElement input = html.FileUploadInputElement()..accept = 'image/*';
    //   input.click();
    //
    //   input.onChange.listen((event) async {
    //     final html.File file = input.files!.first;
    //     if (file != null) {
    //       final Uint8List uint8list = await file.readAsBytes();
    //       await uploadImage(uint8list);
    //     }
    //   });
    // } else {
    //   final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    //
    //   if (pickedFile != null) {
    //     File imageFile = File(pickedFile.path);
    //     await uploadImage(imageFile);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Column(
        children: [
          Container(
            child: ElevatedButton(
              onPressed: pickAndUploadImage,
              child: Text('Pick and Upload Image'),
            ),
          ),
          // Container(
          //   height: 200,width: 200,
          //   child: Image.memory(webImage,fit: BoxFit.fill,),
          // ),
          // MyHomePage(),
        ],
      ),
    );
  }
}
*/
*/
 */
