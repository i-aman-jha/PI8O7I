import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/widget_controller.dart';
import 'package:untitled2/view/widgets/mybutton.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WidgetController>();
    final bool isSmallWidth = MediaQuery.of(context).size.width < 1000;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final bool isVerySmallWidth = MediaQuery.of(context).size.width < 520;

    return Center(
      child: Container(
        height: (kIsWeb)
            ? MediaQuery.of(context).size.height * 0.8
            : MediaQuery.of(context).size.height,
        width: (isVerySmallWidth)
            ? MediaQuery.of(context).size.width * 0.9
            : (isSmallWidth)
                ? MediaQuery.of(context).size.width * 0.4
                : (kIsWeb)
                    ? MediaQuery.of(context).size.width * 0.4
                    : MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 174, 253, 206),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.widgetsOptions.keys.length,
                itemBuilder: (context, index) {
                  String widgetName =
                      controller.widgetsOptions.keys.elementAt(index);

                  return Obx(
                    () => Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            print("clicked");
                            controller.selectWidget(widgetName);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Container(
                                  // height: 5,
                                  // width: 5,
                                  decoration: BoxDecoration(
                                    color:
                                        (controller.widgetsOptions[widgetName]!)
                                            ? Color.fromARGB(255, 15, 255, 147)
                                            : const Color.fromARGB(
                                                255, 220, 220, 220),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: (kIsWeb)
                                    ? MediaQuery.of(context).size.width * 0.2
                                    : MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 220, 220, 220),
                                ),
                                child: Center(
                                  child: Text(
                                    widgetName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              MyButton(
                text: "Import Widgets",
                onPressed: () {
                  controller.importWidget();
                  // print(controller.widget.value);
                  print(controller.widgetsOptions.values);
                  if (!kIsWeb || isVerySmallWidth) {
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
