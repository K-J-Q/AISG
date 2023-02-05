import 'dart:async';

import 'package:fitness/utilities/firebase_calls.dart';
import 'package:flutter/material.dart';

import '../models/exercise_type.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';
import '../models/exercise.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  static const countdownDuration = Duration(minutes: 10);
  Duration duration = Duration();
  Timer? timer;

  bool isCountDown = false;

  @override
  void initState() {
    super.initState();

    // startTimer();
    reset();
  }

  void reset() {
    if (isCountDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void addTime() {
    final addSeconds = isCountDown ? -1 : 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    setState(() => timer?.cancel());
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  //TODO Shortlist your exercises
  final List<ExerciseType> _exercises = <ExerciseType>[
    ExerciseType(id: 'ru_4', description: 'Plank'),
    ExerciseType(id: 'ru_5', description: 'Push Up'),
    ExerciseType(id: 'ru_6', description: 'Sit Up'),
  ];

  ExerciseType? _selectedExercise;
  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String _exercisePath = "";
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    Widget buildButtons() {
      final isRunning = timer == null ? false : timer!.isActive;
      final isCompleted = duration.inSeconds == 0;

      return isRunning || !isCompleted
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      if (isRunning) {
                        stopTimer(resets: false);
                      } else {
                        startTimer(resets: false);
                        print(_selectedExercise?.id);
                        setState(() {
                          if (_selectedExercise?.id == "ru_5") {
                            _exercisePath = "images/pushup.gif";
                          } else if (_selectedExercise?.id == "ru_4") {
                            _exercisePath = "images/planks.gif";
                          } else {
                            _exercisePath = "";
                          }
                        });
                      }
                    },
                    child: Text(
                      isRunning ? "STOP" : "RESUME",
                    )),
                SizedBox(
                  width: 12,
                ),
                TextButton(
                    onPressed: () {
                      stopTimer();
                    },
                    child: Text('CANCEL')),
              ],
            )
          : TextButton(
              onPressed: () {
                startTimer();
              },
              child: Text(
                'START',
                style: TextStyle(color: Colors.black),
              ));
    }

    Widget buildTimeCard({required String time, required String header}) =>
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                time,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(header),
          ],
        );

    return Column(
      children: [
        DropdownButton<ExerciseType>(
          value: _selectedExercise,
          items: _exercises
              .map(
                (desc) => DropdownMenuItem(
                  value: desc,
                  child: Text(desc.description),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedExercise = value!;
            });
          },
        ),
        Image(
          image: AssetImage(_exercisePath),
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTimeCard(time: minutes, header: "Mins"),
            SizedBox(
              width: 2,
            ),
            buildTimeCard(time: seconds, header: "Secs"),
          ],
        ),
        buildButtons(),
        ElevatedButton(
          child: const Text("ADD"),
          onPressed: () async {
            //TODO ApiCalls().fetchBurnedCalories()
            String activityid = _selectedExercise!.id;
            String description = _selectedExercise!.description;
            String activitymin = duration.inMinutes.toString();
            final burned = await ApiCalls()
                .fetchBurnedCalories(fitnessUser, activityid, activitymin);
            //TODO FirebaseCalls().addExercise()
            Exercise newExercise = Exercise(
              id: activityid.toString(),
              description: description.toString(),
              duration: int.parse(duration.inMinutes.toString()),
              burnedCalories: burned.burnedCalories,
            );
            FirebaseCalls().addExercise(newExercise);
          },
        ),
      ],
    );
  }
}
