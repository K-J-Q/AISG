class Macro {
  final double protein;
  final double fats;
  final double carbs;

  Macro({
    required this.protein,
    required this.fats,
    required this.carbs,
  });

  //TODO implement Bmi.fromJson
  factory Macro.fromJson(Map<String, dynamic> json) {
    return Macro(
      protein: double.parse(json['balanced']['protein'].toStringAsFixed(2)),
      fats: double.parse(json['balanced']['fat'].toStringAsFixed(2)),
      carbs: double.parse(json['balanced']['carbs'].toStringAsFixed(2)),
    );
  }
}
