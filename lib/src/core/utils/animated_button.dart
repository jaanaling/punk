import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const AnimatedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0; // Начальный масштаб

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _scale = 0.9; // Уменьшение кнопки
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _scale = 1.0; // Возврат к исходному размеру
      });
      widget.onPressed!(); // Вызов обработчика нажатия
    }
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0; // Возврат к исходному размеру при отмене нажатия
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
