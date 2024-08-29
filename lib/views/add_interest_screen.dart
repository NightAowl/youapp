import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../blocs/profile_bloc/profile_event.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/profile_bloc/profile_bloc.dart';
import '../widgets/gradient_scaffold.dart';

class AddInterestScreen extends StatefulWidget {
  static const routeName = '/add-interest';
  const AddInterestScreen({super.key});

  @override
  State<AddInterestScreen> createState() => _AddInterestScreenState();
}

class _AddInterestScreenState extends State<AddInterestScreen> {
  final _textfieldTagsController = TextfieldTagsController<String>();

  @override
  void dispose() {
    _textfieldTagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> selectedInterests =
        ModalRoute.of(context)?.settings.arguments as List<String>;

    void successSnackBar() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Interests saved successfully'),
        ),
      );
    }

    void failedSnackBar() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save interests'),
        ),
      );
    }

    void saveInterests() {
      try {
        final authState = BlocProvider.of<AuthBloc>(context).state;
        if (authState is AuthSuccess) {
          final token = authState.token;
          final profileBloc = BlocProvider.of<ProfileBloc>(context);

          profileBloc.add(
            UpdateProfileEvent(
              token: token,
              interests: selectedInterests,
            ),
          );

          profileBloc.add(
            GetProfileEvent(token: token),
          );

          successSnackBar();

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        } else {
          failedSnackBar();
        }
      } on Exception catch (_) {
        failedSnackBar();
      }
    }

    return GradientScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(''),
        actions: [
          TextButton(
            onPressed: saveInterests,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 170),
            const Text(
              'Tell everyone about yourself',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'What interests you?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFieldTags<String>(
              textfieldTagsController: _textfieldTagsController,
              initialTags: selectedInterests,
              letterCase: LetterCase.normal,
              validator: (tag) {
                return selectedInterests.contains(tag)
                    ? 'You\'ve already entered that'
                    : null;
              },
              inputFieldBuilder: (context, inputFieldValues) {
                return GestureDetector(
                  onTap: () => inputFieldValues.focusNode.requestFocus(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ...inputFieldValues.tags.map(
                          (String tag) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      inputFieldValues.onTagRemoved(tag);
                                      setState(() {
                                        selectedInterests.remove(tag);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: IntrinsicWidth(
                                child: TextField(
                                  controller:
                                      inputFieldValues.textEditingController,
                                  focusNode: inputFieldValues.focusNode,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    isDense: true,
                                    border: InputBorder.none,
                                    filled: false,
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: inputFieldValues.onTagChanged,
                                  onSubmitted: (String value) {
                                    value = value[0].toUpperCase() +
                                        value.substring(1);
                                    inputFieldValues.onTagSubmitted(value);
                                    setState(() {
                                      selectedInterests.add(value);
                                    });
                                    inputFieldValues.focusNode.requestFocus();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
