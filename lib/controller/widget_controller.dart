import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/view/widgets/button_widget.dart';
import 'package:untitled2/view/widgets/image_widget.dart';
import 'package:untitled2/view/widgets/text_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Detect web
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;

class WidgetController extends GetxController {
  final widgetsOptions = {
    "Text Widget": false,
    "Image Widget": false,
    "Button Widget": false,
  }.obs;

  final RxList<Widget> widgetList = <Widget>[].obs;

  final textController = TextEditingController();
  var selectedImage = Rxn<File>();

  //firebase
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void selectWidget(String widget) {
    if (widgetsOptions.containsKey(widget)) {
      widgetsOptions[widget] = !widgetsOptions[widget]!;
    }
  }

  void importWidget() {
    List<Widget> newWidgets = [];

    if (widgetsOptions["Text Widget"] == true) {
      newWidgets.add(Spacer());
      newWidgets.add(TextWidget());
    } else {
      newWidgets.add(Spacer());
    }
    if (widgetsOptions["Image Widget"] == true) {
      newWidgets.add(Spacer());
      newWidgets.add(ImageWidget());
    } else {
      newWidgets.add(Spacer());
    }
    if (widgetsOptions["Button Widget"] == true) {
      newWidgets.add(Spacer());
      newWidgets.add(ButtonWidget());
      newWidgets.add(Spacer());
    } else {
      newWidgets.add(Spacer());
    }

    // Update the observable list of widgets
    widgetList.value = newWidgets;
  }

  // Future<void> pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     selectedImage.value = File(image.path);
  //   } else {
  //     Get.snackbar("No Image Selected", "Please select an image.");
  //   }
  // }

  Rxn<Uint8List> webImage = Rxn<Uint8List>(); // For storing image bytes on Web

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    if (kIsWeb) {
      // Web Image Picker
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return;

        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]); // Read file as Uint8List
        reader.onLoadEnd.listen((e) {
          webImage.value = reader.result as Uint8List;
          // print('Web image selected: ${webImage.value}');
        });
      });
    } else {
      // Mobile Image Picker
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value =
            File(image.path); // This works only for Android/iOS
      } else {
        Get.snackbar("No Image Selected", "Please select an image.");
      }
    }
  }

  Future<void> save() async {
    final message = Text(
      "Add atleast a widget to save",
      style: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
    );
    if (widgetsOptions["Text Widget"] == widgetsOptions["Image Widget"] &&
        widgetsOptions["Text Widget"] == false &&
        widgetsOptions["Button Widget"] == true) {
      widgetList.value = [
        Spacer(),
        message,
        Spacer(),
        ButtonWidget(),
        Spacer()
      ];
    } else {
      //save to firebase
      if (widgetsOptions["Text Widget"] == true) {
        String textData = textController.text;

        if (textData.isEmpty) {
          Get.snackbar("Empty Text!", "Please enter text to save");
          return;
        }

        await firestore.collection('widgets').add({
          'type': 'Text',
          'content': textData,
        });
        Get.snackbar("Success", "Successfully saved");
      }

      // if (widgetsOptions["Image Widget"] == true &&
      //     selectedImage.value != null) {
      //   File? imageFile;
      //   if (!kIsWeb) {
      //     imageFile = selectedImage.value!;
      //   }
      //   String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      //
      //   try {
      //     (kIsWeb)
      //         ? await storage.ref(fileName).putData(webImage.value!)
      //         : await storage.ref(fileName).putFile(selectedImage.value!);
      //     String downloadURL = await storage.ref(fileName).getDownloadURL();
      //     await firestore.collection('widgets').add({
      //       'type': 'Image',
      //       'imageUrl': downloadURL,
      //     });
      //   } catch (e) {
      //     Get.snackbar("Error", "Failed to upload image: $e");
      //   }
      // }

      if (widgetsOptions["Image Widget"] == true) {
        String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

        try {
          String? downloadURL;

          if (kIsWeb && webImage.value != null) {
            // Web Upload: Use Uint8List
            final ref = storage.ref().child(fileName);
            await ref.putData(webImage.value!);
            downloadURL = await ref.getDownloadURL();
          } else if (!kIsWeb && selectedImage.value != null) {
            // Mobile Upload: Use File
            File imageFile = selectedImage.value!;
            final ref = storage.ref().child(fileName);
            await ref.putFile(imageFile);
            downloadURL = await ref.getDownloadURL();
          }

          // Store image URL only if upload was successful
          if (downloadURL != null) {
            await firestore.collection('widgets').add({
              'type': 'Image',
              'imageUrl': downloadURL,
            });

            Get.snackbar("Success", "Successfully uploaded image!");
          } else {
            Get.snackbar("Error", "No image selected!");
          }
        } catch (e) {
          Get.snackbar("Error", "Failed to upload image: $e");
        }
      }
    }
  }
}
