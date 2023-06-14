import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/trivia_room.dart';
import '../Providers/trivia_rooms_provider.dart';

class PublicRoomItems extends StatelessWidget {
  String category;
  PublicRoomItems({required this.category, Key? key}) : super(key: key);

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
            Image.asset(
              'assets/$category.png',
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Container(
                height: 50,
                width: double.infinity,
                color: Colors.blue[500]?.withOpacity(0.8),
                child: Center(
                  child: Text(
                    Provider.of<TriviaRoomProvider>(context, listen: false)
                        .convertCategory(category),
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
