class CurrentCity {
  CurrentCity(this.lat, this.long, this.name, this.dayType, this.currentTemp,
      this.minTemp, this.maxTemp, this.forecastType);
  final double lat;
  final double long;
  final String name;
  final String dayType;
  final int currentTemp;
  final int minTemp;
  final int maxTemp;
  final String forecastType;
}
