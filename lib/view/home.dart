import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/widget_controller.dart';
import 'package:untitled2/view/widgets/dialog_box.dart';
import 'package:untitled2/view/widgets/mybutton.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(WidgetController());

  @override
  Widget build(BuildContext context) {
    // final double deviceHeight = MediaQuery.of(context).size.height;
    final bool isVerySmallWidth = MediaQuery.of(context).size.width < 520;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Assignment App"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: (!kIsWeb || isVerySmallWidth)
              ? _widgetList()
              : Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [
                      Spacer(),
                      _widgetList(),
                      Spacer(),
                      MyDialog(),
                      Spacer(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _widgetList() {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = deviceHeight < 520;
    final bool isSmallWidth = MediaQuery.of(context).size.width < 1000;
    final bool isVerySmallWidth = MediaQuery.of(context).size.width < 520;

    return Column(
      children: [
        Obx(
          () => Container(
              height: (kIsWeb)
                  ? MediaQuery.of(context).size.height * 0.8
                  : MediaQuery.of(context).size.height * 0.6,
              width: (isVerySmallWidth)
                  ? MediaQuery.of(context).size.width * 0.9
                  : (isSmallWidth)
                      ? MediaQuery.of(context).size.width * 0.4
                      : (isSmallScreen)
                          ? MediaQuery.of(context).size.width * 0.7
                          : (kIsWeb)
                              ? MediaQuery.of(context).size.height * 0.8
                              : MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 174, 253, 206),
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
                  : (isSmallScreen)
                      ? LayoutBuilder(builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: Column(
                              children:
                                  controller.widgetList.value.map((widget) {
                                if (widget is Spacer) {
                                  return SizedBox(
                                      height: 20); // or any desired height
                                }
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: widget,
                                );
                              }).toList(),
                            ),
                          );
                        })
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: controller.widgetList.value,
                        )),
        ),
        if (!kIsWeb || isVerySmallWidth) ...[
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
      ],
    );
  }
}
