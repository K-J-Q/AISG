import 'package:flutter/material.dart';
import '../models/exercisedb.dart';
import '../utilities/api_calls.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments.toString();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  iconSize: 40,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Try out this excercises!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder<List<ExerciseDB>>(
                future: ApiCalls().fetchExerciseDB(args.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      padding: EdgeInsets.all(5),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        mainAxisExtent: 270,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 50,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                offset: Offset(0, 5),
                                blurRadius: 6.0,
                              )
                            ],
                          ),
                          width: (MediaQuery.of(context).size.width / 2) - 10,
                          height: (MediaQuery.of(context).size.width / 2) + 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                snapshot.data![index].image,
                                height:
                                    (MediaQuery.of(context).size.width / 2) -
                                        20,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data![index].name,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Target: " +
                                            snapshot.data![index].target,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
