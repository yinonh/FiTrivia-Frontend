import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../l10n/app_localizations.dart';
import '../Screens/room_detail_screen.dart';
import '../Widgets/navigate_drawer.dart';
import '../Providers/trivia_rooms_provider.dart';
import '../Models/trivia_room.dart';

class WheelScreen extends StatefulWidget {
  static const routeName = '/wheel_screen';

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  late Future<List<Map<String, dynamic>>> publicRoomsList;
  final _controller = FixedExtentScrollController();

  void initState() {
    super.initState();
    publicRoomsList = Provider.of<TriviaRoomProvider>(context, listen: false)
        .getPublicTriviaRooms();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> scroll(int duration) async {
    final publicRoomsList = await this.publicRoomsList;
    final itemCount = publicRoomsList.length;
    final numRotations = Random().nextInt(4) + 2;

    // Calculate the target item index after all rotations are complete
    final targetIndex =
    ((numRotations * (Random().nextInt(itemCount) + publicRoomsList.length) - _controller.selectedItem) * -1);

    // Animate the ListWheelScrollView to the target index with a duration based on the number of rotations
    _controller.animateToItem(
      targetIndex,
      duration: Duration(milliseconds: duration),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigateDrawer(),
      appBar: AppBar(
        title: Center(
          child: Text(AppLocalizations.of(context)
              .translate('Wheel of Fortune'),),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.auto_awesome),
        onPressed: () => scroll(1500),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: publicRoomsList,
        builder: (cnx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(AppLocalizations.of(context).translate('Error') + ': ${snapshot.error}'));
          }

          final publicRoomsList = snapshot.data!;

          return Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext cox, BoxConstraints constraints) {
                    scroll(10);
                    return Center(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 200,
                        controller: _controller,
                        physics: FixedExtentScrollPhysics(),
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: publicRoomsList.map(_buildRoomWidget)
                              .toList(),
                        ),
                      ),
                    );
                  }
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: FilledButton(
                  onPressed: () {
                    String roomID = publicRoomsList[_controller.selectedItem %
                        publicRoomsList.length]['id'];
                    Navigator.pushNamed(context, RoomDetails.routeName,
                        arguments: roomID);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context).translate('Select!'),
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoomWidget(Map<String, dynamic> room) {
    return Container(
      width: min(MediaQuery.of(context).size.width * 0.8, 700),
      child: ElevatedButton(
        onPressed: () {
          print('Room ${room['name']} was pressed.');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(room['name']),
            Text(room['description']),
          ],
        ),
      ),
    );
  }
}
