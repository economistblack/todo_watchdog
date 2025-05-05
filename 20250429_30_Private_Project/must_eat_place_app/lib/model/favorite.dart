class Favorite {
  final int id;
  final String date;
  final bool isfavorite;

  Favorite(
    {
      required this.id,
      required this.date,
      required this.isfavorite
    }
  );

  Favorite.fromMap(Map<String, dynamic> res)
  : id = res['id'],
  date = res['date'],
  isfavorite = res['isfavorite'];
}