import 'dart:ui';

import 'package:advertising_id/advertising_id.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_eye_of_the_world/src/core/utils/app_icon.dart';
import 'package:the_eye_of_the_world/src/core/utils/size_utils.dart';

import '../../../../../routes/route_value.dart';
import '../../../../core/utils/icon_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startLoading(context);
  }

  Future<void> startLoading(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    await AdvertisingId.id(true);

    context.go(RouteValue.home.path);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
            child: AppIcon(
              asset: IconProvider.splash.buildImageUrl(),
              height: getHeight(context, percent: 1),
              width: getWidth(context, percent: 1),
              fit: BoxFit.fill,
            ),
          ),
        ),
        SafeArea(
          child: AppIcon(
            asset: IconProvider.logo.buildImageUrl(),
            width: 300,
            height: 301,
          ),
        ),
        Positioned(
          bottom: getHeight(context, baseSize: 21),
          child: SafeArea(
            child: SizedBox(
              width: 381,
              child: LinearProgressIndicator(
                backgroundColor: Color(0x45FFFFFF),
                color: Color(0xFFA3F1FF),
                minHeight: 4,
              ),
            ),
          ),
        )
      ],
    );
  }
}
