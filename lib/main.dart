import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'screens/scanner_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Scan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ScannerScreen(camera: camera),
    );
  }
}
