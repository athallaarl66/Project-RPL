import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/move_row.dart';
import 'package:xworkout/view/exercise/move_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoulderExerciseView extends StatefulWidget {
  final Map eObj;
  const ShoulderExerciseView({super.key, required this.eObj});

  @override
  State<ShoulderExerciseView> createState() => _ShoulderExerciseViewState();
}

class _ShoulderExerciseViewState extends State<ShoulderExerciseView> {
  final _firestore = FirebaseFirestore.instance;

  TextEditingController txtSearch = TextEditingController();

  List<Map<String, dynamic>> frontDeltsMovesList = [];
  List<Map<String, dynamic>> sideDeltsMovesList = [];
  List<Map<String, dynamic>> rearDeltsMovesList = [];

  Future<List<Map<String, dynamic>>> getFrontDeltsMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('shoulderExercise')
        .collection('targetMuscles')
        .doc('frontdelts')
        .collection('moves')
        .get();

    return moves.docs
        .map((move) => {
              'targetMuscleId': 'frontdelts',
              'moveId': move.id,
              'description': move.data()['description'],
              'name': move.data()['name'],
              'image': move.data()['imageUrl'],
              'video': move.data()['videoUrl']
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getSideDeltsMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('shoulderExercise')
        .collection('targetMuscles')
        .doc('sidedelts')
        .collection('moves')
        .get();

    return moves.docs
        .map((move) => {
              'targetMuscleId': 'sidedelts',
              'moveId': move.id,
              'description': move.data()['description'],
              'name': move.data()['name'],
              'image': move.data()['imageUrl'],
              'video': move.data()['videoUrl']
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getRearDeltsMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('shoulderExercise')
        .collection('targetMuscles')
        .doc('reardelts')
        .collection('moves')
        .get();

    return moves.docs
        .map((move) => {
              'targetMuscleId': 'reardelts',
              'moveId': move.id,
              'description': move.data()['description'],
              'name': move.data()['name'],
              'image': move.data()['imageUrl'],
              'video': move.data()['videoUrl']
            })
        .toList();
  }

  late Future<List<List<Map<String, dynamic>>>> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = Future.wait(
        [getFrontDeltsMoves(), getSideDeltsMoves(), getRearDeltsMoves()]);
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

          List<Map<String, dynamic>> frontDeltsMovesList = snapshot.data![0];
          List<Map<String, dynamic>> sideDeltsMovesList = snapshot.data![1];
          List<Map<String, dynamic>> rearDeltsMovesList = snapshot.data![2];

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
                    "Front Delts",
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
                    itemCount: frontDeltsMovesList.length,
                    itemBuilder: (context, index) {
                      var fObj = frontDeltsMovesList[index] as Map? ?? {};
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
                    "Side Delts",
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
                    itemCount: sideDeltsMovesList.length,
                    itemBuilder: (context, index) {
                      var fObj = sideDeltsMovesList[index] as Map? ?? {};
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
                    "Rear Delts",
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
                    itemCount: rearDeltsMovesList.length,
                    itemBuilder: (context, index) {
                      var fObj = rearDeltsMovesList[index] as Map? ?? {};
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
