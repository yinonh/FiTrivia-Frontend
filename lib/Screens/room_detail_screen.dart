import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/public_room_detail.dart';
import '../Widgets/private_room_detail.dart';
import '../Screens/previous_screen.dart';
import '../Models/trivia_room.dart';
import '../Providers/trivia_rooms_provider.dart';

class RoomDetails extends StatefulWidget {
  static const routeName = "/room_details";
  final String roomIdentifier;

  const RoomDetails({required this.roomIdentifier, Key? key}) : super(key: key);

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  late TriviaRoom room;
  late bool _is_public;

  @override
  void initState() {
    super.initState();
    _is_public = Provider.of<TriviaRoomProvider>(context, listen: false)
        .publicTriviaRooms
        .contains(widget.roomIdentifier);
  }

  @override
  Widget build(BuildContext context) {
    return _is_public
        ? PublicRoomDetail(category: widget.roomIdentifier)
        : PrivateRoomDetail(roomID: widget.roomIdentifier);
  }
}
