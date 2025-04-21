import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:the_eye_of_the_world/src/feature/main/presentation/main_screen.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isMenu;

  const AnimatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isMenu = false,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;
  double _opacity = 1.0; // Начальный масштаб

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _scale = 0.9;
        _opacity = 0.5; // Уменьшение кнопки
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _scale = 1.0;
        _opacity = 1.0; // Возврат к исходному размеру
      });
      widget.onPressed!(); // Вызов обработчика нажатия
    }
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
      _opacity = 1.0; // Возврат к исходному размеру при отмене нажатия
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () async {
        if (isMusicPlaying) {
          final AudioPlayer _audioPlayer = AudioPlayer();
          if (widget.isMenu) {
            _audioPlayer.setVolume(0.3);
          }
          await _audioPlayer.play(AssetSource(
              widget.isMenu ? 'audio/button.mp3' : 'audio/button_main.mp3'));
        }
      },
      child: Opacity(
        opacity: _opacity,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutQuad,
          child: widget.child,
        ),
      ),
    );
  }
}
