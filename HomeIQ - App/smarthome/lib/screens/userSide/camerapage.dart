import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);

    await _cameraController!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<XFile?> takePicture() async {
    if (!_isCameraInitialized) {
      print('Camera is not initialized');
      return null;
    }

    final directory = await getApplicationDocumentsDirectory();
    final String filePath = path.join(directory.path, '${DateTime.now()}.jpg');

    try {
      await _cameraController!.takePicture();
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
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Example'),
      ),
      body: Column(
        children: [
          if (_isCameraInitialized)
            AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              XFile? photoFile = await takePicture();

              if (photoFile != null) {
                Map<String, dynamic>? prediction =
                    await sendPhotoToModel(photoFile);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PredictionScreen(prediction: prediction),
                  ),
                );
              }
            },
            child: Text('Capture and Send Photo'),
          ),
        ],
      ),
    );
  }
}

class PredictionScreen extends StatelessWidget {
  final Map<String, dynamic>? prediction;

  PredictionScreen({required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Result'),
      ),
      body: prediction != null
          ? Center(
              child: Text(
                'Prediction: ${prediction!['prediction']}',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Center(
              child: Text(
                'Failed to get prediction',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
    );
  }
}
