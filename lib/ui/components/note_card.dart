import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/helpers/custom_colors.dart';
import 'package:notekeeper_flutter_solo/helpers/helpers.dart';
import 'package:notekeeper_flutter_solo/ui/screens/create_edit_note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onLongPress;
  bool _isSelected = false;

  NoteCard({this.note, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState){
        return OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          openBuilder: (BuildContext context, VoidCallback _){
            return CreateEditNote(note: note,);
          },
          closedBuilder: (BuildContext context, VoidCallback openContainer){
            return InkWell(
              onTap: openContainer,
              onLongPress: (){
                setState((){
                  _isSelected = !_isSelected;
                });
                onLongPress();
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: !_isSelected ? primaryColor : Colors.redAccent),
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    note.title.isNotEmpty ?
                    Text(note.title, style: titleTextStyle(context: context),)
                        : SizedBox(),
                    SizedBox(
                      height: note.title.isNotEmpty ? 6 : 0,
                    ),
                    note.note.isNotEmpty ? Text(note.note,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,) : SizedBox()
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}