import 'dart:io';
import 'dart:math';
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

  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce((a, b) => a > b ? a : b);
    final exps = logits.map((x) => (x - maxLogit)).map((x) => exp(x)).toList();
    final sumExps = exps.reduce((a, b) => a + b);
    return exps.map((x) => x / sumExps).toList();
  }

  Future<Map<String, dynamic>> predict(File file) async {
    // Load and preprocess the image
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Unable to decode image');
    }
    img.Image resized = img.copyResize(image, width: 224, height: 224);

    // Normalize the image to [0, 1] and convert to float32
    List<List<List<double>>> input = List.generate(
      224,
      (y) => List.generate(
        224,
        (x) => List.generate(
          3,
          (c) => resized.getPixel(x, y).toRadixString(16).length == 8
              ? [
                    img.getRed(resized.getPixel(x, y)),
                    img.getGreen(resized.getPixel(x, y)),
                    img.getBlue(resized.getPixel(x, y))
                  ][c] /
                  255.0
              : 0.0,
        ),
      ),
    );

    // ...existing code...
    var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    _interpreter.run([input], output);

    print('Output sebelum softmax: ${output[0]}');

    List<double> probs = _softmax(List<double>.from(output[0]));

    print('Output setelah softmax: $probs');
// ...existing code...

    // Cari prediksi terbaik
    int best = 0;
    for (int i = 1; i < labels.length; i++) {
      if (probs[i] > probs[best]) {
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
      'confidence': probs[best] * 100,
    };
  }
}
