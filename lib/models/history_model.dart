import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 0)
class HistoryModel extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String diseaseName;

  @HiveField(2)
  late double confidence;

  @HiveField(3)
  late String imagePath; // local path foto

  @HiveField(4)
  late DateTime date;
}
