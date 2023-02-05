import 'package:fitness/models/foodsearch.dart';
import 'package:fitness/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/api_calls.dart';
import '../models/caloriesintake.dart';
import '../utilities/constants.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  TextEditingController foodSearchController = TextEditingController();
  String foodSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 2),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.deepPurple, Colors.purpleAccent.shade400])
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  decoration: kTextFieldInputDecoration,
                  controller: foodSearchController,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.purpleAccent.shade400,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: TextButton(
                child: const Text('Update', style: kButtonTextStyle),
                onPressed: () {
                  foodSearch = foodSearchController.text;
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<FoodSearch>>(
                future: ApiCalls().fetchFoodSearch(foodSearch),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Colors.purple.shade200,
                          elevation: 10,
                          child: Container(
                            width: MediaQuery.of(context).size.width-20,
                            padding: EdgeInsets.all(0),
                            child: Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      snapshot.data![index].imageURL,fit: BoxFit.fitWidth,),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: MediaQuery.of(context).size.width -180,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].foodName,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text("Energy: " + (snapshot.data![index].calories).toString() + " kcal",),
                                        Text("Fats: " + (snapshot.data![index].fats).toString() + " g",),
                                      ],
                                    ),
                                  ),
                                    Consumer<CalIntake>(
                                      builder: (context, cart, child) {
                                        return Container(
                                          width: 40,
                                          height: 100,
                                          color: Colors.purple,
                                          child: IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              cart.addtoList(snapshot.data![index]);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                        //TODO #3 Build ListTile to show bus number and next 2 arrival times
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
