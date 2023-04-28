import 'package:flutter/material.dart';

import '../Screens/previous_screen.dart';

class RoomDetails extends StatelessWidget {
  static const routeName = "/room_details";
  const RoomDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
              tag: 'cover 5',
              child: Image.asset(
                "assets/music.png",
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
                Navigator.pushNamed(
                    context, PreviousScreen.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('🏁 Start 🏁', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
