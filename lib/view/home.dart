import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/widget_controller.dart';
import 'package:untitled2/view/widgets/dialog_box.dart';
import 'package:untitled2/view/widgets/mybutton.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WidgetController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Assignment App"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => Container(
                    height: (kIsWeb)
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 0.6,
                    width: (kIsWeb)
                        ? MediaQuery.of(context).size.height * 0.6
                        : MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(71, 0, 255, 94),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: (controller.widgetList.value.isEmpty)
                        ? Center(
                            child: Text(
                              "No widget is added",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: controller.widgetList.value,
                          )),
              ),
              SizedBox(
                height: (kIsWeb) ? 40 : 20,
              ),
              MyButton(
                text: "Add Widget",
                onPressed: () {
                  Get.dialog(const MyDialog());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
