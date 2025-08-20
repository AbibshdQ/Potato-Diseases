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
    _interpreter = await Interpreter.fromAsset('models/potato_leaf_model.tflite');
  }

  Future<Map<String, dynamic>> predict(File file) async {
    final raw = img.decodeImage(await file.readAsBytes())!;
    final resized = img.copyResize(raw, width: 224, height: 224);

    var input = Float32List(1 * 224 * 224 * 3);
    var idx = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        input[idx++] = img.getRed(pixel) / 255.0;
        input[idx++] = img.getGreen(pixel) / 255.0;
        input[idx++] = img.getBlue(pixel) / 255.0;
      }
    }

    final output = List.generate(labels.length, (_) => 0.0).reshape([1, labels.length]);
    _interpreter.run(input.buffer.asUint8List(), output);

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
