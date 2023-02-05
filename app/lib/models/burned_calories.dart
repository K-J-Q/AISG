class BurnedCalorie {
  final String burnedCalories;

  BurnedCalorie({
    required this.burnedCalories,
  });

  //TODO implement Bmi.fromJson
  factory BurnedCalorie.fromJson(Map<String, dynamic> json) {
    return BurnedCalorie(
      burnedCalories: json['data']['burnedCalorie'],
    );
  }
}
