import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:the_eye_of_the_world/src/core/utils/animated_button.dart';
import 'package:the_eye_of_the_world/src/core/utils/size_utils.dart';

import '../../../../routes/route_value.dart';
import '../../../core/utils/app_icon.dart';
import '../../../core/utils/icon_provider.dart';

class ChaptersScreen extends StatelessWidget {
  ChaptersScreen({super.key});

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
            onPressed: () {
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
      onPressed: () {
        _buildChapterDialog(context, chapter);
      },
      child: AppIcon(
        asset: imagePath,
        width: getWidth(context, percent: 0.25),
        fit: BoxFit.fitWidth,
      ),
    );
  }

  void _buildChapterDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: getWidth(context, percent: 0.45),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AppIcon(
                          asset: 'assets/images/dossier_panel.webp',
                          width: getWidth(context, percent: 0.45),
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          width: getWidth(context, percent: 0.4),
                          child: SingleChildScrollView(
                            child: Text(
                              chapterText[index - 1],
                              style: TextStyle(
                                  color: Color(0xFFB3EBFF),
                                  fontSize: index > 1 ? 32 : 12,
                                  fontFamily: "Orbitron"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(15),
                  if (index == 1)
                    _buildButton(
                      context,
                      'assets/images/NEW GAME.webp',
                      () => context.push(
                        '${RouteValue.home.path}/${RouteValue.game.path}',
                      ),
                    ),
                ],
              )),
        );
      },
    );
  }

  List<String> chapterText = [
    '''The city of Noxis is the last remaining bastion of humanity, subject to the totalitarian rule of LEXIS, a synthetic law decreed by the authorities in the aftermath of the Last Revolution.
 Justice in Noxis is executed by arbiters, police-judges who have the power to pass judgement on the spot. They have no emotions; they are governed by the law and the Sphere.
Recruitment drones meticulously comb the streets. Cameras are in the eyes of random passers-by. Psychological testing is mandatory every week. Curfews at night.''',
    'COMING SOON!',
    'COMING SOON!'
  ];

  Widget _buildButton(
    BuildContext context,
    String imagePath,
    VoidCallback onTap,
  ) {
    return AnimatedButton(
      onPressed: (){
        context.pop();
        onTap();
      },
      isMenu: true,
      child: Image.asset(
        imagePath,
        fit: BoxFit.fitWidth,
        width: 276,
      ),
    );
  }
}
