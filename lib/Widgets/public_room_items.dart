import 'package:flutter/material.dart';

class PublicRoomItems extends StatelessWidget {
  int index;
  PublicRoomItems({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.blueGrey[100],
      child: SizedBox(
        width: 300,
        height: 100,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Hero(
              tag: "cover $index",
              child: Image.network(
                "assets\\music.png",
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Container(
                height: 50,
                width: double.infinity,
                color: Colors.blue.withOpacity(0.5),
                child: const Center(
                  child: Text(
                    "Music",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )
            //Center(child: Text('Filled Card')),
          ],
        ),
      ),
    );
  }
}
