import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../src/core/utils/icon_provider.dart';

class RootNavigationScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RootNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<RootNavigationScreen> createState() => _RootNavigationScreenState();
}

class _RootNavigationScreenState extends State<RootNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: widget.navigationShell,
    );
  }
}
