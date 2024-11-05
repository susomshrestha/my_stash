class PasswordModel {
  final String title;
  final String username;
  final String email;
  final String password;
  final List<QuestionAnswerModel> extra;

  PasswordModel(
      {required this.title,
      required this.username,
      required this.email,
      required this.password,
      required this.extra});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'username': username,
      'email': email,
      'password': password,
      'extra': extra.map((item) => item.toJson()).toList(),
    };
  }
}

class QuestionAnswerModel {
  final String question;
  final String answer;

  QuestionAnswerModel({required this.question, required this.answer});

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
