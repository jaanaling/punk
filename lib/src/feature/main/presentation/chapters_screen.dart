import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/CHAPTERS.webp',
              fit: BoxFit.cover,
            ),
          ),
          GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              _buildChapterImage(
                context,
                'assets/images/CHAPTER 1.webp',
                1,
              ),
              _buildChapterImage(
                context,
                'assets/images/CHAPTER 2.webp',
                2,
              ),
              _buildChapterImage(
                context,
                'assets/images/CHAPTER 3.webp',
                3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChapterImage(BuildContext context, String imagePath, int chapter) {
    return GestureDetector(
     
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}