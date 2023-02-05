import '../models/fitness_user.dart';
import '../models/bmi.dart';
import '../models/foodsearch.dart';
import '../models/exercisedb.dart';
import '../models/daily_calorie.dart';
import '../models/burned_calories.dart';
import '../models/macro.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCalls {
  Map<String, String> requestHeaders = {
    'X-RapidAPI-Host': 'fitness-calculator.p.rapidapi.com',
    'X-RapidAPI-Key':
        'b89006d4a8msh21bbd6f19489031p192426jsnbae688e5cc2f' //TODO
  };

  Future<Bmi> fetchBmi(FitnessUser user) async {
    String baseURL = 'https://fitness-calculator.p.rapidapi.com/bmi';

    Map<String, String> queryParams = {
      'age': user.age.toString(),
      'weight': user.weight.toString(),
      'height': user.height.toString(),
    };

    String queryString = Uri(queryParameters: queryParams).query;
    final response = await http.get(Uri.parse(baseURL + '?' + queryString),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      //TODO return Bmi object
      return Bmi.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load bmi');
    }
  }

  Future<Macro> fetchMacro(FitnessUser user) async {
    String baseURL =
        'https://fitness-calculator.p.rapidapi.com/macrocalculator';
    String goalmacro;
    if (user.goal.toString() == 'maintain weight') {
      goalmacro = 'maintain';
    } else if (user.goal.toString() == 'Mild weight loss') {
      goalmacro = 'mildlose';
    } else if (user.goal.toString() == 'Weight loss') {
      goalmacro = 'weightlose';
    } else if (user.goal.toString() == 'Extreme weight loss') {
      goalmacro = 'extremelose';
    } else if (user.goal.toString() == 'Mild weight gain') {
      goalmacro = 'mildgain';
    } else if (user.goal.toString() == 'Weight gain') {
      goalmacro = 'weightgain';
    } else if (user.goal.toString() == 'Extreme weight gain') {
      goalmacro = 'extremegain';
    } else {
      goalmacro = '';
    }
    Map<String, String> queryParams = {
      'age': user.age.toString(),
      'gender': user.gender.toString(),
      'height': user.height.toString(),
      'weight': user.weight.toString(),
      'activitylevel':
          (user.activityLevel.substring(user.activityLevel.length - 1)),
      'goal': goalmacro,
    };

    String queryString = Uri(queryParameters: queryParams).query;
    final response = await http.get(Uri.parse(baseURL + '?' + queryString),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      return Macro.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load Macro');
    }
  }

  Future<DailyCalorie> fetchDailyCalorie(FitnessUser user) async {
    //TODO
    String baseURL = 'https://fitness-calculator.p.rapidapi.com/dailycalorie';

    Map<String, String> queryParams = {
      'age': user.age.toString(),
      'weight': user.weight.toString(),
      'height': user.height.toString(),
      'gender': user.gender.toString(),
      'activitylevel': user.activityLevel.toString(),
      'goal': user.goal.toString(),
    };

    String queryString = Uri(queryParameters: queryParams).query;
    final response = await http.get(Uri.parse(baseURL + '?' + queryString),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      return DailyCalorie.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load calories');
    }
  }

  Future<BurnedCalorie> fetchBurnedCalories(
      FitnessUser user, activityid, activitymin) async {
    //TODO
    String baseURL = 'https://fitness-calculator.p.rapidapi.com/burnedcalorie';

    Map<String, String> queryParams = {
      'activityid': activityid,
      'activitymin': activitymin,
      'weight': user.weight.toString(),
    };

    String queryString = Uri(queryParameters: queryParams).query;
    final response = await http.get(Uri.parse(baseURL + '?' + queryString),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      return BurnedCalorie.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load burned calories');
    }
  }

  Future<List<FoodSearch>> fetchFoodSearch(String foodq) async {
    String baseURL =
        'https://edamam-recipe-search.p.rapidapi.com/search?q=$foodq';
    Map<String, String> requestHeaders = {
      'X-RapidAPI-Key': 'b89006d4a8msh21bbd6f19489031p192426jsnbae688e5cc2f',
      'X-RapidAPI-Host': 'edamam-recipe-search.p.rapidapi.com'
    };

    final response =
        await http.get(Uri.parse(baseURL), headers: requestHeaders);

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      //TODO #2 Returns List<BusArrival> showing bus arrival times of all buses at the bus stop
      var servicesList = jsonDecode(response.body)['hits'] as List;
      return servicesList.map((json) => FoodSearch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to food search');
    }
  }

  Future<List<ExerciseDB>> fetchExerciseDB(String typeq) async {
    String baseURL =
        'https://exercisedb.p.rapidapi.com/exercises/bodyPart/$typeq';
    Map<String, String> requestHeaders = {
      'X-RapidAPI-Key': 'b89006d4a8msh21bbd6f19489031p192426jsnbae688e5cc2f',
      'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com'
    };

    final response =
        await http.get(Uri.parse(baseURL), headers: requestHeaders);

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      //TODO #2 Returns List<BusArrival> showing bus arrival times of all buses at the bus stop
      var exercisesList = jsonDecode(response.body) as List;
      return exercisesList.map((json) => ExerciseDB.fromJson(json)).toList();
    } else {
      throw Exception('Failed to food search');
    }
  }
}
