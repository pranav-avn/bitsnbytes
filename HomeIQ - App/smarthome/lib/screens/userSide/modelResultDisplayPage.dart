import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class CameraPredictionScreen extends StatefulWidget {
  @override
  _CameraPredictionScreenState createState() => _CameraPredictionScreenState();
}

class _CameraPredictionScreenState extends State<CameraPredictionScreen> {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  Map<String, dynamic>? prediction;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras![0], ResolutionPreset.high);

    await cameraController!.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<XFile?> takePicture() async {
    if (!isCameraInitialized) {
      print('Camera is not initialized');
      return null;
    }

    final directory = await getApplicationDocumentsDirectory();
    final String filePath = path.join(directory.path, '${DateTime.now()}.jpg');

    try {
      await cameraController!.takePicture();
      return XFile(filePath);
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendPhotoToModel(XFile photoFile) async {
    final Uri url = Uri.parse(
        'https://universe.roboflow.com/kanwal-masroor-gv4jr/yolov7-license-plate-detection'); // Replace with your ML model endpoint

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', photoFile.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        return jsonDecode(responseData);
      } else {
        print('Failed to get prediction. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending photo to model: $e');
      return null;
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera and Prediction'),
      ),
      body: Column(
        children: [
          if (isCameraInitialized)
            AspectRatio(
              aspectRatio: cameraController!.value.aspectRatio,
              child: CameraPreview(cameraController!),
            ),
          SizedBox(height: 20),
          prediction != null
              ? Center(
                  child: Text(
                    'Prediction: ${prediction!['prediction']}',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : Center(
                  child: Text(
                    'No prediction made yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              XFile? photoFile = await takePicture();

              if (photoFile != null) {
                Map<String, dynamic>? predictionResult =
                    await sendPhotoToModel(photoFile);

                setState(() {
                  prediction = predictionResult;
                });
              }
            },
            child: Text('Capture and Predict'),
          ),
        ],
      ),
    );
  }
}
