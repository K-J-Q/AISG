class ExerciseDB {
  final String name;
  final String target;
  final String image;

  ExerciseDB({
    required this.name,
    required this.target,
    required this.image,
  });

  factory ExerciseDB.fromJson(Map<String, dynamic> json) {
    return ExerciseDB(
      name: json["name"],
      target: json["target"],
      image: json["gifUrl"],
    );
  }
}
