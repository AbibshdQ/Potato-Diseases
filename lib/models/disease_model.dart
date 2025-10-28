import 'package:hive/hive.dart';

part 'disease_model.g.dart';

@HiveType(typeId: 1)
class DiseaseModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  List<String>? prevention;

  @HiveField(3)
  List<String>? treatments;

  DiseaseModel({
    required this.name,
    this.description,
    this.prevention,
    this.treatments,
  });
}
