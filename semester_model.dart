import 'package:gpa_calculator/models/subject_model.dart';
import 'package:hive/hive.dart';
part 'semester_model.g.dart';

@HiveType(typeId: 0)
class SemesterModel extends HiveObject {
  @HiveField(0)
  final int year;
  @HiveField(1)
  final int semester;
  @HiveField(2)
  final List<SubjectModel> subjects;

  SemesterModel({
    required this.year,
    required this.semester,
    required this.subjects
  });

  double get gpa {
    if (subjects.isEmpty) return 0.0;

    double total = 0;

    for (var subject in subjects) {
      total += _gradeToPoint(subject.grade);
    }

    return total / subjects.length;
  }

  double _gradeToPoint(String grade) {
    switch (grade.toUpperCase()) {
      case "A+":
      case "A":
        return 4.0;
      case "A-":
        return 3.7;
      case "B+":
        return 3.3;
      case "B":
        return 3.0;
      case "B-":
        return 2.7;
      case "C+":
        return 2.3;
      case "C":
        return 2.0;
      case "C-":
        return 1.7;
      case "D":
        return 1.0;
      default:
        return 0.0;
    }
  }
}
