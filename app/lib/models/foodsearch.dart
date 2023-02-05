class FoodSearch {
  String foodName;
  String imageURL;
  dynamic calories;
  dynamic fats;
  FoodSearch({
    required this.foodName,
    required this.imageURL,
    required this.calories,
    required this.fats,
  });

  factory FoodSearch.fromJson(Map<String, dynamic> json) {
    return FoodSearch(
      foodName: json['recipe']['label'],
      imageURL: json['recipe']['image'],
      calories: (json['recipe']['calories']).toInt(),
      fats: (json['recipe']['totalNutrients']['FAT']['quantity']).toInt(),
    );
  }
}
