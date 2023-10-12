enum CustomAsset {
  pokerTableBackground('assets/images/poker_table_background.jpg'),
  backOfCardPngNetworkImg('https://deckofcardsapi.com/static/img/back.png');

  const CustomAsset(this.path);

  final String path;
}
