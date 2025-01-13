import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../controllers/scanner_controller.dart';

class ScannerScreen extends StatelessWidget {
  final CameraDescription camera;

  const ScannerScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    final ScannerController controller = Get.put(ScannerController());

    // Initialize the camera when the widget is first built
    controller.initializeCamera(camera);

    return Scaffold(
      appBar: AppBar(title: const Text("Document Scanning")),
      body: Obx(() {
        // Checking if the camera is initialized
        if (!controller.isCameraInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: controller.capturedImage.value == null
                  ? CameraPreview(controller.cameraController!)
                  : Image.file(controller.capturedImage.value!),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.captureImage,
                  icon: const Icon(Icons.camera),
                  label: const Text("Capture"),
                ),
                ElevatedButton.icon(
                  onPressed: controller.pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text("Pick"),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    controller.extractedText.value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
