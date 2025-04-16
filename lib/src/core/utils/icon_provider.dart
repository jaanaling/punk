enum IconProvider {
  back(imageName: 'back.webp'),
  chapter1(imageName: 'CHAPTER 1.webp'),
  chapter2(imageName: 'CHAPTER 2.webp'),
  chapter3(imageName: 'CHAPTER 3.webp'),
  chapters(imageName: 'CHAPTERS.webp'),
  continueBtn(imageName: 'CONTINUE.webp'),
  dialog(imageName: 'dialog.webp'),
  dossier(imageName: 'dossier.webp'),
  dossierPanel(imageName: 'dossier_panel.webp'),
  erisHentDossier(imageName: 'Eris Hent dossier.webp'),
  errasCollapse(imageName: 'ERRAS collapse.webp'),
  errasNeutral(imageName: 'ERRAS neutral.webp'),
  errasObsession(imageName: 'ERRAS obsession.webp'),
  glutch(imageName: 'glutch.webp'),
  iliasWireDossier(imageName: 'ILIAS WIRE dossier.webp'),
  interrogationRoom(imageName: 'Interrogation Room with Evricon.webp'),
  jackingOut(imageName: 'Jacking Out of Evricon.webp'),
  logo(imageName: 'logo.webp'),
  lowerQuarter(imageName: 'Lower Quarter.webp'),
  lyraMoraDossier(imageName: 'Lyra Mora dossier.webp'),
  lyraNeutral(imageName: 'LYRA neutral.webp'),
  lyraParanoia(imageName: 'LYRA paranoia.webp'),
  lyraRage(imageName: 'LYRA rage.webp'),
  marcusRionDossier(imageName: 'Marcus Rion dossier.webp'),
  menuPanel(imageName: 'menu panel.webp'),
  menu(imageName: 'MENU.webp'),
  newGame(imageName: 'NEW GAME.webp'),
  nikaNeutral(imageName: 'NIKA neutral.webp'),
  nikaSad(imageName: 'NIKA sad.webp'),
  nikaAggressive(imageName: 'NIKA aggressive.webp'),
  nikaSerovaDossier(imageName: 'Nika Serova dossier.webp'),
  normal(imageName: 'normal.webp'),
  policeStation(imageName: 'Police Station LEXIS.webp'),
  reconstruction(imageName: 'Reconstruction in Sphere.webp'),
  rionCynicism(imageName: 'RION cynicism.webp'),
  rionAggressive(imageName: 'RION aggressive.webp'),
  rionNeutral(imageName: 'RION neutral.webp'),
  rionsSecretRoom(imageName: "Rion's Secret Room.webp"),
  splash(imageName: 'splash.webp'),
  stressed(imageName: 'stressed.webp'),
  cellOfErras(imageName: 'The Cell of Erras Hent.webp'),
  vairFrightened(imageName: 'VAIR frightened.webp'),
  vairNeutral(imageName: 'VAIR neutral.webp'),
  vairPsychopanic(imageName: 'VAIR psychopanic.webp'),
  vairsApartment(imageName: "Vair's Apartment.webp"),
  virtualWorld(imageName: 'Virtual World.webp'),
  soundOn(imageName: 'sound_on.png'),
  soundOff(imageName: 'sound_off.png'),

  unknown(imageName: '');

  const IconProvider({required this.imageName});

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name';
}
