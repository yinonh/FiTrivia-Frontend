import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Screens/previous_screen.dart';
import '../Screens/room_detail_screen.dart';
import '../Widgets/private_rooms_item.dart';
import '../Widgets/public_room_items.dart';


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class TriviaRooms extends StatelessWidget {
  static const routeName = '/trivia_rooms_screen';

  TriviaRooms({Key? key}) : super(key: key);
  final List<PublicRoomItems> publicRooms = List.generate(
    9,
    (index) => PublicRoomItems(index: index,),
  );

  final List<PrivateRoomItem> userPrivateRooms = List.generate(
    10,
    (index) => PrivateRoomItem(),
    );

  get drawer{
    return Drawer(
      backgroundColor: Colors.blueGrey[50],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Center(child: Text('My App')),
            decoration: BoxDecoration(
              color: Colors.blue,
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
            leading: Icon(Icons.cake),
            title: Text('Surprise Me'),
            onTap: () {
              // Implement your logic for surprising the user here
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Implement your logic for logging out the user here
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
        title: Text("Trivia Rooms"),
      ),
      drawer: drawer,
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
                control: new SwiperControl(),
                onTap: (index) {
                  print(index);
                  Navigator.pushNamed(
                      context, RoomDetails.routeName);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 8, 0),
            child: Text(
              'Private Rooms:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800,),
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
                return GestureDetector(
                  child: userPrivateRooms[index],
                  onTap: () {
                    print(index);
                    Navigator.pushNamed(
                        context, PreviousScreen.routeName);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
