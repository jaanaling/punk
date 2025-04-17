import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_eye_of_the_world/src/core/utils/size_utils.dart';
import 'package:the_eye_of_the_world/src/feature/main/bloc/app_bloc.dart';
import 'package:the_eye_of_the_world/src/feature/main/model/model.dart';
import 'package:go_router/go_router.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentPhraseIndex = 0;
  String _speakerId = '';
  CharacterDossier? firstParticipantDossier;
  CharacterDossier? secondParticipantDossier;

  void _nextPhrase(
    List<DialoguePhrase> phrases,
    List<DialogueChoice> choices,
    List<String> participants,
    List<CharacterDossier> allDossiers,
  ) {
    if (_currentPhraseIndex < phrases.length - 1) {
      _speakerId = phrases[_currentPhraseIndex + 1].speakerId;
    } else {
      _speakerId = ''; // No speaker for choices
    }
    if (_speakerId != 'NARRATOR' && _speakerId.isNotEmpty) {
      final speakerName =
          allDossiers.firstWhere((element) => element.name == _speakerId).name;
      if (participants.length > 1) {
        if (firstParticipantDossier?.name == speakerName) {
          secondParticipantDossier = allDossiers.firstWhere(
            (element) => element.name == participants.last,
          );
        } else {
          secondParticipantDossier = firstParticipantDossier;
          firstParticipantDossier = allDossiers.firstWhere(
            (element) => element.name == speakerName,
          );
        }
      } else if (participants.length == 1) {
        firstParticipantDossier = allDossiers.firstWhere(
          (element) => element.name == speakerName,
        );
      }
    }

    setState(() {
      _currentPhraseIndex++;
      if (_currentPhraseIndex >= phrases.length) {
        if (choices.isNotEmpty) {
          // Показываем варианты выбора
          return;
        } else {
          // TODO: Вернуться назад или начать сначала (или что-то еще)
          debugPrint('Диалог закончился и нет вариантов выбора.');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogueBloc, DialogueState>(
      builder: (context, state) {
        if (state.isLoading || state.currentBranch == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentBranch = state.currentBranch!;
        final location = currentBranch.location;
        final currentPhrase = _currentPhraseIndex < currentBranch.phrases.length
            ? currentBranch.phrases[_currentPhraseIndex]
            : null;
        final participants = currentBranch.participantsIds;
        String firstEmotion =  currentPhrase?.emotion ?? 'neutral';
        String secondEmotion = "neutral";
        
        

        if (_currentPhraseIndex == 0 && participants.isNotEmpty) {
          final allDossiers = state.gameState.dossiers;

          if (participants.length > 1) {
            firstParticipantDossier = allDossiers.firstWhere(
              (element) => element.name == participants.first,
            );
            secondParticipantDossier = allDossiers.firstWhere(
              (element) => element.name == participants.last,
            );
          } else if (participants.length == 1) {
            firstParticipantDossier = allDossiers.firstWhere(
              (element) => element.name == participants.first,
            );
          }
          _speakerId = currentBranch.phrases.first.speakerId;
        }

        bool isFirstDimmed = false;
        bool isSecondDimmed = false;
        if (_speakerId != 'NARRATOR' && _speakerId.isNotEmpty) {
          final speakerName = state.gameState.dossiers
              .firstWhere((element) => element.name == _speakerId)
              .name;
          isFirstDimmed = firstParticipantDossier?.name != speakerName;
          isSecondDimmed = secondParticipantDossier?.name != speakerName;

          if (!isFirstDimmed) {
            firstEmotion =
                'assets/images/${_speakerId} ${currentPhrase?.emotion}.webp';
          }
          if (!isSecondDimmed) {
            secondEmotion =
                'assets/images/${_speakerId} ${currentPhrase?.emotion}.webp';
          }
        }

        return Scaffold(
          body: Stack(
            children: [
              // Background Image
              Image.asset(
                'assets/images/$location.webp', // Используем location для фона
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              // Dossier Button
              Positioned(
                top: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildDossierDialog(state, context),
                    );
                  },
                  child: const Text('Dossier'),
                ),
              ),
 
              if (firstParticipantDossier != null && _speakerId != 'NARRATOR')
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: CharacterAvatar(
                    character: firstParticipantDossier!,
                    isDimmed: isFirstDimmed,
                    emotion: firstEmotion,
                  ),
                ),
              if (secondParticipantDossier != null&& _speakerId != 'NARRATOR')
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: CharacterAvatar(
                    character: secondParticipantDossier!,
                    isDimmed: isSecondDimmed,
                    emotion: secondEmotion,
                  ),
                ),
              // Display current phrase or choices
              if (currentPhrase != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DialogueBox(
                    phrase: currentPhrase,
                    onDialogueTap: () => _nextPhrase(
                      currentBranch.phrases,
                      currentBranch.choices,
                      participants,
                      state.gameState.dossiers,
                    ),
                  ),
                )
              else if (currentBranch.choices.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: currentBranch.choices.map((choice) {
                      return ChoiceButton(
                        choiceText: choice.choiceText,
                        onPressed: () {
                          context
                              .read<DialogueBloc>()
                              .add(OptionChosenEvent(choice));
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildDossierDialog(DialogueState state, BuildContext context) {
  return AlertDialog(
    title: const Text('Dossier'),
    content: SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: state.gameState.dossiers.length,
        itemBuilder: (context, index) {
          final dossier = state.gameState.dossiers[index];
          return ListTile(
            title: Text(dossier.name),
            subtitle: Text(dossier.background),
            // You can add more details or customize the display here
          );
        },
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          context.pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}

class ChoiceButton extends StatelessWidget {
  final String choiceText;
  final VoidCallback onPressed;
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1878919193.
  const ChoiceButton({
    super.key,
    required this.choiceText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(choiceText),
    );
  }
}

class CharacterAvatar extends StatelessWidget {
  final CharacterDossier character;
  final bool isDimmed;

  final String emotion;

  const CharacterAvatar({
    super.key,
    required this.character,
    required this.isDimmed,
    required this.emotion,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDimmed ? 0.5 : 1.0,
      child: Image.asset(
        emotion,
        width: 150,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}

class DialogueBox extends StatefulWidget {
  final DialoguePhrase phrase; // Текущая фраза для отображения
  final VoidCallback
      onDialogueTap; // Функция для вызова при нажатии на окно диалога

  const DialogueBox(
      {required this.phrase, required this.onDialogueTap, Key? key})
      : super(key: key);

  @override
  State<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> {
  int _visibleTextLength = 0;
  bool _isTextFullyVisible = false;
  @override
  void initState() {
    super.initState();
    _startTextAnimation();
  }

  void _startTextAnimation() {
    if (_isTextFullyVisible) return;
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_visibleTextLength < widget.phrase.text.length &&
          !_isTextFullyVisible) {
        setState(() {
          _visibleTextLength++;
        });
        _startTextAnimation();
      } else {
        setState(() {
          _isTextFullyVisible = true;
        });
      }
    });
  }

  void _showFullText() {
    setState(() {
      _visibleTextLength = widget.phrase.text.length;
      _isTextFullyVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final speaker = widget.phrase.speakerId;
    final text = widget.phrase.text;
    final visibleText = text.substring(0, _visibleTextLength);

    Color textColor;
    switch (speaker) {
      case 'VAIR':
        textColor = Colors.green;
        break;
      case 'ERRAS':
        textColor = Colors.purple;
        break;
      case 'LYRA':
        textColor = Colors.blue;
        break;
      case 'NIKA':
        textColor = Colors.orange;
        break;
      case 'RION':
        textColor = Colors.red;
        break;
      case 'NARRATOR':
        textColor = Colors.grey.shade300;
        break;
      default:
        textColor = Colors.white;
    }

    TextAlign textAlign;
    Alignment alignment;
    if (speaker == 'VAIR') {
      textAlign = TextAlign.left;
      alignment = Alignment.bottomLeft;
    } else if (speaker == 'NARRATOR') {
      textAlign = TextAlign.center;
      alignment = Alignment.bottomCenter;
    } else {
      textAlign = TextAlign.right;
      alignment = Alignment.bottomRight;
    }

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          if (!_isTextFullyVisible) {
            _showFullText();
          } else {
            widget.onDialogueTap();
            setState(() {
              _isTextFullyVisible = false;
              _visibleTextLength = 0;
              _startTextAnimation();
            });
          }
        },
        child: Container(
          width: screenWidth * 0.2,
          height: screenHeight * 1,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            image:  const DecorationImage(
              image: AssetImage("assets/images/dialog.webp"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                speaker,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                visibleText,
                textAlign: textAlign,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
