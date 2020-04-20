import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/helpers/custom_colors.dart';
import 'package:notekeeper_flutter_solo/helpers/helpers.dart';
import 'package:notekeeper_flutter_solo/ui/screens/create_edit_note.dart';
import 'package:provider/provider.dart';

//bool _isSelected = false;
class NoteCard extends StatefulWidget {
  final Note note;

  // not using these
  final VoidCallback onLongPress;
  final VoidCallback onTap; // call when longpress is activated
  bool selectionMode; // true for bulk selection

  NoteCard({this.note, this.onLongPress, this.onTap, this.selectionMode});

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

    void select(){

      _isSelected = !_isSelected;

      if (_allNotesModel.mode.value && _allNotesModel.selectedNotes.length == 1 && !_isSelected){
//        _allNotesModel.longPressActivated = false;
        _allNotesModel.mode.value = false; // cancel selection mode
        _allNotesModel.selectedNotes.clear();
      } else {
//        _allNotesModel.longPressActivated = true;
        _allNotesModel.mode.value = true; // activate selection mode
      }

      if (_allNotesModel.mode.value){
        if (_isSelected){
          _allNotesModel.addToSelectedNotes(note: note);
        } else {
          _allNotesModel.removeFromSelectedNotes(note: note);
        }
      }

      print("Selected notes: ${_allNotesModel.selectedNotes}");

    }

    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (BuildContext context, VoidCallback _) {
        return CreateEditNote(
          note: note,
        );
      },
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return InkWell(
          onTap: () {
            if (!_isSelected && !_allNotesModel.mode.value) {
              openContainer();
            } else {
              setState(() {
//                _isSelected = !_isSelected;
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
                border: Border.all(
                    color: !_isSelected ? primaryColor : Colors.redAccent),
                borderRadius: BorderRadius.circular(10)),
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    : SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
}
