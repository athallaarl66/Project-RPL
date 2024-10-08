import 'package:xworkout/common/color_extension.dart';
import 'package:flutter/material.dart';

class MoveRow extends StatelessWidget {
  final Map mObj;
  const MoveRow({super.key, required this.mObj});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          Image.network(
            mObj["image"].toString(),
            width: 50,
            height: 50,
            fit: BoxFit.contain,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                  child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ));
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return Icon(Icons.error); // Placeholder in case of error
            },
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mObj["name"].toString(),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/img/next_icon.png",
              width: 25,
              height: 25,
            ),
          )
        ],
      ),
    );
  }
}
