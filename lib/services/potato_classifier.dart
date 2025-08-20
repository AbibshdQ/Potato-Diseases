import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class PotatoClassifier {
  late Interpreter _interpreter;

  final List<String> labels = [
    'Potato___Early_blight',
    'Potato___Late_blight',
    'Potato___healthy',
  ];

  Future<void> loadModel() async {
    // Jangan pakai "assets/" di depannya
    _interpreter =
        await Interpreter.fromAsset("assets/models/potato_leaf_model.tflite");
  }

  Future<Map<String, dynamic>> predict(File file) async {
    // Baca & resize gambar
    final raw = img.decodeImage(await file.readAsBytes())!;
    final resized = img.copyResize(raw, width: 224, height: 224);

    // Bentuk input [1, 224, 224, 3] Float32List
    var input = Uint8List(1 * 224 * 224 * 3);
    var buffer = input.buffer.asUint8List();

    int index = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        var pixel = resized.getPixel(x, y);
        buffer[index++] = img.getRed(pixel);
        buffer[index++] = img.getGreen(pixel);
        buffer[index++] = img.getBlue(pixel);
      }
    }

    // Bentuk output [1, labels.length]
    var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

    // Jalankan inferensi
    _interpreter.run(input.reshape([1, 224, 224, 3]), output);

    // Cari prediksi terbaik
    int best = 0;
    for (int i = 1; i < labels.length; i++) {
      if (output[0][i] > output[0][best]) {
        best = i;
      }
    }

    final readable = {
      'Potato___Early_blight': 'Early Blight',
      'Potato___Late_blight': 'Late Blight',
      'Potato___healthy': 'Healthy',
    }[labels[best]]!;

    return {
      'className': readable,
      'confidence': output[0][best] * 100,
    };
  }
}
