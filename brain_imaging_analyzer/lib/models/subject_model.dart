class SubjectModel {
  SubjectModel({
    required this.subjectId,
    required this.controlType,
    required this.imageMatrix
  });

  final String subjectId;
  final String controlType;
  final List<int> imageMatrix;

  List<int> images=[];
}