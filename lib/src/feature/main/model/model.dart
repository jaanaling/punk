// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:the_eye_of_the_world/src/core/utils/json_loader.dart';

class DialoguePhrase {
  final String speakerId; // Кто говорит (ID персонажа)
  final String text; // Текст фразы
  final String emotion; // Эмоция говорящего (3 состояния)
  DialoguePhrase({
    required this.speakerId,
    required this.text,
    required this.emotion,
  });

  DialoguePhrase copyWith({
    String? speakerId,
    String? text,
    String? emotion,
  }) {
    return DialoguePhrase(
      speakerId: speakerId ?? this.speakerId,
      text: text ?? this.text,
      emotion: emotion ?? this.emotion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'speakerId': speakerId,
      'text': text,
      'emotion': emotion,
    };
  }

  factory DialoguePhrase.fromMap(Map<String, dynamic> map) {
    return DialoguePhrase(
      speakerId: map['speakerId'] as String,
      text: map['text'] as String,
      emotion: map['emotion'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DialoguePhrase.fromJson(String source) =>
      DialoguePhrase.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DialoguePhrase(speakerId: $speakerId, text: $text, emotion: $emotion)';

  @override
  bool operator ==(covariant DialoguePhrase other) {
    if (identical(this, other)) return true;

    return other.speakerId == speakerId &&
        other.text == text &&
        other.emotion == emotion;
  }

  @override
  int get hashCode => speakerId.hashCode ^ text.hashCode ^ emotion.hashCode;
}

/// Вариант выбора в конце диалога
class DialogueChoice {
  final String choiceText; // Текст выбора
  final String nextDialogueBranchId;
  DialogueChoice({
    required this.choiceText,
    required this.nextDialogueBranchId,
  });

  DialogueChoice copyWith({
    String? choiceText,
    String? nextDialogueBranchId,
  }) {
    return DialogueChoice(
      choiceText: choiceText ?? this.choiceText,
      nextDialogueBranchId: nextDialogueBranchId ?? this.nextDialogueBranchId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'choiceText': choiceText,
      'nextDialogueBranchId': nextDialogueBranchId,
    };
  }

  factory DialogueChoice.fromMap(Map<String, dynamic> map) {
    return DialogueChoice(
      choiceText: map['choiceText'] as String,
      nextDialogueBranchId: map['nextDialogueBranchId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DialogueChoice.fromJson(String source) =>
      DialogueChoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DialogueChoice(choiceText: $choiceText, nextDialogueBranchId: $nextDialogueBranchId)';

  @override
  bool operator ==(covariant DialogueChoice other) {
    if (identical(this, other)) return true;

    return other.choiceText == choiceText &&
        other.nextDialogueBranchId == nextDialogueBranchId;
  }

  @override
  int get hashCode => choiceText.hashCode ^ nextDialogueBranchId.hashCode;
}

/// Диалоговая ветка (серия реплик + выборы в конце)
class DialogueBranch {
  final String branchId; // Уникальный ID ветки
  final String location; // Текущая локация
  final List<String> participantsIds; // Участники диалога (персонажи)
  final List<DialoguePhrase> phrases; // Реплики в порядке отображения
  final List<DialogueChoice> choices; // Варианты выбора в конце ветки
  final String heroMentalState; // Состояние главного героя
  DialogueBranch({
    required this.branchId,
    required this.location,
    required this.participantsIds,
    required this.phrases,
    required this.choices,
    required this.heroMentalState,
  });

  DialogueBranch copyWith({
    String? branchId,
    String? location,
    List<String>? participantsIds,
    List<DialoguePhrase>? phrases,
    List<DialogueChoice>? choices,
    String? heroMentalState,
  }) {
    return DialogueBranch(
      branchId: branchId ?? this.branchId,
      location: location ?? this.location,
      participantsIds: participantsIds ?? this.participantsIds,
      phrases: phrases ?? this.phrases,
      choices: choices ?? this.choices,
      heroMentalState: heroMentalState ?? this.heroMentalState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'branchId': branchId,
      'location': location,
      'participantsIds': participantsIds,
      'phrases': phrases.map((x) => x.toMap()).toList(),
      'choices': choices.map((x) => x.toMap()).toList(),
      'heroMentalState': heroMentalState,
    };
  }

  factory DialogueBranch.fromMap(Map<String, dynamic> map) {
    return DialogueBranch(
      branchId: map['branchId'] as String,
      location: map['location'] as String,
      participantsIds:
          List<String>.from(map['participantsIds'] as List<dynamic>),
      phrases: List<DialoguePhrase>.from(
        (map['phrases'] as List<dynamic>).map<DialoguePhrase>(
          (x) => DialoguePhrase.fromMap(x as Map<String, dynamic>),
        ),
      ),
      choices: List<DialogueChoice>.from(
        (map['choices'] as List<dynamic>).map<DialogueChoice>(
          (x) => DialogueChoice.fromMap(x as Map<String, dynamic>),
        ),
      ),
      heroMentalState: map['heroMentalState'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DialogueBranch.fromJson(String source) =>
      DialogueBranch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DialogueBranch(branchId: $branchId, location: $location, participantsIds: $participantsIds, phrases: $phrases, choices: $choices, heroMentalState: $heroMentalState)';
  }

  @override
  bool operator ==(covariant DialogueBranch other) {
    if (identical(this, other)) return true;

    return other.branchId == branchId &&
        other.location == location &&
        listEquals(other.participantsIds, participantsIds) &&
        listEquals(other.phrases, phrases) &&
        listEquals(other.choices, choices) &&
        other.heroMentalState == heroMentalState;
  }

  @override
  int get hashCode {
    return branchId.hashCode ^
        location.hashCode ^
        participantsIds.hashCode ^
        phrases.hashCode ^
        choices.hashCode ^
        heroMentalState.hashCode;
  }
}

/// Обновлённое состояние игры (для хранения текущей ветки)
class GameState {
  String currentDialogueBranchId; // Текущая диалоговая ветка
  Set<String> encounteredCharacters; // Встретившиеся персонажи
  List<CharacterDossier> dossiers; // Досье персонажей

  GameState({
    required this.currentDialogueBranchId,
    required this.encounteredCharacters,
    required this.dossiers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentDialogueBranchId': currentDialogueBranchId,
      'encounteredCharacters': encounteredCharacters.toList(),
      'dossiers': dossiers.map((x) => x.toMap()).toList(),
    };
  }

  factory GameState.fromMap(Map<String, dynamic> map) {
    return GameState(
      currentDialogueBranchId: map['currentDialogueBranchId'] as String,
      // 🔸 JSON‑массив → List<dynamic> → Set<String>
      encounteredCharacters: map['encounteredCharacters'] == null
          ? <String>{}
          : Set<String>.from(
              (map['encounteredCharacters'] as List<dynamic>).cast<String>(),
            ),
      dossiers: List<CharacterDossier>.from(
        (map['dossiers'] as List<dynamic>).map<CharacterDossier>(
          (x) => CharacterDossier.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

 String toJson() => json.encode(toMap()); 

  factory GameState.fromJson(String source) =>
      GameState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant GameState other) {
    if (identical(this, other)) return true;

    return other.currentDialogueBranchId == currentDialogueBranchId &&
        setEquals(other.encounteredCharacters, encounteredCharacters) &&
        listEquals(other.dossiers, dossiers);
  }

  @override
  int get hashCode =>
      currentDialogueBranchId.hashCode ^
      encounteredCharacters.hashCode ^
      dossiers.hashCode;

  GameState copyWith({
    String? currentDialogueBranchId,
    Set<String>? encounteredCharacters,
    List<CharacterDossier>? dossiers,
  }) {
    return GameState(
      currentDialogueBranchId:
          currentDialogueBranchId ?? this.currentDialogueBranchId,
      encounteredCharacters:
          encounteredCharacters ?? this.encounteredCharacters,
      dossiers: dossiers ?? this.dossiers,
    );
  }

  @override
  String toString() =>
      'GameState(currentDialogueBranchId: $currentDialogueBranchId, encounteredCharacters: $encounteredCharacters, dossiers: $dossiers)';
}

/// Методы для управления диалогами и выборами
class DialogueManager {
  final List<DialogueBranch> dialogueBranches; // Все диалоговые ветки
  GameState gameState;

  DialogueManager({
    required this.dialogueBranches,
    required this.gameState,
  });

  /// Получить текущую диалоговую ветку
  DialogueBranch? get currentBranch {
    return dialogueBranches.isNotEmpty
        ? dialogueBranches.firstWhere(
            (branch) =>
                branch.branchId ==
                (gameState.currentDialogueBranchId != ""
                    ? gameState.currentDialogueBranchId
                    : "branch_1"),
          )
        : null;
  }

  /// Сделать выбор и перейти к следующей ветке
  void makeChoice(DialogueChoice choice) {
    gameState.currentDialogueBranchId = choice.nextDialogueBranchId;
  }

  /// Пометить, что игрок встретил нового персонажа
  void markEncounter(String characterId) {
    gameState.encounteredCharacters.add(characterId);
  }

  /// Сохранить состояние игры
Future<void> saveGame(SharedPreferences prefs) async {
  // ⬇️ заменяем jsonEncode(gameState)
  await prefs.setString('gameState', gameState.toJson());
}

  /// Загрузить состояние игры
  Future<void> loadGame(SharedPreferences prefs) async {
    final data1 = await JsonLoader.loadData<DialogueBranch>(
      "plot",
      'assets/json/plot.json',
      (json) => DialogueBranch.fromMap(json),
    );
    final data2 = await JsonLoader.loadData<CharacterDossier>(
      "characters",
      'assets/json/characters.json',
      (json) => CharacterDossier.fromMap(json),
    );
    final data = prefs.getString('gameState');
    dialogueBranches.addAll(data1);
    gameState.dossiers.addAll(data2);
    if (data != null) {
      gameState = GameState.fromJson(data); // ← без jsonDecode
    }
  }

  /// Начать новую игру
 

}

class CharacterDossier {
  final String name; // Имя/идентификатор
  final String background; // Краткое описание/био

  final String hologramAvatar; // Ссылка/путь к голографическому аватару

  CharacterDossier({
    required this.name,
    required this.background,
    required this.hologramAvatar,
  });

  CharacterDossier copyWith({
    String? name,
    String? background,
    String? hologramAvatar,
  }) {
    return CharacterDossier(
      name: name ?? this.name,
      background: background ?? this.background,
      hologramAvatar: hologramAvatar ?? this.hologramAvatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'background': background,
      'hologramAvatar': hologramAvatar,
    };
  }

  factory CharacterDossier.fromMap(Map<String, dynamic> map) {
    return CharacterDossier(
      name: map['name'] as String,
      background: map['background'] as String,
      hologramAvatar: map['hologramAvatar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CharacterDossier.fromJson(String source) =>
      CharacterDossier.fromMap(json.decode(source) as Map<String, dynamic>);
}
