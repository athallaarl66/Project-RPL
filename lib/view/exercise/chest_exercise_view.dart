import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/move_row.dart';
import 'package:xworkout/view/exercise/move_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChestExerciseView extends StatefulWidget {
  final Map eObj;
  const ChestExerciseView({super.key, required this.eObj});

  @override
  State<ChestExerciseView> createState() => _ChestExerciseViewState();
}

class _ChestExerciseViewState extends State<ChestExerciseView> {
  final _firestore = FirebaseFirestore.instance;

  TextEditingController txtSearch = TextEditingController();

  List<Map<String, dynamic>> upperChestMovesList = [];
  List<Map<String, dynamic>> middleChestMovesList = [];
  List<Map<String, dynamic>> lowerChestMovesList = [];

  Future<List<Map<String, dynamic>>> getUpperChestMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('chestExercise')
        .collection('targetMuscles')
        .doc('upperChest')
        .collection('moves')
        .get();

    return moves.docs
        .map((move) => {
              'targetMuscleId': 'upperChest',
              'moveId': move.id,
              'description': move.data()['description'],
              'name': move.data()['name'],
              'image': move.data()['imgUrl'],
              'video': move.data()['videoUrl']
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getMiddleChestMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('chestExercise')
        .collection('targetMuscles')
        .doc('midChest')
        .collection('moves')
        .get();

    return moves.docs
        .map((move) => {
              'targetMuscleId': 'midChest',
              'moveId': move.id,
              'description': move.data()['description'],
              'name': move.data()['name'],
              'image': move.data()['imgUrl'],
              'video': move.data()['videoUrl']
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getLowerChestMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('chestExercise')
        .collection('targetMuscles')
        .doc('lowerChest')
        .collection('moves')
        .get();

    return moves.docs
        .map((move) => {
              'targetMuscleId': 'lowerChest',
              'moveId': move.id,
              'description': move.data()['description'],
              'name': move.data()['name'],
              'image': move.data()['imgUrl'],
              'video': move.data()['videoUrl']
            })
        .toList();
  }

  late Future<List<List<Map<String, dynamic>>>> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = Future.wait(
        [getUpperChestMoves(), getMiddleChestMoves(), getLowerChestMoves()]);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          widget.eObj["name"].toString(),
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          // Extract the data for each muscle group
          List<Map<String, dynamic>> upperChestMovesList = snapshot.data![0];
          List<Map<String, dynamic>> middleChestMovesList = snapshot.data![1];
          List<Map<String, dynamic>> lowerChestMovesList = snapshot.data![2];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Upper Chest",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: upperChestMovesList.length,
                    itemBuilder: (context, index) {
                      var fObj = upperChestMovesList[index] as Map? ?? {};
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoveView(
                                dObj: fObj,
                                mObj: widget.eObj,
                              ),
                            ),
                          );
                        },
                        child: MoveRow(
                          mObj: fObj,
                        ),
                      );
                    }),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Middle Chest",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: middleChestMovesList.length,
                    itemBuilder: (context, index) {
                      var fObj = middleChestMovesList[index] as Map? ?? {};
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoveView(
                                dObj: fObj,
                                mObj: widget.eObj,
                              ),
                            ),
                          );
                        },
                        child: MoveRow(
                          mObj: fObj,
                        ),
                      );
                    }),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Lower Chest",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lowerChestMovesList.length,
                    itemBuilder: (context, index) {
                      var fObj = lowerChestMovesList[index] as Map? ?? {};
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoveView(
                                dObj: fObj,
                                mObj: widget.eObj,
                              ),
                            ),
                          );
                        },
                        child: MoveRow(
                          mObj: fObj,
                        ),
                      );
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}
