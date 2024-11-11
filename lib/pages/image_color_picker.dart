import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:inclusive_hue_app/provider/color_name.dart';
import 'package:flutter/services.dart';


class ImageColorPicker extends StatefulWidget {
  @override
  _ImageColorPickerState createState() => _ImageColorPickerState();
}

class _ImageColorPickerState extends State<ImageColorPicker> {
  File? _image;
  Color? _selectedColor;
  String? _colorName;
  Offset? _touchPosition;
  GlobalKey imageKey = GlobalKey();
  img.Image? originalImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        _image = File(pickedFile.path);
        originalImage = img.decodeImage(imageBytes);
        _selectedColor = null;
        _touchPosition = null;
        _colorName = null;
      });
    }
  }

  void _getPixelColor(int x, int y) {
    if (originalImage == null) return;

    if (x < 0 || x >= originalImage!.width || y < 0 || y >= originalImage!.height) return;

    final pixel = originalImage!.getPixel(x, y);
    final color = Color.fromARGB(
      img.getAlpha(pixel), // Obtener componente alfa
      img.getRed(pixel),   // Obtener componente rojo
      img.getGreen(pixel), // Obtener componente verde
      img.getBlue(pixel),  // Obtener componente azul
    );

    setState(() {
      _selectedColor = color;
      _colorName = _getColorName(color);
    });
  }

  String _getColorName(Color color) {
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    return colorNamer.getColorName(r, g, b);
  }

  void _onPanDown(BuildContext context, DragDownDetails details) {
    RenderBox box = imageKey.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);

    double scaleX = originalImage!.width / box.size.width;
    double scaleY = originalImage!.height / box.size.height;

    int pixelX = (localPosition.dx * scaleX).toInt();
    int pixelY = (localPosition.dy * scaleY).toInt();

    _getPixelColor(pixelX, pixelY);

    setState(() {
      _touchPosition = localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selector de Color de Imagen'),
      ),
      body: Column(
        children: <Widget>[
          if (_image != null)
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onPanDown: (details) => _onPanDown(context, details),
                    child: Image.file(_image!, key: imageKey),
                  ),
                  if (_touchPosition != null)
                    Positioned(
                      left: _touchPosition!.dx - 5,
                      top: _touchPosition!.dy - 5,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (_selectedColor != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  color: _selectedColor,
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          SizedBox(height: 7),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
               elevation: 5,
              ),
              onPressed: _pickImage,
              //si ya hay una imagen, el texto pasara de seleccionar imagen a cambiar imagen
              child: _image==null? Text("Seleccionar imagen"):Text("Cambiar imagen"),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}