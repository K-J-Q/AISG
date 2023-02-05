import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

import '../screens/guide_screen.dart';
import '../screens/home_screen.dart';
import 'update_fitness_user_screen.dart';
import '../utilities/firebase_calls.dart';
import '../models/fitness_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SignInScreen(
              providerConfigs: [
                EmailProviderConfiguration(),
              ],
            );
          } else {
            if (snapshot.data?.displayName == null) {
              return const ProfileScreen(
                providerConfigs: [
                  EmailProviderConfiguration(),
                ],
              );
            } else {
              //check if User is found in fitnessUsers collection
              return FutureBuilder<FitnessUser>(
                future: FirebaseCalls().getFitnessUser(snapshot.data!.uid),
                builder: (context, snapshot2) {
                  if (!snapshot2.hasData) {
                    //User is NOT found in fitnessUsers collection
                    return const UpdateFitnessUserScreen();
                  } else if (snapshot2.hasData) {
                    return const HomeScreen();
                  } else if (snapshot2.hasError) {
                    return Text('${snapshot2.error}');
                  }
                  return const CircularProgressIndicator();
                },
              );
            }
          }
        },
      ),
    );
  }
}
