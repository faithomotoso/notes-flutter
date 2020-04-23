import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/helpers/custom_colors.dart';
import 'package:notekeeper_flutter_solo/helpers/helpers.dart';
import 'package:notekeeper_flutter_solo/ui/screens/create_edit_note.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Key key;

  NoteCard({this.note, this.key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NoteCardState();
  }
}

class _NoteCardState extends State<NoteCard> {
  bool _isSelected = false;
  Note note;

  @override
  void initState() {
    super.initState();
    note = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    final AllNotesModel _allNotesModel = Provider.of<AllNotesModel>(context);

    _allNotesModel.mode.addListener(() {
      if (_allNotesModel.mode.value == false) {
        if (this.mounted) {
          setState(() {
            _isSelected = false;
          });
        }
      }
    });

    void select() {
      _isSelected = !_isSelected;

      if (_allNotesModel.mode.value &&
          _allNotesModel.selectedNotes.length == 1 &&
          !_isSelected) {
        _allNotesModel.mode.value = false; // cancel selection mode
        _allNotesModel.selectedNotes.clear();
      } else {
        _allNotesModel.mode.value = true; // activate selection mode
      }

      if (_allNotesModel.mode.value) {
        if (_isSelected) {
          _allNotesModel.addToSelectedNotes(note: note);
        } else {
          _allNotesModel.removeFromSelectedNotes(note: note);
        }
      }

      _allNotesModel.evalPinnedIcon(); // evaluate the pinned icon here
    }

    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16),
              boxShadow: [
        BoxShadow(
            color: Colors.white.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 4.5)
      ]
          ),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return CreateEditNote(
            note: note,
          );
        },
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//        closedElevation: 3.5,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return InkWell(
            onTap: () {
              if (!_isSelected && !_allNotesModel.mode.value) {
                openContainer();
              } else {
                setState(() {
                  select();
                });
              }
            },
            onLongPress: () async {
              setState(() {
                select();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color:
                        !_isSelected ? Colors.transparent : Colors.redAccent),
              ),
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  note.title.isNotEmpty
                      ? Text(
                          note.title,
                          style: titleTextStyle(context: context),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: note.title.isNotEmpty ? 6 : 0,
                  ),
                  note.note.isNotEmpty
                      ? Text(
                          note.note,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
