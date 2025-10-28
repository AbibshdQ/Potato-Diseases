import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 0)
class HistoryModel extends HiveObject {
  @HiveField(0)
  int id = 0;

  // reference ke diseaseBox key (nullable)
  @HiveField(5)
  int? diseaseKey;

  @HiveField(1)
  String? diseaseName;

  @HiveField(2)
  double confidence = 0.0;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  DateTime? date;

  HistoryModel();
}
