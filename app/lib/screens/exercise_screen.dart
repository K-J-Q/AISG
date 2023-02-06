import 'dart:ui';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/utilities/firebase_calls.dart';
import 'package:flutter/material.dart';
import '../models/caloriesintake.dart';

import '../widgets/navigation_bar.dart';
import 'add_exercise_screen.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  Future<void> _deleteTask(String id) {
    return exercisesCollection
        .doc(id)
        .delete()
        .then((value) => print("Exercise Deleted"))
        .catchError((error) => print("Failed to delete task: $error"));
  }

  String _exerciseTitle(String description) {
    var descriptionArray = description.split(',');
    return descriptionArray[0];
  }

  Color _exerciseColor(String description) {
    String type = _exerciseTitle(description);
    if (type == "Running") {
      return Colors.redAccent;
    } else if (type == "Cycling") {
      return const Color(0xFF98dc44);
    } else {
      return Colors.deepPurpleAccent;
    }
  }

  Icon _exerciseIcon(String description) {
    String type = _exerciseTitle(description);
    if (type == "Running") {
      return Icon(
        Icons.directions_run_rounded,
        size: 40,
        color: Colors.white,
      );
    } else if (type == "Cycling") {
      return Icon(
        Icons.directions_bike,
        size: 40,
        color: Colors.white,
      );
    } else {
      return Icon(
        Icons.sports_basketball_sharp,
        size: 40,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //TODO StreamBuilder to show documents in exercises collection
            Container(
              color: Colors.deepPurple,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      "Exercise",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: exercisesCollection
                          .where('userid', isEqualTo: auth.currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              crossAxisSpacing: 20,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot doc =
                                  snapshot.data!.docs[index];

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: GestureDetector(
                                  onLongPress: () {
                                    Provider.of<CalIntake>(context,
                                            listen: false)
                                        .addtoBurned(double.parse(2.2));
                                    _deleteTask(doc.id);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color:
                                            _exerciseColor(doc['description']),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.9),
                                            offset: Offset(5, 5), //(x,y)
                                            blurRadius: 6.0,
                                          ),
                                        ]),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            _exerciseIcon(doc['description']),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              width: 90,
                                              child: Text(
                                                _exerciseTitle(
                                                    doc['description']),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              (2.2).toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.whatshot,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "kcal",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              (doc['duration']).toString() +
                                                  ' mins',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        height: 60,
                        width: 130,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Color(0xE25E5C5C),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          children: [
                            Text(
                              "Total Burned:",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.yellow),
                            ),
                            Consumer<CalIntake>(
                              builder: (context, cart, child) {
                                return Text(
                                  cart.totalBurned.toStringAsFixed(2) + "kcal",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.yellow),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              padding: EdgeInsets.all(5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.deepPurple.shade300,
                      Colors.purpleAccent,
                      Colors.purple,
                    ]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.5), blurRadius: 5)
                    ]),
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddExerciseScreen(),
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Add Exercise'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                      fixedSize: const Size(300, 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
