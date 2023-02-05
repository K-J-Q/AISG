class Bmi {
  final double bmi;
  final String health;
  final String healthyBmiRange;

  Bmi({
    required this.bmi,
    required this.health,
    required this.healthyBmiRange,
  });

  //TODO implement Bmi.fromJson
  factory Bmi.fromJson(Map<String, dynamic> json) {
    return Bmi(
      bmi: json['bmi'],
      health: json['health'],
      healthyBmiRange: json['healthy_bmi_range'],
    );
  }
}
