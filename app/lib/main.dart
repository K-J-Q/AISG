import 'package:fitness/screens/guide_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/exercise_screen.dart';
import '../screens/update_fitness_user_screen.dart';
import '../screens/add_food_screen.dart';
import '../models/caloriesintake.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalIntake(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/exercise': (context) => const ExerciseScreen(),
          '/user': (context) => const UpdateFitnessUserScreen(),
          '/food': (context) => const AddFoodScreen(),
          '/guide': (context) => const GuideScreen(),
        },
      ),
    );
  }
}
