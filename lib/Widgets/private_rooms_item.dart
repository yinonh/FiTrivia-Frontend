import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PrivateRoomItem extends StatelessWidget {
  const PrivateRoomItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane:
          MediaQuery.of(context).size.height < MediaQuery.of(context).size.width
              ? null
              : const ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: ScrollMotion(),

                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: null,
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
      endActionPane:
          MediaQuery.of(context).size.height < MediaQuery.of(context).size.width
              ? null
              : const ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      // An action can be bigger than the others.
                      flex: 2,
                      onPressed: null,
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: null,
                      backgroundColor: Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'Share',
                    ),
                  ],
                ),
      child: ListTile(
        leading: Icon(Icons.text_fields),
        title: Text('Title'),
        subtitle: Text('Subtitle'),
        trailing: MediaQuery.of(context).size.height <
                MediaQuery.of(context).size.width
            ? Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
