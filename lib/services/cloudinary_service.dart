import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName =
      'duduu1rib'; // replace with your Cloudinary cloud name
  final String uploadPreset = 'student_profile'; // replace with your preset

  Future<String?> uploadImageFromUrl(String imageUrl, String folder) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/duduu1rib/image/upload',
      );

      // Cloudinary accepts remote URLs via "file" field in a normal POST
      final response = await http.post(
        uri,
        body: {
          'upload_preset': uploadPreset,
          'folder': folder,
          'file': imageUrl,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['secure_url'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //  Upload image from device (Gallery/Camera)
  Future<String?> uploadImageFile(File file, String folder) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = folder
        ..files.add(await http.MultipartFile.fromPath('file', file.path));
      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        return data['secure_url'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
