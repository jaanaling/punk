import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:the_eye_of_the_world/src/core/utils/animated_button.dart';
import 'package:the_eye_of_the_world/src/core/utils/app_icon.dart';
import 'package:the_eye_of_the_world/src/core/utils/icon_provider.dart';
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

              if (firstParticipantDossier != null && _speakerId != 'NARRATOR')
                Positioned(
                  left: 70, // 🔸 слева
                  bottom: 0,
                  child: AnimatedCharacter(
                    character: firstParticipantDossier!,
                    isDimmed: isFirstDimmed,
                    emotion: firstParticipantEmotionPath,
                  ),
                ),
              if (secondParticipantDossier != null && _speakerId != 'NARRATOR')
                Positioned(
                  left: 350, // 🔸 тоже слева, чуть правее первого
                  bottom: 0,
                  child: AnimatedCharacter(
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
                  textaudio: currentPhrase?.speakerId != null
                      ? isSecondDimmed
                          ? "${currentPhrase!.speakerId} ${currentSpeakerEmotion}"
                          : "${currentPhrase!.speakerId} ${currentSpeakerEmotion}"
                      : null,
                  state: state,
                  mood: currentBranch.heroMentalState,
                  onTap: (DialogueChoice choice) {
                    context.read<DialogueBloc>().add(OptionChosenEvent(choice));
                    _currentPhraseIndex = 0;
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

void _buildDossierDialog(DialogueState state, BuildContext context) {
  int currentIndex = 0;

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedButton(
                    onPressed: () {
                      if (currentIndex > 0) {
                        setState(() {
                          currentIndex--;
                        });
                      }
                    },
                    child: AppIcon(
                      asset: "assets/images/back.webp",
                      width: 64,
                    ),
                  ),
                  Gap(10),
                  Container(
                    width: getWidth(context, percent: 0.65),
                    height: getHeight(context, percent: 0.55),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/dossier_panel.webp'),
                            fit: BoxFit.fill)),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/${state.gameState.dossiers[currentIndex].name} dossier.webp',
                          height: getHeight(context, percent: 0.5),
                          fit: BoxFit.contain,
                        ),
                        Gap(10),
                        SingleChildScrollView(
                          child: SizedBox(
                            width: getWidth(context, percent: 0.4),
                            child: Column(
                              children: [
                                Text(
                                  state.gameState.dossiers[currentIndex].name,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 122, 210, 241),
                                      fontSize: 14,
                                      fontFamily: "Orbitron"),
                                ),
                                Text(
                                  state.gameState.dossiers[currentIndex]
                                      .background,
                                  style: const TextStyle(
                                      color: Color(0xFFB3EBFF),
                                      fontSize: 12,
                                      fontFamily: "Orbitron"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(10),
                  AnimatedButton(
                    onPressed: () {
                      if (currentIndex < state.gameState.dossiers.length - 1) {
                        setState(() {
                          currentIndex++;
                        });
                      }
                    },
                    child: Transform.rotate(
                      angle: 3.14,
                      child: AppIcon(
                        asset: "assets/images/back.webp",
                        width: 64,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: () {
                  context.pop();
                },
                child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0x00000075),
                        border: Border.all(
                          color: const Color(0xFFFFFF00),
                          width: 2.0,
                        )),
                    child: Text(
                      "Close",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFFB2FF00),
                          fontSize: 16,
                          fontFamily: "Jersey25"),
                    )),
              ),
            ],
          ),
        ),
      );
    },
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

class AnimatedCharacter extends StatefulWidget {
  final CharacterDossier character;
  final bool isDimmed;
  final String? emotion;

  const AnimatedCharacter({
    super.key,
    required this.character,
    required this.isDimmed,
    required this.emotion,
  });

  @override
  State<AnimatedCharacter> createState() => _AnimatedCharacterState();
}

class _AnimatedCharacterState extends State<AnimatedCharacter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Плавные кривые для естественного движения
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuint,
      reverseCurve: Curves.easeInCirc,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation);
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(curvedAnimation);

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Если изменился персонаж или эмоция - запускаем анимацию снова
    if (oldWidget.character != widget.character || oldWidget.emotion != widget.emotion) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            alignment: Alignment.bottomCenter,
            scale: widget.isDimmed ?
            lerpDouble(1.0, 0.9, _controller.value)! :
            lerpDouble(1.3, 1.5, _controller.value)!,
            child: Opacity(
              opacity: widget.isDimmed ?
              lerpDouble(0.5, 0.8, _controller.value)! :
              _opacityAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: _buildCharacterImage(),
    );
  }

  Widget _buildCharacterImage() {
    return Image.asset(
      widget.emotion ?? 'assets/images/${widget.character.name} neutral.webp',
      height: getHeight(context, percent: 0.7),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/${widget.character.name} neutral.webp',
        height: getHeight(context, percent: 0.7),
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
  final DialogueState state;
  final String? textaudio;
  final String mood;
  const DialogueBox({
    required this.phrase,
    required this.choices,
    required this.onDialogueTap,
    required this.textaudio,
    required this.state,
    required this.onTap,
    required this.mood,
    Key? key,
  }) : super(key: key);

  @override
  State<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> {
  final ScrollController _scrollController = ScrollController(); // 👈 ①
  double _scrollProgress = 0; // 👈 ②
  bool isPlay = false;
  int _visibleTextLength = 0;
  final AudioPlayer _narratorAudioPlayer = AudioPlayer();
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isTextFullyVisible = false;
  bool _isNarratorSpeaking = false;

  @override
  void initState() {
    super.initState();
    _startTextAnimation();

    _scrollController.addListener(_handleScroll); // 👈 ③
  }

  Future<void> audiotext() async {
    if (widget.textaudio != null && _visibleTextLength == 0) {
      await _audioPlayer.play(AssetSource('audio/${widget.textaudio}.mp3'));
      isPlay = true;
    }
  }

  void _handleScroll() {
    // позиция может быть 0, пока виджет ещё не отрисовался
    if (!_scrollController.hasClients ||
        !_scrollController.position.hasContentDimensions) return;

    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    setState(() {
      _scrollProgress = max == 0 ? 0 : (offset / max).clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _stopNarratorAudio();
    _narratorAudioPlayer.dispose();
    super.dispose();
  }

  void _startTextAnimation() {
    if (_isTextFullyVisible) return;
    if (widget.phrase == null) return;

    Future.delayed(const Duration(milliseconds: 50), () {
      if (widget.phrase != null &&
          _visibleTextLength < widget.phrase!.text.length &&
          !_isTextFullyVisible) {
        setState(() {
          _visibleTextLength++;
        });
        _startTextAnimation();
      } else {
        setState(() {
          _isTextFullyVisible = true;
          if (widget.phrase?.speakerId == 'NARRATOR') {
            _stopNarratorAudio();
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant DialogueBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.phrase != oldWidget.phrase) {
      // 1. Сбрасываем счётчик символов
      _visibleTextLength = 0;
      _isTextFullyVisible = false;

      // 2. Запускаем печать текста
      _startTextAnimation();

      // 3. Управляем звуком так, как было раньше
      if (widget.phrase?.speakerId == 'NARRATOR') {
        _startNarratorAudio();
      } else {
        _stopNarratorAudio();
      }
    }
  }

  void _startNarratorAudio() async {
    if (_isNarratorSpeaking) return;

    try {
      _isNarratorSpeaking = true;
      await _narratorAudioPlayer.setReleaseMode(ReleaseMode.loop);
      await _narratorAudioPlayer.setVolume(0.2);
      await _narratorAudioPlayer.play(AssetSource('audio/narrator.mp3'));
    } catch (e) {
      print('Error playing narrator audio: $e');
      _isNarratorSpeaking = false;
    }
  }

  void _stopNarratorAudio() async {
    if (!_isNarratorSpeaking) return;

    try {
      await _narratorAudioPlayer.stop();
      _isNarratorSpeaking = false;
    } catch (e) {
      print('Error stopping narrator audio: $e');
    }
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

    Color textColor = Colors.white;
    if (widget.phrase != null) {
      lastmood = widget.mood;
      switch (widget.phrase!.speakerId) {
        case 'VAIR':
          textColor = Colors.green;
          audiotext();
          break;
        case 'ERRAS':
          textColor = Colors.purple;
          audiotext();
          break;
        case 'LYRA':
          textColor = Colors.blue;
          audiotext();
          break;
        case 'NIKA':
          textColor = Colors.orange;
          audiotext();
          break;
        case 'RION':
          textColor = Colors.red;
          audiotext();
          break;
        case 'NARRATOR':
          textColor = Colors.grey.shade300;
          _startNarratorAudio();
          break;
        default:
          textColor = Colors.white;
      }
    }

    return PopScope(
      onPopInvoked: (_) => _stopNarratorAudio(),
      child: SizedBox(
        // 👉 занимает всю высоту
        width: screenWidth * 0.35, // 👉 30 % ширины
        height: screenHeight,
        child: GestureDetector(
          onTap: () {
            if (!_isTextFullyVisible && widget.phrase != null) {
              _showFullText();
              _stopNarratorAudio();
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
                if (widget.phrase != null)
                  SizedBox(
                    height: screenHeight * 0.5,
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.phrase != null) ...[
                              Text(
                                widget.phrase!.speakerId,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  fontFamily: "Jersey25",
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.phrase!.text
                                    .substring(0, _visibleTextLength),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "Orbitron"),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                // ---------- 2. Кнопки выбора ----------
                if (widget.phrase == null && widget.choices.isNotEmpty)
                  ...widget.choices.map(
                    (choice) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AnimatedButton(
                        onPressed: () {
                          widget.onTap(choice);
                          _visibleTextLength = 0;
                          _isTextFullyVisible = false;
                          _startTextAnimation();
                        },
                        child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: const Color(0x00000075),
                                border: Border.all(
                                  color: const Color(0xFFFFFF00),
                                  width: 2.0,
                                )),
                            child: Text(
                              choice.choiceText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: [
                                    Color(0xFFB2FF00),
                                    Color(0xFFFFBB00),
                                    Color(0xFFFF4D00),
                                  ][Random().nextInt(3)],
                                  fontSize: 16,
                                  fontFamily: "Jersey25"),
                            )),
                      ),
                    ),
                  ),

                Spacer(),
                Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0x00000075),
                        border: Border.all(
                          color: const Color(0xFFFFFF00),
                          width: 2.0,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            AppIcon(
                                asset: "assets/images/$lastmood.webp",
                                width: 110),
                            Text(
                              lastmood,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Jersey25"),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            AnimatedButton(
                                onPressed: () =>
                                    _buildDossierDialog(widget.state, context),
                                child: AppIcon(
                                  asset: "assets/images/dossier.webp",
                                  width: 64,
                                  height: 70,
                                )),
                            AnimatedButton(
                                onPressed: () => context.pop(),
                                child: AppIcon(
                                  asset: "assets/images/MENU.webp",
                                  width: 91,
                                )),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String lastmood = "";
