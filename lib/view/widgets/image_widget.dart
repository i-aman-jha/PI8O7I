import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/widget_controller.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WidgetController>();

    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.pickImage();
        },
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 220, 220, 220),
          ),
          child: controller.selectedImage.value != null
              ? Image.file(
                  controller.selectedImage.value!,
                  height: 200,
                )
              : Center(
                  child: Text(
                    "Upload Image",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
