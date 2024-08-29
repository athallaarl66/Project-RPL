import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/move_row.dart';
import 'package:xworkout/view/exercise/move_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BackExerciseView extends StatefulWidget {
  final Map eObj;
  const BackExerciseView({super.key, required this.eObj});

  @override
  State<BackExerciseView> createState() => _BackExerciseViewState();
}

class _BackExerciseViewState extends State<BackExerciseView> {
  final _firestore = FirebaseFirestore.instance;

  TextEditingController txtSearch = TextEditingController();

  List<Map<String, dynamic>> latsMovesList = [];
  List<Map<String, dynamic>> trapsMovesList = [];

  Future<List<Map<String, dynamic>>> getLatsMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('backExercise')
        .collection('targetMuscles')
        .doc('lats')
        .collection('moves')
        .get();

    return moves.docs
        .map((move) => {
              'targetMuscleId': 'lats',
              'moveId': move.id,
              'name': move.data()['name'],
              'image': move.data()['imageUrl'],
              'description': move.data()['description'],
              'video': move.data()['videoUrl']
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getTrapsMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('backExercise')
        .collection('targetMuscles')
        .doc('trapezius')
        .collection('moves')
        .get();

    return moves.docs
        .map((move) => {
              'targetMuscleId': 'trapezius',
              'moveId': move.id,
              'name': move.data()['name'],
              'image': move.data()['imageUrl'],
              'description': move.data()['description'],
              'video': move.data()['videoUrl']
            })
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    getLatsMoves();
    getTrapsMoves();
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
      body: FutureBuilder(
        future: Future.wait([getLatsMoves(), getTrapsMoves()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Map<String, dynamic>> latsMovesList = snapshot.data?[0] ?? [];
          List<Map<String, dynamic>> trapsMovesList = snapshot.data?[1] ?? [];

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
                    "Lats",
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
                    itemCount: latsMovesList.length,
                    itemBuilder: (context, index) {
                      var fObj = latsMovesList[index] as Map? ?? {};
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Trapezius",
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
                    itemCount: trapsMovesList.length,
                    itemBuilder: (context, index) {
                      var fObj = trapsMovesList[index] as Map? ?? {};
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
