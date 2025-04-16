import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:the_eye_of_the_world/src/feature/main/bloc/app_bloc.dart';
import 'package:the_eye_of_the_world/src/feature/main/model/model.dart';

import '../../../../routes/go_router_config.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DialogueBloc(
        dialogueManager: DialogueManager(
          dialogueBranches: [],
          gameState: GameState(
            currentDialogueBranchId: '',
            encounteredCharacters: {},
            dossiers: [],
          ),
        ),
      )..add(LoadGameEvent()),
      child: CupertinoApp.router(
        theme: const CupertinoThemeData(
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: buildGoRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
