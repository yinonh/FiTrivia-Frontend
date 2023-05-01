import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/trivia_room.dart';
import '../Screens/auth_screen.dart';
import '../Screens/previous_screen.dart';
import '../Screens/room_detail_screen.dart';
import '../Widgets/private_rooms_item.dart';
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

  final List<PrivateRoomItem> userPrivateRooms = List.generate(
    10,
    (index) => PrivateRoomItem(),
  );

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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   List<TriviaRoom> publicRoomsList =
  //       Provider.of<TriviaRoomProvider>(context).triviaRooms;
  //   publicRooms = List.generate(
  //     publicRoomsList.length,
  //     (index) => PublicRoomItems(category: publicRoomsList[index]),
  //   );
  // }

  Drawer drawer(BuildContext context) {
    bool logout_pressed = false;
    return Drawer(
      backgroundColor: Colors.blueGrey[50],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Image.asset(
                "assets/logo2.png",
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Create New Room'),
            onTap: () {
              // Implement your logic for creating a new room here
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_awesome),
            title: Text('Surprise Me'),
            onTap: () {
              // Implement your logic for surprising the user here
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: logout_pressed ? Text('...') : Text('Logout'),
            onTap: () async {
              logout_pressed = true;
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Trivia Rooms")),
      ),
      drawer: drawer(context),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Text(
          //   'Headline',
          //   style: TextStyle(fontSize: 18),
          // ),
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
            child: ListView.builder(
              itemCount: userPrivateRooms.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      child: userPrivateRooms[index],
                      onTap: () {
                        print(index);
                        //Navigator.pushNamed(context, PreviousScreen.routeName);
                      },
                    ),
                    Divider(
                        //color: Colors.grey,
                        // thickness: 1.0,
                        // height: 1.0,
                        ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
