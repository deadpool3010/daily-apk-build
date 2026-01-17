import 'package:bandhucare_new/core/network/controller/network_controller.dart';
import 'package:bandhucare_new/core/network/widget/network_button.dart';
import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetScreen extends StatelessWidget {
  NoInternetScreen({super.key});
  final controller = Get.find<NetworkController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // MAIN CONTENT (Text + Button)
          // Container(color: Colors.red),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 140), // space for icon
              const Text(
                "No Internet Connection",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              const SizedBox(height: 12),
              const Text(
                "Please check your network and try again",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 30),
              Obx(() {
                return controller.isChecking.value
                    ? const CircularProgressIndicator()
                    : NetworkButton(
                        title: "Retry",
                        onPressed: () {
                          controller.retry();
                        },
                      );
              }),
            ],
          ),

          // FLOATING ICON (absolute positioned)
          // Container(color: Colors.red),
          const Align(
            alignment: Alignment(0, -0.45), // << control only this
            child: NoInternetIcon(),
          ),
        ],
      ),
    );
  }
}

class NoInternetIcon extends StatelessWidget {
  const NoInternetIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      height: 188,
      child: Image.asset(ImageConstant.no_internet_icon, fit: BoxFit.fill),
    );
  }
}
