import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_eye_of_the_world/routes/route_value.dart';
import 'package:the_eye_of_the_world/src/core/utils/size_utils.dart';
import 'package:audioplayers/audioplayers.dart';

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
    _startMusic();
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/menu panel.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: getHeight(context, percent: 0.05),
            right: getWidth(context, percent: 0.05),
            child: GestureDetector(
              onTap: _toggleMusic,
              child: Image.asset(
                _isMusicPlaying
                    ? 'assets/images/sound_on.png'
                    : 'assets/images/sound_off.png',
                height: getHeight(context, percent: 0.05),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                    context,
                    'assets/images/NEW GAME.webp',
                    () => context.push(
                        RouteValue.home.path + "/" + RouteValue.game.path)),
                SizedBox(height: getHeight(context, percent: 0.03)),
                _buildButton(
                    context,
                    'assets/images/CONTINUE.webp',
                    () => context.push(RouteValue.home.path +
                        "/" +
                        RouteValue.game.path)), // Заглушка
                SizedBox(height: getHeight(context, percent: 0.03)),
                _buildButton(
                    context,
                    'assets/images/CHAPTERS.webp',
                    () => context.push(
                        RouteValue.home.path + "/" + RouteValue.chapters.path)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(imagePath, height: getHeight(context, percent: 0.1)),
    );
  }
}
