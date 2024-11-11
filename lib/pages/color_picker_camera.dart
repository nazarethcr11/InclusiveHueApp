import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:inclusive_hue_app/provider/color_name.dart';


class CameraColorPicker extends StatefulWidget {
  @override
  _CameraColorPickerState createState() => _CameraColorPickerState();
}

class _CameraColorPickerState extends State<CameraColorPicker> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  Color? _selectedColor;
  String? _colorName;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController!.initialize();

    if (!mounted) {
      return;
    }

    setState(() {
      _isCameraInitialized = true;
    });

    // Iniciar un temporizador para capturar imágenes cada segundo
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _captureImage());
  }

  Future<void> _captureImage() async {
    if (!_cameraController!.value.isInitialized || _cameraController!.value.isTakingPicture) {
      return;
    }

    try {
      final XFile file = await _cameraController!.takePicture();
      final img.Image? capturedImage = img.decodeImage(await file.readAsBytes());

      if (capturedImage != null) {
        _getCenterPixelColor(capturedImage);
      }
    } catch (e) {
      print('Error al capturar la image: $e');
    }
  }

  void _getCenterPixelColor(img.Image image) {
    final int centerX = image.width ~/ 2;
    final int centerY = image.height ~/ 2;

    // Obtener el promedio de color de un área pequeña alrededor del centro para mayor precisión
    const int areaSize = 20;
    int r = 0, g = 0, b = 0, count = 0;

    for (int dx = -areaSize; dx <= areaSize; dx++) {
      for (int dy = -areaSize; dy <= areaSize; dy++) {
        final pixel = image.getPixelSafe(centerX + dx, centerY + dy);
        r += img.getRed(pixel);
        g += img.getGreen(pixel);
        b += img.getBlue(pixel);
        count++;
      }
    }

    final color = Color.fromARGB(
      255,
      (r / count).round(),
      (g / count).round(),
      (b / count).round(),
    );

    print('Averaged Color: $color');

    setState(() {
      _selectedColor = color;
      _colorName = _getColorName(color);
    });

    print('Selected Color: $color');
    print('Color Name: $_colorName');
  }

  String _getColorName(Color color) {
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    final colorName = colorNamer.getColorName(r, g, b);
    print('Color Name from Function: $colorName');
    return colorName;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Color Picker'),
      ),
      body: _isCameraInitialized
          ? Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          if (_selectedColor != null)
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    color: _selectedColor,
                  ),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        SelectableText(
                          '#${_selectedColor!.value.toRadixString(16).toUpperCase()}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: '#${_selectedColor!.value.toRadixString(16).toUpperCase()}'));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Color copiado al portapapeles')));
                          },
                          child: Icon(Icons.copy_rounded, size: 18),
                        )
                      ]
                  ),
                  SelectableText(
                    _colorName ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
