import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/image_processing_service.dart';
import '../services/text_recognition_service.dart';

class ScannerScreen extends StatefulWidget {
  final CameraDescription camera;
  const ScannerScreen({super.key, required this.camera});

  @override
  State<ScannerScreen> createState() => ScannerScreenState();
}

class ScannerScreenState extends State<ScannerScreen> {
  CameraController? controller;
  Future<void>? initializeControllerFuture;
  File? capturedImage;
  String extractedText = "";

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() {
    controller = CameraController(widget.camera, ResolutionPreset.high);
    initializeControllerFuture = controller!.initialize();
  }

  Future<void> captureImage() async {
    try {
      await initializeControllerFuture;
      final image = await controller!.takePicture();
      setState(() => capturedImage = File(image.path));
      await extractText(capturedImage!);
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  Future<void> extractText(File imageFile) async {
    String text = await TextRecognitionService.extractText(imageFile);
    setState(() => extractedText = text);
  }

  Future<void> pickImage() async {
    File? pickedFile = await ImageProcessingService.pickImage();
    if (pickedFile != null) {
      setState(() => capturedImage = pickedFile);
      extractText(pickedFile);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Document Scanning")),
      body: Column(
        children: [
          Expanded(
            child: capturedImage == null
                ? FutureBuilder(
                    future: initializeControllerFuture, 
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(controller!);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }
                  )
                : Image.file(capturedImage!)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: captureImage,
                icon: const Icon(Icons.camera),
                label: const Text("Capture"),
              ),
              ElevatedButton.icon(
                onPressed: pickImage,
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
                  extractedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}