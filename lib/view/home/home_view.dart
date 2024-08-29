import 'package:xworkout/common_widget/exercise_row.dart';
import 'package:flutter/material.dart';
import 'package:xworkout/view/exercise/chest_exercise_view.dart';
import 'package:xworkout/view/exercise/back_exercise_view.dart';
import 'package:xworkout/view/exercise/shoulder_exercise_view.dart';
import 'package:xworkout/view/exercise/tricep_exercise_view.dart';
import 'package:xworkout/view/exercise/ab_exercise_view.dart';
import 'package:xworkout/view/exercise/bicep_exercise_view.dart';
import 'package:xworkout/view/exercise/leg_exercise_view.dart';
import '../../common/color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  List exercisesList = [];
  void getExercise() async {
    final exercises = await _firestore.collection('exercises').get();
    Map<String, dynamic> exerciseField;

    for (var exercise in exercises.docs) {
      exerciseField = {
        'exerciseId': exercise.id,
        'name': exercise.data()['name'],
        'image': exercise.data()['imgUrl'],
        'moves': exercise.data()['manyMoves']
      };
      exercisesList.add(exerciseField);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    getCurrentUser();
    getExercise();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Choose Your Exercise",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: _firestore.collection('exercises').get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: media.height * 0.7,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ); // or some other loading indicator
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    if (snapshot.hasData) {
                      // Map your data to the list
                      exercisesList = snapshot.data!.docs
                          .map((doc) => {
                                'exerciseId': doc.id,
                                'name': doc['name'],
                                'image': doc['imgUrl'],
                                'moves': doc['manyMoves']
                              })
                          .toList();

                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: exercisesList.length,
                          itemBuilder: (context, index) {
                            var wObj = exercisesList[index] as Map? ?? {};
                            return InkWell(
                                onTap: () {
                                  if (wObj['name'] == "Chest") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChestExerciseView(eObj: wObj)));
                                  } else if (wObj['name'] == "Back") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BackExerciseView(eObj: wObj)));
                                  } else if (wObj['name'] == "Shoulder") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShoulderExerciseView(
                                                    eObj: wObj)));
                                  } else if (wObj['name'] == "Tricep") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TricepExerciseView(
                                                    eObj: wObj)));
                                  } else if (wObj['name'] == "Leg") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LegExerciseView(eObj: wObj)));
                                  } else if (wObj['name'] == "Ab") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AbExerciseView(eObj: wObj)));
                                  } else if (wObj['name'] == "Bicep") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BicepExerciseView(eObj: wObj)));
                                  }
                                },
                                child: ExerciseRow(wObj: wObj));
                          });
                    } else {
                      return Text("No data available");
                    }
                  },
                ),
                SizedBox(
                  height: media.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
