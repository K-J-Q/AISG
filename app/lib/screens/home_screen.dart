import 'dart:ui';
import 'package:fitness/models/caloriesintake.dart';
import 'package:fitness/models/daily_calorie.dart';
import 'package:fitness/models/fitness_user.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';
import '../models/bmi.dart';
import '../utilities/api_calls.dart';
import '../models/macro.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LinearGradient _bmiColor(String bmiRange, double bmi) {
    var bmiArray = bmiRange.split(' ');
    double min = double.parse(bmiArray[0]);
    double max = double.parse(bmiArray[2]);
    if (bmi < min) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.yellow, Colors.orange, Colors.orangeAccent],
      );
    } else if (bmi > max) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.red, Colors.redAccent],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.green, Colors.lightGreenAccent, Colors.white],
      );
    }
  }

  double _bmipercent(double bmi) {
    double bmipercent = bmi / 36;
    return bmipercent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.deepPurple,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      alignment: Alignment.center,
                      child: const Text(
                        "Home",
                        style: TextStyle(fontSize: 20,color: Colors.white),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurpleAccent,
                        ),
                        child: IconButton(
                            onPressed: () {
                              auth.signOut();
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.deepPurple, Colors.deepPurpleAccent, Colors.purple.shade300, Colors.purpleAccent],
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 10,
                      top: 0,
                      child: Container(
                        margin: const EdgeInsets.only(left: 25),
                        width: 170,
                        height: 400,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/Home(Man).png"),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 190,
                      left: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Good Morning,',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 45,
                                letterSpacing: -1,
                                color: Colors.white),
                          ),
                          Text(
                            '${auth.currentUser?.displayName}!',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 45,
                                letterSpacing: -1,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 10,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          height: 170,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 4.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Status",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              FutureBuilder<Bmi>(
                                future: ApiCalls().fetchBmi(fitnessUser),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      height: 130,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            decoration: BoxDecoration(
                                                color: Colors.lightGreenAccent
                                                    .withOpacity(0.6),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(20)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    offset: const Offset(
                                                        0.0, 4.0), //(x,y)
                                                    blurRadius: 6.0,
                                                  ),
                                                ]),
                                            width: 140,
                                            height: 140,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 10,
                                                  top: 20,
                                                  child:
                                                      CircularPercentIndicator(
                                                    radius: 120.0,
                                                    lineWidth: 13.0,
                                                    animation: true,
                                                    animationDuration: 1000,
                                                    percent: _bmipercent(
                                                        snapshot.data!.bmi),
                                                    arcType: ArcType.HALF,
                                                    arcBackgroundColor: Colors
                                                        .grey
                                                        .withOpacity(0.2),
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    linearGradient: _bmiColor(
                                                        snapshot.data!
                                                            .healthyBmiRange,
                                                        snapshot.data!.bmi),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 60,
                                                    left: 40,
                                                    child: Text(
                                                      "${snapshot.data!.bmi}",
                                                      style: const TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Health: ${snapshot.data!.health}!',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Healthy bmi range is between ${snapshot.data!.healthyBmiRange}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ));
                                },
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 15),
                child: Text(
                  "Explore Exercises:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 200,
                margin: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.only(bottom: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/guide',
                            arguments: "chest");
                      },
                      child: Column(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) - 20,
                            height: 150,
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: const Center(
                                child: Text(
                              '',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                            decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              image: new DecorationImage(
                                image: new AssetImage("images/pushup.jpg"),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          const Text(
                            "Chest",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/guide',
                            arguments: "upper arms");
                      },
                      child: Column(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) - 20,
                            height: 150,
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: const Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            decoration: ShapeDecoration(
                              color: Colors.grey,
                              shape: const CircleBorder(),
                              image: new DecorationImage(
                                image: new AssetImage("images/bicepcurl.jpg"),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          const Text(
                            "Arms",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/guide',
                            arguments: "cardio");
                      },
                      child: Column(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) - 20,
                            height: 150,
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: const Center(
                                child: Text(
                              '',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                            decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              image: new DecorationImage(
                                image: new AssetImage("images/cardiolol.jpg"),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          const Text(
                            "Cardio",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/guide',
                            arguments: "upper legs");
                      },
                      child: Column(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) - 20,
                            height: 150,
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: const Center(
                                child: Text(
                              '',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                            decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              image: new DecorationImage(
                                image: new AssetImage("images/legday.jpg"),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          const Text(
                            "Legs",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.purpleAccent, Colors.purple.shade300, Colors.deepPurpleAccent, Colors.deepPurple],
                    ),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //TODO widget to show bmi, health and healthyBmiRange
                    //TODO widget to show daily calorie requirement of user
                    FutureBuilder<DailyCalorie>(
                      future: ApiCalls().fetchDailyCalorie(fitnessUser),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          double dailycalories = 0.0;
                          switch (fitnessUser.goal.toString()) {
                            case 'maintain weight':
                              {
                                dailycalories = snapshot.data!.maintainWeight;
                              }
                              break;
                            case 'Mild weight loss':
                              {
                                dailycalories = snapshot.data!.mildWeightLoss;
                              }
                              break;
                            case 'Weight loss':
                              {
                                dailycalories = snapshot.data!.weightLoss;
                              }
                              break;
                            case 'Extreme weight loss':
                              {
                                dailycalories =
                                    snapshot.data!.extremeWeightLoss;
                              }
                              break;
                            case 'Mild weight gain':
                              {
                                dailycalories = snapshot.data!.mildWeightGain;
                              }
                              break;
                            case 'Weight gain':
                              {
                                dailycalories = snapshot.data!.weightGain;
                              }
                              break;
                            case 'Extreme weight gain':
                              {
                                dailycalories =
                                    snapshot.data!.extremeWeightGain;
                              }
                              break;
                          }
                          return Consumer<CalIntake>(
                            builder: (context, cart, child) {
                              double _percentcals() {
                                double fraction =
                                    cart.totalCals / dailycalories;
                                if (fraction > 1) {
                                  fraction = 1;
                                }
                                return fraction;
                              }
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text("Current Goal", style: const TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold, decoration: TextDecoration.underline,),),
                                  ),
                                  Text(fitnessUser.goal.toString(), style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text("Daily Calories Required", style: const TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold, decoration: TextDecoration.underline,)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(dailycalories.toStringAsFixed(1)+" kcal", style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(200)),
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: CircularPercentIndicator(
                                      radius: 250.0,
                                      lineWidth: 20.0,
                                      animation: true,
                                      backgroundColor: Colors.white,
                                      percent: _percentcals(),
                                      center: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${cart.totalCals} kcals',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25.0,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      circularStrokeCap: CircularStrokeCap.round,
                                      linearGradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.deepPurpleAccent,
                                            Color(0xFFB39AE7),
                                            Color(0xFF8D6DF1),
                                          ]),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    FutureBuilder<Macro>(
                        future: ApiCalls().fetchMacro(fitnessUser),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(bottom: 10, top: 10),
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Nutrients Needed:",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                                  ),
                                  (
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/3 - 20,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [Colors.green, Colors.greenAccent, Colors.green.shade300],
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(20))
                                          ),
                                          child: Column(
                                          children: [
                                            Text("Protein",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              height: 50.0,
                                              width: 50.0,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'images/protein.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Container(
                                              width: 80,
                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white),
                                              child: Text(
                                                snapshot.data!.protein.toString(),
                                                style: const TextStyle(
                                                    fontSize: 20, color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const Text("kcal",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width/3 - 20,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [Colors.red, Colors.redAccent, Colors.red.shade300],
                                            ),
                                            borderRadius: const BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: Column(
                                          children: [
                                            Text("Carbs",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              height: 50.0,
                                              width: 50.0,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'images/carbohydrates.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Container(
                                              width: 80,
                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white),
                                              child: Text(
                                                snapshot.data!.carbs.toString(),
                                                style: const TextStyle(
                                                    fontSize: 20, color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const Text("kcal",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width/3 - 20,
                                        height: 120,
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [Colors.blue, Colors.lightBlue, Colors.lightBlueAccent],
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: Column(
                                          children: [
                                            Text("Fats",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              height: 50.0,
                                              width: 50.0,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'images/trans-fats-free.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Container(
                                              width: 80,
                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white),
                                              child: Text(
                                                snapshot.data!.fats.toString(),
                                                style: const TextStyle(
                                                    fontSize: 20, color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const Text("kcal",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const Center();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
