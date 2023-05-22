import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/trivia_room.dart';
import '../Screens/add_room_screen.dart';
import '../Screens/room_detail_screen.dart';
import '../Widgets/private_rooms_item.dart';
import '../Widgets/navigate_drawer.dart';
import '../Widgets/public_room_items.dart';
import '../Providers/trivia_rooms_provider.dart';
import '../Providers/music_provider.dart';

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
  late List<Map<String, dynamic>> _privateRooms = [];
  late TriviaRoomProvider _privateRoomsProvider;
  late AudioPlayer bgMusic;

  Future<void> customShowDialog(
      {context, title, content, actionWidgets}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$title'),
          content: content,
          actions: actionWidgets,
        );
      },
    );
  }

  bool _checkPass(String pass1, String pass2) {
    return pass1 == pass2;
  }

  @override
  void initState() {
    super.initState();
    //Provider.of<MusicProvider>(context, listen: false).startBgMusic();
    publicRoomsList = Provider.of<TriviaRoomProvider>(context, listen: false)
        .publicTriviaRooms;
    publicRooms = List.generate(
      publicRoomsList.length,
      (index) => PublicRoomItems(category: publicRoomsList[index]),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _privateRoomsProvider = Provider.of<TriviaRoomProvider>(context);
    _privateRoomsFuture = _privateRoomsProvider
        .getTriviaRoomsByManagerID(FirebaseAuth.instance.currentUser!.uid);
    _privateRoomsFuture.then((rooms) {
      setState(() {
        _privateRooms = rooms;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // create a TextEditingController object
    final TextEditingController _searchController = TextEditingController();
    final TextEditingController _roomPasswordController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Trivia Rooms")),
      ),
      drawer: NavigateDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(AddRoom.routeName);
        },
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
          Divider(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _searchController,
                    // attach the TextEditingController
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter room ID to join',
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  String userInput = _searchController.text.trim();
                  if (userInput.isEmpty ||
                      !await _privateRoomsProvider
                          .isRoomExistsById(userInput)) {
                    customShowDialog(
                        context: context,
                        title: 'Room Not Found',
                        content: Text('Can\'t find room with this ID'),
                        actionWidgets: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ]);
                  } else {
                    TriviaRoom searchedRoom = await _privateRoomsProvider
                        .getTriviaRoomById(userInput);
                    bool forwardToRoom = true;
                    bool canceled = false;
                    if (!searchedRoom.isPublic) {
                      forwardToRoom = false;
                      await customShowDialog(
                        context: context,
                        title: 'Secured Room',
                        content: TextField(
                          controller: _roomPasswordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Password',
                          ),
                          obscureText: true,
                        ),
                        actionWidgets: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              forwardToRoom = _checkPass(
                                  _roomPasswordController.text,
                                  searchedRoom.password);
                              _roomPasswordController.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              canceled = true;
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                      _roomPasswordController.clear();
                    }
                    if (forwardToRoom) {
                      _searchController.clear();
                      Navigator.pushNamed(context, RoomDetails.routeName,
                          arguments: userInput);
                    } else if (!canceled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Wrong Password')));
                    }
                  }
                },
              ),
            ],
          ),
          Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 8, 0),
            child: Text(
              'My Rooms:',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _privateRoomsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<Map<String, dynamic>> privateRooms =
                      snapshot.data ?? [];

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
                              roomPass: room['password'],
                              isPublic: room['isPublic'],
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
