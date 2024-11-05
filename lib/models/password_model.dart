class PasswordModel {
  late final String? id;
  final String title;
  final String username;
  final String email;
  final String password;
  final List<QuestionAnswerModel> extra;

  PasswordModel(
      {this.id,
      required this.title,
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

  factory PasswordModel.fromJson(Map<String, dynamic> json, String id) {
    return PasswordModel(
      id: id,
      title: json['title'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      extra: (json['extra'] as List<dynamic>)
          .map((item) =>
              QuestionAnswerModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
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

  factory QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuestionAnswerModel(
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
}
