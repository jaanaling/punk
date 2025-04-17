import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_eye_of_the_world/routes/route_value.dart';
import 'package:the_eye_of_the_world/src/core/utils/animated_button.dart';
import 'package:the_eye_of_the_world/src/core/utils/size_utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:the_eye_of_the_world/src/feature/main/bloc/app_bloc.dart';

import '../../../core/utils/app_icon.dart';
import '../../../core/utils/icon_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isMusicPlaying = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // _startMusic();
  }

  Future<void> _startMusic() async {
    await _audioPlayer.play(AssetSource('audio/music.mp3'));
    setState(() {
      _isMusicPlaying = true;
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
    });
  }

  Future<void> _toggleMusic() async {
    if (_isMusicPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      _isMusicPlaying = !_isMusicPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AppIcon(
            asset: IconProvider.splash.buildImageUrl(),
            height: getHeight(context, percent: 1),
            width: getWidth(context, percent: 1),
            fit: BoxFit.fill,
          ),
        ),
        Row(
          children: [
            Spacer(),
            AppIcon(asset: IconProvider.logo.buildImageUrl()),
            Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                AppIcon(
                  asset: 'assets/images/menu panel.webp',
                  height: getHeight(context, percent: 1),
                  fit: BoxFit.fitHeight,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      context,
                      'assets/images/NEW GAME.webp',
                      () {
                        context.read<DialogueBloc>().add(StartNewGameEvent());
                        
                      context.push(
                          '${RouteValue.home.path}/${RouteValue.game.path}');
                    },
                    ),
                    _buildButton(
                      context,
                      'assets/images/CONTINUE.webp',
                      () => context.push(
                        '${RouteValue.home.path}/${RouteValue.game.path}',
                      ),
                    ),
                    _buildButton(
                      context,
                      'assets/images/CHAPTERS.webp',
                      () => context.push(
                        '${RouteValue.home.path}/${RouteValue.chapters.path}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 25,
          left: 18,
          child: AnimatedButton(
            isMenu: true,
            onPressed: _toggleMusic,
            child: Image.asset(
              _isMusicPlaying
                  ? 'assets/images/sound_on.png'
                  : 'assets/images/sound_off.png',
              height: getHeight(context, baseSize: 150),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String imagePath,
    VoidCallback onTap,
  ) {
    return AnimatedButton(
      onPressed: onTap,
      isMenu: true,
      child: Image.asset(
        imagePath,
        fit: BoxFit.fitWidth,
        width: 276,
      ),
    );
  }
}
