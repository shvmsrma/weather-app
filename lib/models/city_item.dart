class CityItem {
  CityItem(
      {required this.id,
      required this.name,
      required this.country,
      required this.region,
      required this.lat,
      required this.long,
      required this.url});
  final int id;
  final String name;
  final String country;
  final String region;
  final double lat;
  final double long;
  final String url;
}
