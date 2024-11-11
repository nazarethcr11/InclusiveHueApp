import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageUploadService {
  static const String baseUrl = '';

  static Future<Map<String, dynamic>> uploadImage(File imageFile, String type, String subtype) async {

    final url = Uri.parse('$baseUrl/upload/');
    //for monochromatic no need for subtype
    final request = http.MultipartRequest('POST', url)
      ..fields['type'] = type
      ..fields['subtype'] = subtype
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    if (type == 'achromatic') {
      request.fields.remove('subtype');
    }
    //imprimir la url de la solicitud
    print ("URL de la solicitud: ${url}");
    //imprimir los campos de la solicitud
    print ("Campos de la solicitud: ${request.fields}");
    //imprimir los archivos de la solicitud
    print ("Archivos de la solicitud: ${request.files}");
    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        return {
          'status': 'success',
          'data': json.decode(responseBody.body),
        };
      } else {
        //imprimir el error
        print ("Error: ${json.decode(responseBody.body)['error']}");
        return {
          'status': 'error',
          'error': json.decode(responseBody.body)['error'],
        };
      }
    } catch (e) {
      //imprimir el error
      print ("Error: ${e}");
      return {
        'status': 'error',
        'error': 'An error occurred during image upload. Please try again.',
      };
    }
  }

}
