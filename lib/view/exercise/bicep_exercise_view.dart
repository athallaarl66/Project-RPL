import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/move_row.dart';
import 'package:xworkout/view/exercise/move_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BicepExerciseView extends StatefulWidget {
  final Map eObj;
  const BicepExerciseView({super.key, required this.eObj});

  @override
  State<BicepExerciseView> createState() => _BicepExerciseViewState();
}

class _BicepExerciseViewState extends State<BicepExerciseView> {
  final _firestore = FirebaseFirestore.instance;

  TextEditingController txtSearch = TextEditingController();

  List<Map<String, dynamic>> bicepMovesList = [];

  Future<List<Map<String, dynamic>>> getBicepMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('bicepExercise')
        .collection('targetMuscles')
        .doc('biceps')
        .collection('moves')
        .get();

    return moves.docs
        .map((move) => {
              'targetMuscleId': 'biceps',
              'moveId': move.id,
              'name': move.data()['name'],
              'description': move.data()['description'],
              'image': move.data()['imageUrl'],
              'video': move.data()['videoUrl']
            })
        .toList();
  }

  late Future<List<Map<String, dynamic>>> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = getBicepMoves();
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
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

          List<Map<String, dynamic>> bicepMovesList = snapshot.data!;

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
                    "Bicep",
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
                    itemCount: bicepMovesList.length,
                    itemBuilder: (context, index) {
                      var fObj = bicepMovesList[index] as Map? ?? {};
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
