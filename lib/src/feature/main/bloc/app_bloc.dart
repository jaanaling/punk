import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Импорт ваших новых моделей
import 'package:the_eye_of_the_world/src/feature/main/model/model.dart';

// ----------------- Dialogue Events ----------------- //

abstract class DialogueEvent extends Equatable {
  const DialogueEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузка игры из локального хранилища
class LoadGameEvent extends DialogueEvent {}

/// Выбор варианта ответа в диалоге
class OptionChosenEvent extends DialogueEvent {
  final DialogueChoice choice;
  const OptionChosenEvent(this.choice);

  @override
  List<Object?> get props => [choice];
}

/// Пометить, что игрок встретил определённого персонажа
class MarkEncounterEvent extends DialogueEvent {
  final String characterId;
  const MarkEncounterEvent(this.characterId);

  @override
  List<Object?> get props => [characterId];
}

/// Начать новую игру
class StartNewGameEvent extends DialogueEvent {}

/// Обработка начала новой игры

// ----------------- Dialogue State ----------------- //

class DialogueState extends Equatable {
  /// Текущее состояние игры (GameState)
  final GameState gameState;

  /// Текущая ветка диалога (заменяем currentNode -> currentBranch)
  final DialogueBranch? currentBranch;

  /// Идёт ли сейчас загрузка
  final bool isLoading;

  /// Произошла ли ошибка
  final bool hasError;

  const DialogueState({
    required this.gameState,
    required this.currentBranch,
    this.isLoading = false,
    this.hasError = false,
  });

  DialogueState copyWith({
    GameState? gameState,
    DialogueBranch? currentBranch,
    bool? isLoading,
    bool? hasError,
  }) {
    return DialogueState(
      gameState: gameState ?? this.gameState,
      currentBranch: currentBranch ?? this.currentBranch,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }

  @override
  List<Object?> get props => [gameState, currentBranch, isLoading, hasError];
}

// ----------------- Dialogue Bloc ----------------- //

class DialogueBloc extends Bloc<DialogueEvent, DialogueState> {
  final DialogueManager dialogueManager;

  DialogueBloc({
    required this.dialogueManager,
  }) : super(
          DialogueState(
            gameState: dialogueManager.gameState,
            currentBranch: dialogueManager.currentBranch,
            isLoading: false,
            hasError: false,
          ),
        ) {
    on<LoadGameEvent>(_onLoadGame);
    on<StartNewGameEvent>(_onStartNewGame);

    on<OptionChosenEvent>(_onOptionChosen);
    on<MarkEncounterEvent>(_onMarkEncounter);
  }

  Future<void> _onStartNewGame(
    StartNewGameEvent event,
    Emitter<DialogueState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('gameState');
      await dialogueManager.loadGame(prefs);

      dialogueManager.gameState = GameState(
          currentDialogueBranchId: "branch_1",
          encounteredCharacters: {},
          dossiers: dialogueManager.gameState.dossiers);

      emit(
        state.copyWith(
          gameState: dialogueManager.gameState,
          currentBranch: dialogueManager.currentBranch,
          isLoading: false,
          hasError: false,
        ),
      );
    } catch (e) {
      debugPrint('Ошибка при начале новой игры: $e');
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  /// Обработка загрузки игры
  Future<void> _onLoadGame(
    LoadGameEvent event,
    Emitter<DialogueState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final prefs = await SharedPreferences.getInstance();
      await dialogueManager.loadGame(prefs);

      if (dialogueManager.currentBranch == null) {
        dialogueManager.makeChoice(
            DialogueChoice(choiceText: "", nextDialogueBranchId: "branch_1"));
      }

      emit(
        state.copyWith(
          gameState: dialogueManager.gameState,
          currentBranch: dialogueManager.currentBranch,
          isLoading: false,
          hasError: false,
        ),
      );
    } catch (e) {
      debugPrint('Ошибка при загрузке игры: $e');
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  /// Обработка выбора варианта диалога
  Future<void> _onOptionChosen(
    OptionChosenEvent event,
    Emitter<DialogueState> emit,
  ) async {
    // Заменяем old: chooseOption -> new: makeChoice
    dialogueManager.makeChoice(event.choice);

    final prefs = await SharedPreferences.getInstance();
    await dialogueManager.saveGame(prefs);

    emit(
      state.copyWith(
        gameState: dialogueManager.gameState,
        currentBranch: dialogueManager.currentBranch,
        hasError: false,
      ),
    );
  }

  /// Пометка встречи с новым персонажем
  void _onMarkEncounter(
    MarkEncounterEvent event,
    Emitter<DialogueState> emit,
  ) {
    dialogueManager.markEncounter(event.characterId);

    emit(
      state.copyWith(
        gameState: dialogueManager.gameState,
        currentBranch: dialogueManager.currentBranch,
        hasError: false,
      ),
    );
  }
}
