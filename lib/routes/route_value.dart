enum RouteValue {
  splash(path: '/'),
  home(path: '/home'),
  chapters(path: 'chapters'),
  game(path: 'game'),

  unknown(path: '');

  final String path;
  const RouteValue({required this.path});
}
