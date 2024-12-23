import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/widget_controller.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WidgetController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 220, 220, 220),
      ),
      child: TextField(
        controller: controller.textController,
        decoration: const InputDecoration(
          hintText: "Enter Text",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
