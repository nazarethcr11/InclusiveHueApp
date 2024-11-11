import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path; // Para manejar rutas
import 'package:inclusive_hue_app/provider/ColorFilterProvider.dart';

class RecolorCamera extends StatefulWidget {
  const RecolorCamera({Key? key}) : super(key: key);

  @override
  State<RecolorCamera> createState() => _RecolorCameraState();
}

class _RecolorCameraState extends State<RecolorCamera> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);

    await _cameraController!.initialize();
    if (!mounted) return;

    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _captureFilteredImage() async {
    try {
      // Captura la imagen usando RepaintBoundary
      RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Obtener el directorio de descargas
      Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');

      if (!downloadsDirectory.existsSync()) {
        await downloadsDirectory.create(recursive: true);
      }

      // Guarda la imagen en la carpeta de Descargas pública
      String filePath = path.join(downloadsDirectory.path, 'filtered_image.png');

      File imgFile = File(filePath);
      await imgFile.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Imagen guardada en Descargas'),
      ));
    } catch (e) {
      print('Error al guardar la imagen: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorFilterProvider = Provider.of<ColorFilterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Recolor'),
      ),
      body: _isCameraInitialized
          ? Stack(
        children: [
          // Vista previa de la cámara con el filtro de color
          RepaintBoundary(
            key: _globalKey,
            child: ColorFiltered(
              colorFilter: colorFilterProvider.colorFilter,
              child: Center(child: CameraPreview(_cameraController!)),
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _captureFilteredImage,
            child: Icon(Icons.camera),
          ),
        ],
      ),
    );
  }
}
