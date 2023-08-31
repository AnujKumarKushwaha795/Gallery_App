import 'dart:typed_data';
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class UploadImageOnWeb{
  Uint8List webImage = Uint8List(0);
  bool b=false;
  late firebase_storage.Reference _storageReference;
  Future<void> uploadImage(Uint8List image) async {
    try {
      _storageReference = firebase_storage.FirebaseStorage.instance
          .ref('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await _storageReference.putData(image);

      print('Image uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
    }
    // setState(() {});
  }

  void handleFileInputChange(html.File file) async {
    if (file != null) {
      final html.FileReader reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoad.listen((event) async {
        final Uint8List uint8list = Uint8List.fromList(reader.result as List<int>);
        // setState(() {
        //   b=true;
          webImage = uint8list;
        // });
        // await uploadImage(uint8list);
      });
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


}