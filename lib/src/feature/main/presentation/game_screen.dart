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
  String _firstParticipantPreviousEmotion = 'neutral';
  String _secondParticipantPreviousEmotion = 'neutral';

  void _nextPhrase(
    List<DialoguePhrase> phrases,
    List<DialogueChoice> choices,
    List<String> participants,
    List<CharacterDossier> allDossiers,
  ) {
    // Update speaker ID for the next phrase
    _speakerId = _currentPhraseIndex < phrases.length - 1
        ? phrases[_currentPhraseIndex + 1].speakerId
        : '';

    // Update character positions if the speaker has changed
    _updateCharacterPositions(participants, allDossiers);

    setState(() {
      _currentPhraseIndex++;
      if (_currentPhraseIndex >= phrases.length) {
        if (choices.isNotEmpty) {
          // Показываем варианты выбора
          return;
        } else {}
      }
    }); // Trigger rebuild
  }

  void _updateCharacterPositions(
      List<String> participants, List<CharacterDossier> allDossiers) {
    if (_speakerId == 'NARRATOR' || _speakerId.isEmpty) return;

    final speakerName = allDossiers
        .firstWhere(
          (element) => element.name == _speakerId,
        )
        .name;
    if (speakerName.isEmpty) return; // Speaker not found, do nothing

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
      secondParticipantDossier = null; // No second participant
    }
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
        String firstParticipantEmotion = _firstParticipantPreviousEmotion;
        String secondParticipantEmotion = _secondParticipantPreviousEmotion;
        String? currentSpeakerEmotion = currentPhrase?.emotion;

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
            secondParticipantDossier = null;
          }
          _speakerId = currentBranch.phrases.first.speakerId;
        }

        bool isFirstDimmed = false;
        bool isSecondDimmed = false;
        if (_speakerId != 'NARRATOR' && _speakerId.isNotEmpty) {
          final speakerName = state.gameState.dossiers
              .firstWhere(
                (element) => element.name == _speakerId,
              )
              .name;

          isFirstDimmed = firstParticipantDossier?.name != speakerName;
          isSecondDimmed = secondParticipantDossier?.name != speakerName;

          // Determine emotions for each participant
          if (firstParticipantDossier != null) {
            firstParticipantEmotion = isFirstDimmed
                ? _firstParticipantPreviousEmotion
                : currentSpeakerEmotion ??
                    'neutral'; // Default to 'neutral' if no emotion
            if (!isFirstDimmed) {
              _firstParticipantPreviousEmotion =
                  currentSpeakerEmotion ?? 'neutral';
            }
          }

          if (secondParticipantDossier != null) {
            secondParticipantEmotion = isSecondDimmed
                ? _secondParticipantPreviousEmotion
                : currentSpeakerEmotion ??
                    'neutral'; // Default to 'neutral' if no emotion

            if (!isSecondDimmed) {
              _secondParticipantPreviousEmotion =
                  currentSpeakerEmotion ?? 'neutral';
            }
          }
        } else {
          // If no speaker or narrator, set neutral emotions
          firstParticipantEmotion = 'neutral';
          secondParticipantEmotion = 'neutral';
          isFirstDimmed = false;
          isSecondDimmed = false;
        }

        final firstParticipantEmotionPath =
            'assets/images/${firstParticipantDossier?.name ?? ''} $firstParticipantEmotion.webp';
        final secondParticipantEmotionPath =
            'assets/images/${secondParticipantDossier?.name ?? ''} $secondParticipantEmotion.webp';

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
                    emotion: firstParticipantEmotionPath,
                  ),
                ),
              if (firstParticipantDossier != null && _speakerId != 'NARRATOR')
                Positioned(
                  left: 20, // 🔸 слева
                  bottom: 20,
                  child: CharacterAvatar(
                    character: firstParticipantDossier!,
                    isDimmed: isFirstDimmed,
                    emotion: firstParticipantEmotionPath,
                  ),
                ),
              if (secondParticipantDossier != null && _speakerId != 'NARRATOR')
                Positioned(
                  left: 190, // 🔸 тоже слева, чуть правее первого
                  bottom: 20,
                  child: CharacterAvatar(
                    character: secondParticipantDossier!,
                    isDimmed: isSecondDimmed,
                    emotion: secondParticipantEmotionPath,
                  ),
                ),

//  ⬇️  вместо двух Align‑ов (для фразы и для вариантов)
//      оставляем один, всегда показывающий DialogueBox
              Align(
                alignment: Alignment.centerRight, // 🔸 фиксируем справа
                child: DialogueBox(
                  phrase: currentPhrase,
                  choices: currentBranch.choices,
                  onTap: (DialogueChoice choice) {
                    context.read<DialogueBloc>().add(OptionChosenEvent(choice));
                    _currentPhraseIndex = 0;
                    _speakerId = '';
                  },
                  onDialogueTap: () => _nextPhrase(
                    currentBranch.phrases,
                    currentBranch.choices,
                    participants,
                    state.gameState.dossiers,
                  ),
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
  final DialoguePhrase? phrase; // теперь допускает null
  final List<DialogueChoice> choices; // добавили
  final VoidCallback onDialogueTap;
  final Function(DialogueChoice) onTap;
  const DialogueBox({
    required this.phrase,
    required this.choices,
    required this.onDialogueTap,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> {
  int _visibleTextLength = 0;
  bool _isTextFullyVisible = false;

  @override
  void initState() {
    super.initState();
    _visibleTextLength = 0;
    _isTextFullyVisible = false;
    _startTextAnimation();
  }

  void _startTextAnimation() {
    if (_isTextFullyVisible) return;
    if (widget.phrase == null) return;

    Future.delayed(const Duration(milliseconds: 50), () {
      if (_visibleTextLength < widget.phrase!.text.length &&
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
    if (widget.phrase == null) return;
    setState(() {
      _visibleTextLength = widget.phrase!.text.length;
      _isTextFullyVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      // 👉 занимает всю высоту
      width: screenWidth * 0.30, // 👉 30 % ширины
      height: screenHeight,
      child: GestureDetector(
        onTap: () {
          if (!_isTextFullyVisible && widget.phrase != null) {
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
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/dialog.webp"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- 1. Текст фразы ----------
              if (widget.phrase != null) ...[
                Text(
                  widget.phrase!.speakerId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.phrase!.text.substring(0, _visibleTextLength),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Spacer(), // 👉 кнопки будут «прилипать» к низу
              ],

              // ---------- 2. Кнопки выбора ----------
              if (widget.phrase == null && widget.choices.isNotEmpty)
                ...widget.choices.map(
                  (choice) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onTap(choice);
                        _visibleTextLength = 0;
                        _isTextFullyVisible = false;
                        _startTextAnimation();
                      },
                      child: Text(choice.choiceText),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
