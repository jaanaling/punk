import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  final String asset;
  final Color? color;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BlendMode? blendMode;

  const AppIcon( {
    super.key,
    required this.asset,
    this.color,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.blendMode,
  });

  @override
  Widget build(BuildContext context) {


    return asset.contains('.svg')
        ? Opacity(
            opacity: 0.97,
            child: SvgPicture.asset(
              asset,
              width: width,
              height: height,
              fit: fit,
              allowDrawingOutsideViewBox: true,
              colorFilter: color != null
                  ? ColorFilter.mode(
                      color!,
                      blendMode ?? BlendMode.srcIn,
                    )
                  : null,
            ),
          )
        : asset.contains("images")
            ? Image.asset(
                asset,
                width: width,
                height: height,
                fit: fit,
                color: color,
                colorBlendMode: color != null ? blendMode?? BlendMode.srcIn : null,
              )
            : Image.file(
                File(asset),
                width: width,
                height: height,
                fit: fit,
              );
  }
}
