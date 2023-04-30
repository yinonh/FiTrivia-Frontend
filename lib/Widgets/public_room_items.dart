import 'package:flutter/material.dart';

import '../Models/trivia_room.dart';

class PublicRoomItems extends StatelessWidget {
  TriviaRoom room;
  PublicRoomItems({required this.room, Key? key}) : super(key: key);

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
              tag: room.id,
              child: Image.asset(
                room.picture,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Container(
                height: 50,
                width: double.infinity,
                color: Colors.blue[500]?.withOpacity(0.8),
                child: Center(
                  child: Text(
                    room.name,
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
