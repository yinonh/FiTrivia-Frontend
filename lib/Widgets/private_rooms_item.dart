import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../Providers/trivia_rooms_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class PrivateRoomItem extends StatelessWidget {
  final String roomName;
  final String description;
  final String roomId;
  final String roomPass;
  final bool isPublic;

  const PrivateRoomItem({
    required this.roomName,
    required this.description,
    required this.roomId,
    required this.roomPass,
    required this.isPublic,
    Key? key,
  }) : super(key: key);

  Future<void> removeRoom(BuildContext context, String roomId) async {
    try {
      await Provider.of<TriviaRoomProvider>(context, listen: false)
          .removeRoom(roomId);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Room removed.')));
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString().substring(11))));
    }
  }

  @override
  Widget build(BuildContext context) {
    String inviteMessage =
        'Come join my room: $roomId ${!isPublic ? 'Password: $roomPass' : ''}';
    return Slidable(
      key: const ValueKey(0),
      startActionPane:
          MediaQuery.of(context).size.height < MediaQuery.of(context).size.width
              ? null
              : ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: ScrollMotion(),

                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        removeRoom(context, roomId);
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
      endActionPane: MediaQuery.of(context).size.height <
              MediaQuery.of(context).size.width
          ? null
          : ActionPane(
              motion: ScrollMotion(),
              children: [
                const SlidableAction(
                  // An action can be bigger than the others.
                  flex: 2,
                  onPressed: null,
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (BuildContext context) async {
                    await Clipboard.setData(ClipboardData(text: inviteMessage));
                    Share.share(inviteMessage);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Invite message copied to clipboard successfully.')));
                  },
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),
      child: ListTile(
        leading: Icon(Icons.text_fields),
        title: Text(roomName),
        subtitle: Text(description),
        trailing: MediaQuery.of(context).size.height <
                MediaQuery.of(context).size.width
            ? Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: inviteMessage));
                        Share.share(inviteMessage);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Invite message copied to clipboard successfully.')));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeRoom(context, roomId);
                      },
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
