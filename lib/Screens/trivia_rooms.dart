import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screens/room_detail_screen.dart';
import '../Widgets/private_rooms_item.dart';
import '../Widgets/navigate_drawer.dart';
import '../Widgets/public_room_items.dart';
import '../Providers/trivia_rooms_provider.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class TriviaRooms extends StatefulWidget {
  static const routeName = '/trivia_rooms_screen';

  TriviaRooms({Key? key}) : super(key: key);

  @override
  State<TriviaRooms> createState() => _TriviaRoomsState();
}

class _TriviaRoomsState extends State<TriviaRooms> {
  late List<PublicRoomItems> publicRooms;
  late List<String> publicRoomsList;
  late Future<List<Map<String, dynamic>>> _privateRoomsFuture;

  @override
  void initState() {
    super.initState();
    publicRoomsList = Provider.of<TriviaRoomProvider>(context, listen: false)
        .publicTriviaRooms;
    publicRooms = List.generate(
      publicRoomsList.length,
      (index) => PublicRoomItems(category: publicRoomsList[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    _privateRoomsFuture =
        Provider.of<TriviaRoomProvider>(context)
            .getTriviaRoomsByManagerID(FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Trivia Rooms")),
      ),
      drawer: NavigateDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(CupertinoIcons.plus),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 200.0,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: Swiper(
                //loop: false,
                index: publicRooms.length ~/ 2,
                scale: 0.1,
                itemCount: publicRooms.length,
                itemBuilder: (BuildContext context, int index) {
                  return publicRooms[index];
                },
                //indicatorLayout: PageIndicatorLayout.COLOR,
                autoplay: MediaQuery.of(context).size.height >
                    MediaQuery.of(context).size.width,
                viewportFraction: MediaQuery.of(context).size.height >
                        MediaQuery.of(context).size.width
                    ? 1
                    : 0.3,
                pagination: new SwiperPagination(),
                control: MediaQuery.of(context).size.height >
                        MediaQuery.of(context).size.width
                    ? null
                    : new SwiperControl(),
                onTap: (index) {
                  Navigator.pushNamed(context, RoomDetails.routeName,
                      arguments: this.publicRoomsList[index]);
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 8, 0),
            child: Text(
              'Private Rooms:',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Divider(),
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top -
                AppBar().preferredSize.height -
                MediaQuery.of(context).viewPadding.top -
                260,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _privateRoomsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching private rooms'));
                } else {
                  final List<Map<String, dynamic>> privateRooms =
                      snapshot.data!;
                  return ListView.builder(
                    itemCount: privateRooms.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> room = privateRooms[index];
                      return Column(
                        children: [
                          GestureDetector(
                            child: PrivateRoomItem(
                              roomId: room['id'],
                              roomName: room['name'],
                              description: room['description'],
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoomDetails.routeName,
                                  arguments: room['id']);
                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
