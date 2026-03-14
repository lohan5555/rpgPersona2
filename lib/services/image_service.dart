import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickAndSaveImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
        source: source,
        maxHeight: 1024,
        maxWidth: 1024,
        imageQuality: 85
    );
    if (pickedFile == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = p.basename(pickedFile.path);
    final savedImage = File('${directory.path}/$fileName');

    return File(pickedFile.path).copy(savedImage.path);
  }

  Future<File> saveByteImage(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = 'crop_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File file = File('${directory.path}/$fileName');
    return await file.writeAsBytes(bytes);
  }
}
