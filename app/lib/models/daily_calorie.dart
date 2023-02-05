class DailyCalorie {
  final double maintainWeight;
  final double mildWeightLoss;
  final double weightLoss;
  final double extremeWeightLoss;
  final double mildWeightGain;
  final double weightGain;
  final double extremeWeightGain;

  DailyCalorie({
    required this.maintainWeight,
    required this.mildWeightLoss,
    required this.weightLoss,
    required this.extremeWeightLoss,
    required this.mildWeightGain,
    required this.weightGain,
    required this.extremeWeightGain,
  });

  //TODO implement Bmi.fromJson
  factory DailyCalorie.fromJson(Map<String, dynamic> json) {
    return DailyCalorie(
      maintainWeight: json['goals']["maintain weight"],
      mildWeightLoss: json['goals']["Mild weight loss"]["calory"],
      weightLoss: json['goals']['Weight loss']['calory'],
      extremeWeightLoss: json['goals']['Extreme weight loss']['calory'],
      mildWeightGain: json['goals']['Mild weight gain']['calory'],
      weightGain: json['goals']['Weight gain']['calory'],
      extremeWeightGain: json['goals']['Extreme weight gain']['calory'],
    );
  }
}
