import 'package:flutter/material.dart';
import 'package:my_stash/constants/strings.dart';
import 'package:my_stash/exceptions/custom_exception.dart';
import 'package:my_stash/models/password_model.dart';
import 'package:my_stash/models/question_answer.dart';
import 'package:my_stash/models/user_model.dart';
import 'package:my_stash/providers/passwords_provider.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/password_form_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/services/validator_service.dart';
import 'package:my_stash/widgets/help_dialog.dart';
import 'package:my_stash/widgets/loading_screen_controller.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ManagePasswordPage extends StatefulWidget {
  final PasswordModel? password;

  const ManagePasswordPage({super.key, this.password});

  @override
  State<ManagePasswordPage> createState() => _ManagePasswordPageState();
}

class _ManagePasswordPageState extends State<ManagePasswordPage> {
  final _manageFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<QuestionAnswer> questionAnswers = [];

  @override
  void dispose() {
    // Dispose the controllers when the state is removed
    _titleController.dispose();
    _userController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    for (var question in questionAnswers) {
      question.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // populate form if passwords is present
    if (widget.password != null) {
      _titleController.text = widget.password!.title;
      _userController.text = widget.password!.username;
      _emailController.text = widget.password!.email;
      _passwordController.text = widget.password!.password;
      if (widget.password!.extra.isNotEmpty) {
        for (var extra in widget.password!.extra) {
          // Create a new QuestionAnswer with the provided question and answer
          var questionAnswer = QuestionAnswer();
          questionAnswer.questionController.text = extra.question;
          questionAnswer.answerController.text = extra.answer;
          questionAnswers.add(questionAnswer);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValidatorService validator = ValidatorService();
    final _passwordFormService = PasswordFormService();

    String orgPasswordText = '';

    void addSecurityQuestion() {
      setState(() {
        questionAnswers.add(QuestionAnswer());
      });
    }

    // Remove security question fields
    void removeSecurityQuestion(int index) {
      setState(() {
        questionAnswers[index].dispose();
        questionAnswers.removeAt(index);
      });
    }

    InputDecoration buildInputDecoration(String hint, IconData icon) {
      return InputDecoration(
        prefixIcon:
            Icon(icon, color: Theme.of(context).colorScheme.onSecondary),
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onSecondary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      );
    }

    Widget buildMainFormFields() {
      return Column(
        children: [
          TextFormField(
            controller: _titleController,
            validator: (value) =>
                validator.requiredFieldValidator(value, AppStrings.title),
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            decoration: buildInputDecoration(AppStrings.title, Icons.title),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _userController,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            decoration: buildInputDecoration(
                AppStrings.username, Icons.person_3_outlined),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            validator: validator.emailValidator,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            decoration:
                buildInputDecoration(AppStrings.email, Icons.email_outlined),
          ),
          const SizedBox(height: 10),
          Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                // Store original text and clear field when focused
                orgPasswordText = _passwordController.text;
                _passwordController.text = '';
              } else {
                // Restore original text if field is empty when focus is lost
                if (_passwordController.text.isEmpty && orgPasswordText != '') {
                  _passwordController.text = orgPasswordText;
                  orgPasswordText = '';
                }
              }
            },
            child: TextFormField(
              controller: _passwordController,
              validator: (value) =>
                  validator.requiredFieldValidator(value, AppStrings.password),
              obscureText: true,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              decoration:
                  buildInputDecoration(AppStrings.password, Icons.password),
            ),
          ),
        ],
      );
    }

    Widget buildExtraFieldsHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                AppStrings.extra,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => showHelpDialog(context),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: addSecurityQuestion,
          ),
        ],
      );
    }

    // Single extra field card
    Widget buildExtraFieldCard(int idx, QuestionAnswer qa) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 24), // Space for the remove button
                  TextFormField(
                    controller: qa.questionController,
                    validator: (value) {
                      validator.requiredFieldValidator(
                          value, AppStrings.question);

                      final currentQuestion = value?.trim().toLowerCase() ?? '';
                      final duplicateFound = questionAnswers
                          .asMap()
                          .entries
                          .any((entry) =>
                              entry.key != idx &&
                              entry.value.questionController.text
                                      .trim()
                                      .toLowerCase() ==
                                  currentQuestion);

                      if (duplicateFound) {
                        return AppStrings.questionAlreadyExists;
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.question_mark,
                          color: Theme.of(context).colorScheme.onSecondary),
                      hintText: AppStrings.question,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        // Store original text and clear field when focused
                        orgPasswordText = qa.answerController.text;
                        qa.answerController.text = '';
                      } else {
                        // Restore original text if field is empty when focus is lost
                        if (qa.answerController.text.isEmpty &&
                            orgPasswordText != '') {
                          qa.answerController.text = orgPasswordText;
                          orgPasswordText = '';
                        }
                      }
                    },
                    child: TextFormField(
                      controller: qa.answerController,
                      validator: (value) => validator.requiredFieldValidator(
                          value, AppStrings.answer),
                      obscureText: true,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.question_answer,
                            color: Theme.of(context).colorScheme.onSecondary),
                        hintText: AppStrings.answer,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => removeSecurityQuestion(idx),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildExtraFields() {
      return Column(
        children: [
          const SizedBox(height: 20),
          buildExtraFieldsHeader(),
          ...questionAnswers.asMap().entries.map(
                (entry) => buildExtraFieldCard(entry.key, entry.value),
              ),
        ],
      );
    }

    Widget manageForm = Form(
      key: _manageFormKey,
      child: Column(
        children: [
          buildMainFormFields(),
          buildExtraFields(),
        ],
      ),
    );

    final String appTitle =
        widget.password != null ? AppStrings.edit : AppStrings.add;

    void saveForm() async {
      if (!(_manageFormKey.currentState?.validate() ?? true)) {
        return;
      }
      LoadingScreen.instance().show(context: context);
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final passwordProvider =
            Provider.of<PasswordsProvider>(context, listen: false);
        UserModel? user = userProvider.user;

        if (user != null) {
          List<QuestionAnswerModel> extraFields = questionAnswers
              .map((q) => QuestionAnswerModel(
                  question: q.questionController.text,
                  answer: q.answerController.text))
              .toList();

          if (appTitle == AppStrings.add) {
            final addedPassword = await _passwordFormService.addNewPassword(
                userId: user.id,
                title: _titleController.text,
                username: _userController.text,
                email: _emailController.text,
                password: _passwordController.text,
                extraFields: extraFields);
            passwordProvider.addNewPassword(addedPassword);
            ToastService.showToast(AppStrings.successPasswordAdd);
          } else {
            final editedPassword =
                await _passwordFormService.updateExistingPassword(
                    userId: user.id,
                    oldPassword: widget.password!,
                    title: _titleController.text,
                    username: _userController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    editedExtraFields: extraFields);
            passwordProvider.editPassword(editedPassword, widget.password!.id!);
            passwordProvider.setPassword(editedPassword);
            ToastService.showToast(AppStrings.successPasswordEdit);
          }
          Navigator.pop(context);
        }
      } on CustomException catch (ce) {
        ToastService.showToast(ce.toString(), type: ToastificationType.error);
      }
      LoadingScreen.instance().hide();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(appTitle)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                manageForm,
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary, // Use the theme's primary color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16), // Button height
                    ),
                    child: Text(
                      AppStrings.save,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
