import 'package:flutter/material.dart';

import '../Screens/previous_screen.dart';
import '../Models/trivia_room.dart';

class RoomDetails extends StatelessWidget {
  static const routeName = "/room_details";
  final TriviaRoom room;
  const RoomDetails({required this.room, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
              tag: room.id,
              child: Image.asset(
                room.picture,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Album Title',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8),
            Text(
              'Artist Name',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //Navigator.pop(context);
                Navigator.pushNamed(context, PreviousScreen.routeName,
                    arguments: room.id);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '🏁 Start 🏁',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
