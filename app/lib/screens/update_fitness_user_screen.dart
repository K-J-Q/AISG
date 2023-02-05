import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../models/fitness_user.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/firebase_calls.dart';

class UpdateFitnessUserScreen extends StatefulWidget {
  const UpdateFitnessUserScreen({Key? key}) : super(key: key);

  @override
  State<UpdateFitnessUserScreen> createState() =>
      _UpdateFitnessUserScreenState();
}

class _UpdateFitnessUserScreenState extends State<UpdateFitnessUserScreen> {
  //TODO add gender, activityLevel, goal throughout this screen

  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  bool gendermale = true;
  String gender = 'male';
  String activityLevel = 'level_1';
  String goal = 'maintain weight';
  void _toggleGender() {
    setState(() {
      gendermale = !gendermale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: fitnessUsersCollection
                .where('userid', isEqualTo: auth.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  QueryDocumentSnapshot doc = snapshot.data!.docs[0];
                  ageController.text = doc.get('age').toString();
                  weightController.text = doc.get('weight').toString();
                  heightController.text = doc.get('height').toString();
                  if (doc.get('gender').toString() == 'male') {
                    gendermale = true;
                    gender = 'male';
                  } else if (doc.get('gender').toString() == 'female') {
                    gendermale = false;
                    gender = 'female';
                  }
                  activityLevel = doc.get('activityLevel');
                  goal = doc.get('goal');
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                            "User Profile",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Gender",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 2 - 40,
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: gendermale
                                ? Border.all(color: Colors.black, width: 2)
                                : Border.all(
                                    color: Colors.grey.shade300, width: 2)),
                        child: TextButton(
                          onPressed: () {
                            _toggleGender();
                            fitnessUser.gender = 'male';
                            FirebaseCalls().updateFitnessUser(fitnessUser);
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Spacer(),
                                Icon(
                                  Icons.male,
                                  size: 60,
                                  color:
                                      gendermale ? Colors.amber : Colors.black,
                                ),
                                Text('Male',
                                    style: TextStyle(
                                        color: gendermale
                                            ? Colors.amber
                                            : Colors.black,
                                        fontSize: 20)),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 2 - 40,
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: gendermale
                              ? Border.all(
                                  color: Colors.grey.shade300, width: 2)
                              : Border.all(color: Colors.black, width: 2),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _toggleGender();
                            fitnessUser.gender = 'female';
                            FirebaseCalls().updateFitnessUser(fitnessUser);
                          },
                          child: Column(
                            children: [
                              Spacer(),
                              Icon(
                                Icons.female,
                                size: 60,
                                color: gendermale ? Colors.black : Colors.pink,
                              ),
                              Text(
                                'Female',
                                style: TextStyle(
                                  color:
                                      gendermale ? Colors.black : Colors.pink,
                                  fontSize: 20,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: ((MediaQuery.of(context).size.width / 2) - 50),
                    width: (MediaQuery.of(context).size.width / 2) - 60,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2)),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Age",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              textAlign: TextAlign.center,
                              controller: ageController,
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: ((MediaQuery.of(context).size.width / 2) - 50) *
                            1.3,
                        width: (MediaQuery.of(context).size.width / 2) - 40,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.height),
                                Text(
                                  "Height",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              textAlign: TextAlign.center,
                              controller: heightController,
                              style: TextStyle(fontSize: 30),
                            ),
                            Container(
                              color: Colors.red,
                              alignment: Alignment.center,
                              width: 130,
                              height: 20,
                              child: Text(
                                "CM",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: ((MediaQuery.of(context).size.width / 2) - 50) *
                            1.3,
                        width: (MediaQuery.of(context).size.width / 2) - 40,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.face),
                                Text(
                                  " Weight",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              textAlign: TextAlign.center,
                              controller: weightController,
                              style: TextStyle(fontSize: 30),
                            ),
                            Container(
                              color: Colors.red,
                              alignment: Alignment.center,
                              width: 130,
                              height: 20,
                              child: Text(
                                "KG",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: ((MediaQuery.of(context).size.width / 2) - 80),
                    width: (MediaQuery.of(context).size.width / 2) - 60,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2)),
                    child: Column(
                      children: [
                        Text(
                          'Activity level',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton(
                          onChanged: (String? newValue) {
                            setState(() {
                              activityLevel = newValue!;
                              fitnessUser.activityLevel = newValue;
                              FirebaseCalls().updateFitnessUser(fitnessUser);
                            });
                          },
                          value: activityLevel,
                          icon: Icon(Icons.directions_run),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: <String>[
                            'level_1',
                            'level_2',
                            'level_3',
                            'level_4',
                            'level_5',
                            'level_6',
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: ((MediaQuery.of(context).size.width / 2) - 80),
                    width: (MediaQuery.of(context).size.width / 2) - 60,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2)),
                    child: Column(
                      children: [
                        Text(
                          'Goal: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        DropdownButton(
                          onChanged: (String? newValue) {
                            setState(() {
                              goal = newValue!;
                              fitnessUser.goal = newValue!;
                              FirebaseCalls().updateFitnessUser(fitnessUser);
                            });
                          },
                          value: goal,
                          icon: Icon(Icons.event_note),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: <String>[
                            'maintain weight',
                            'Mild weight loss',
                            'Weight loss',
                            'Extreme weight loss',
                            'Mild weight gain',
                            'Weight gain',
                            'Extreme weight gain',
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      fitnessUser = FitnessUser(
                        age: int.parse(ageController.text),
                        weight: int.parse(weightController.text),
                        height: int.parse(heightController.text),
                        gender: gender,
                        activityLevel: activityLevel,
                        goal: goal,
                      );
                      FirebaseCalls().updateFitnessUser(fitnessUser);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
