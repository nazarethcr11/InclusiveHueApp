import 'package:flutter/material.dart';
import 'package:inclusive_hue_app/pages/color_picker_camera.dart';
import 'package:inclusive_hue_app/pages/image_color_picker.dart';
import 'package:inclusive_hue_app/pages/recolor_camera.dart';
import 'package:inclusive_hue_app/pages/recolor_image.dart';
import '../../components/my_button.dart';


class CameraToolPage extends StatefulWidget {
  const CameraToolPage({Key? key}) : super(key: key);

  @override
  State<CameraToolPage> createState() => _CameraToolPageState();
}

class _CameraToolPageState extends State<CameraToolPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //option 1 (image color picker),
          MyButton(
            text: 'Selector de Color de Imagen',
            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ImageColorPicker()));},
          ),
          SizedBox(height: 20),
          //option 2 (camera color picker),
          MyButton(
            text: 'Selector de Color de Cámara',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraColorPicker()));
            },
          ),
          SizedBox(height: 20),
          //option 3 (recolor image),
          MyButton(
            text: 'Recolorar Imagen',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecolorImage()));
            },
          ),
          SizedBox(height: 20),
          MyButton(
            text: 'Recolorar mediante camara',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecolorCamera()));
            },
          ),
        ],
      )
    );
  }
}
