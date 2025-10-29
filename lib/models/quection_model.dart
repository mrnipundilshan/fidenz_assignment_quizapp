class QuectionModel {
  final String question;
  final String solution;

  QuectionModel({required this.question, required this.solution});

  // json -> quection
  factory QuectionModel.fromJson(Map<String, dynamic> json) {
    return QuectionModel(
      question: json['quection'],
      solution: json['solution'],
    );
  }
}
