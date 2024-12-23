import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/widget_controller.dart';
import 'package:untitled2/view/widgets/mybutton.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WidgetController>();

    return MyButton(
      text: "Save",
      rounded: false,
      onPressed: () {
        controller.save();
      },
    );
  }
}
