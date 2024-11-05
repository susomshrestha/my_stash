import 'package:flutter/material.dart';

class QuestionAnswer {
  final TextEditingController questionController;
  final TextEditingController answerController;

  QuestionAnswer()
      : questionController = TextEditingController(),
        answerController = TextEditingController();

  void dispose() {
    questionController.dispose();
    answerController.dispose();
  }
}