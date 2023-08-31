import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    try {
      // Fetch a reference to the Firebase Storage bucket
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      // Reference to the directory containing images
      firebase_storage.Reference storageReference =
      storage.ref().child('images');

      // List items inside the directory
      List<firebase_storage.Reference> items =
      await storageReference.listAll().then((result) => result.items);

      List<String> urls = [];
      for (var item in items) {
        String url = await item.getDownloadURL();
        urls.add(url);
      }

      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey,
        // appBar: AppBar(
        //   title: Text('Photo Gallery'),
        // ),
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
    );
  }
}
