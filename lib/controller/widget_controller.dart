import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/view/widgets/button_widget.dart';
import 'package:untitled2/view/widgets/image_widget.dart';
import 'package:untitled2/view/widgets/text_widget.dart';

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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    } else {
      Get.snackbar("No Image Selected", "Please select an image.");
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

        await firestore.collection('widgets').add({
          'type': 'Text',
          'content': textData,
        });
        Get.snackbar("Success", "Successfully saved");
      }

      if (widgetsOptions["Image Widget"] == true &&
          selectedImage.value != null) {
        File imageFile = selectedImage.value!;
        String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

        try {
          await storage.ref(fileName).putFile(imageFile);
          String downloadURL = await storage.ref(fileName).getDownloadURL();
          await firestore.collection('widgets').add({
            'type': 'Image',
            'imageUrl': downloadURL,
          });
        } catch (e) {
          Get.snackbar("Error", "Failed to upload image: $e");
        }
      }
    }
  }
}
