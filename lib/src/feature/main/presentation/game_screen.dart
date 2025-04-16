import 'package:flutter/material.dart';
import 'package:the_eye_of_the_world/src/core/utils/size_utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String _selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/normal.webp', // Replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Text Options (Example)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                _buildTextOptionButton('Option 1'),
                SizedBox(height: 10),
                _buildTextOptionButton('Option 2'),
                SizedBox(height: 10),
                _buildTextOptionButton('Option 3'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextOptionButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedOption = text;
          // You can add navigation or other actions here based on the selected option
        });
        print('Selected option: $text');
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }
}