import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_eye_of_the_world/src/core/utils/size_utils.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu panel.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: getHeight(context, percent: 0.5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/MENU.webp',
                  height: getHeight(context, percent:1),
                ),
                Image.asset(
                  'assets/images/logo.webp',
                  height: getHeight(context, percent: 0.2),
                ),
              ],
            ),
            //  Add other widgets here as needed
          ],
        ),
      ),
    );
  }
}
