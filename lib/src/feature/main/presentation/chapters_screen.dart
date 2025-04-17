import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_eye_of_the_world/src/core/utils/animated_button.dart';
import 'package:the_eye_of_the_world/src/core/utils/size_utils.dart';

import '../../../core/utils/app_icon.dart';
import '../../../core/utils/icon_provider.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Stack(
            children: [
              AppIcon(
                asset: IconProvider.splash.buildImageUrl(),
                height: getHeight(context, percent: 1),
                width: getWidth(context, percent: 1),
                fit: BoxFit.fill,
              ),
              Container(
                color: Colors.black
                    .withOpacity(0.3), // Регулируйте прозрачность (0.3 = 30%)
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2.0, // Сила размытия по X
                  sigmaY: 2.0, // Сила размытия по Y
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
        Positioned(
          top: 18,
          left: 18,
          child: AnimatedButton(
            isMenu: true,
            onPressed: (){
              context.pop();
            },
            child: Image.asset(
              IconProvider.back.buildImageUrl(),
              height: getHeight(context, baseSize: 150),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChapterImage(
      BuildContext context, String imagePath, int chapter) {
    return AnimatedButton(
      isMenu: true,
      onPressed: () {},
      child: AppIcon(asset: imagePath,
        width: getWidth(context, percent: 0.25),
        fit: BoxFit.fitWidth,),
    );
  }
}
