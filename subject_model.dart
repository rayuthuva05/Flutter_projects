import 'package:hive/hive.dart';
part 'subject_model.g.dart';

@HiveType(typeId: 1)
class SubjectModel extends HiveObject {
  @HiveField(0)
  final String subjectCode;

  @HiveField(1)
  final String grade;

  SubjectModel({
    required this.subjectCode,
    required this.grade,
  });
}