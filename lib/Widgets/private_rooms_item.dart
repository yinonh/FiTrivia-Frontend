import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../Providers/trivia_rooms_provider.dart';
import '../Screens/edit_room.dart';
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
    // Show confirmation dialog to the user
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate('Confirm'),
        ),
        content: Text(
          AppLocalizations.of(context)
              .translate('Are you sure you want to delete this room?'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppLocalizations.of(context).translate('No'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context).translate('Yes'),
            ),
          ),
        ],
      ),
    );

    // If the user confirms, delete the room
    if (confirm == true) {
      try {
        await Provider.of<TriviaRoomProvider>(context, listen: false)
            .removeRoom(roomId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate('Room removed.'),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString().substring(11))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String inviteMessage = AppLocalizations.of(context)
            .translate('Come join my room:') +
        ' $roomId ${!isPublic ? AppLocalizations.of(context).translate('Password') + ': $roomPass' : ''}';
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
                      onPressed: (BuildContext cnx) async {
                        removeRoom(context, roomId);
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: AppLocalizations.of(context).translate('Delete'),
                    ),
                  ],
                ),
      endActionPane: MediaQuery.of(context).size.height <
              MediaQuery.of(context).size.width
          ? null
          : ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 2,
                  onPressed: (BuildContext context) {
                    Navigator.pushReplacementNamed(context, EditRoom.routeName,
                        arguments: this.roomId);
                  },
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: AppLocalizations.of(context).translate('Edit'),
                ),
                SlidableAction(
                  onPressed: (BuildContext context) async {
                    await Clipboard.setData(ClipboardData(text: inviteMessage));
                    Share.share(inviteMessage);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).translate(
                              'Invite message copied to clipboard successfully.'),
                        ),
                      ),
                    );
                  },
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: AppLocalizations.of(context).translate('Share'),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context).translate(
                                  'Invite message copied to clipboard successfully.'),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, EditRoom.routeName,
                            arguments: this.roomId);
                      },
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
