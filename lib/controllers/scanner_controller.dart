import 'dart:io';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../services/image_processing_service.dart';
import '../services/text_recognition_service.dart';

class ScannerController extends GetxController {
  // Camera controller
  CameraController? cameraController;
  RxBool isCameraInitialized = false.obs;
  Rx<File?> capturedImage = Rx<File?>(null);
  RxString extractedText = ''.obs;

  // Initialize the camera
  Future<void> initializeCamera(CameraDescription camera) async {
    cameraController = CameraController(camera, ResolutionPreset.high);
    await cameraController!.initialize();
    isCameraInitialized.value = true;
  }

  // Capture the image
  Future<void> captureImage() async {
    try {
      final image = await cameraController!.takePicture();
      capturedImage.value = File(image.path);
      await extractText(capturedImage.value!);
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  // Extract text from image
  Future<void> extractText(File imageFile) async {
    String text = await TextRecognitionService.extractText(imageFile);
    extractedText.value = text;
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    File? pickedFile = await ImageProcessingService.pickImage();
    if (pickedFile != null) {
      capturedImage.value = pickedFile;
      await extractText(pickedFile);
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
