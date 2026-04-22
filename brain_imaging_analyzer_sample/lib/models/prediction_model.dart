import 'package:hive/hive.dart';

part 'prediction_model.g.dart';

@HiveType(typeId: 0)
class PredictionModel extends HiveObject{

  @HiveField(0)
  final String subjectId;
  @HiveField(1)
  final String subjectType;
  @HiveField(2)
  final String prediction;
  @HiveField(3)
  final double confidence;
  @HiveField(4)
  final String filepath;
  @HiveField(5)
  final DateTime date;

  PredictionModel({
    required this.subjectId,
    required this.subjectType,
    required this.prediction,
    required this.confidence,
    required this.filepath,
    required this.date
  });

}