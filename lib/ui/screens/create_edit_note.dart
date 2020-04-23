import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/note_viewmodel.dart';
import 'package:notekeeper_flutter_solo/helpers/custom_colors.dart';
import 'package:notekeeper_flutter_solo/helpers/helpers.dart';
import 'package:notekeeper_flutter_solo/utils/dimens.dart';
import 'package:provider/provider.dart';

class CreateEditNote extends StatefulWidget {
  final Note note;

  CreateEditNote({this.note});

  @override
  State<StatefulWidget> createState() {
    return _CreateEditNoteState();
  }
}

class _CreateEditNoteState extends State<CreateEditNote> {
  Dimens dimens;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  bool pinned;
  final formKey = GlobalKey<FormState>();

  String _oldTitleText;
  String _oldNoteText;
  bool _oldPinnedStatus;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note.title;
      noteController.text = widget.note.note;

      _oldTitleText = widget.note.title;
      _oldNoteText = widget.note.note;
      _oldPinnedStatus = widget.note.isPinned;
      pinned = _oldPinnedStatus; // modify pinned variable
    }
  }

  @override
  Widget build(BuildContext context) {
    dimens = Dimens(context);
    final NoteViewModel _noteViewModel = Provider.of<NoteViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.back,
                        size: 18,
                      ),
                      onPressed: () => _backButtonChanges(
                          noteViewModel: _noteViewModel, note: widget.note),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        widget.note != null
                            ? _deleteButton(
                                noteViewModel: _noteViewModel,
                                note: widget.note)
                            : SizedBox(),
                        SizedBox(
                          width: 4,
                        ),
                        pinned != null
                            ? _pinButton(noteViewModel: _noteViewModel)
                            : SizedBox(),
                        SizedBox(
                          width: 4,
                        ),
                        _saveButton(noteViewModel: _noteViewModel)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    width: dimens.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 30,
                          child: TextField(
                            decoration: InputDecoration.collapsed(
                              hintText: "Title",
                            ),
                            style: titleTextStyle(context: context),
                            textCapitalization: TextCapitalization.sentences,
                            controller: titleController,
//                          expands: true,
                            maxLines: 4,
                            minLines: null,
                            enableInteractiveSelection: true,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Expanded(
                          child: Container(
                            child: TextField(
                              decoration: InputDecoration.collapsed(
                                hintText: "Note",
                              ),
                              controller: noteController,
                              textCapitalization: TextCapitalization.sentences,
                              expands: true,
                              maxLines: null,
                              minLines: null,
//                            scrollPhysics: BouncingScrollPhysics(),
                              enableInteractiveSelection: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void save({@required NoteViewModel noteViewModel}) {
    if (widget.note == null) {
      // create a new note if title or note field is not empty
      if (titleController.text.isNotEmpty || noteController.text.isNotEmpty) {
        noteViewModel.createNewNote(
            title: titleController.text, note: noteController.text);
      }
    } else {
      if (!(_oldNoteText == noteController.text) ||
          !(_oldTitleText == titleController.text) ||
          !(_oldPinnedStatus == pinned)) {
        noteViewModel.saveNote(
            note: widget.note,
            titleText: titleController.text,
            noteText: noteController.text,
            isPinned: pinned);
      }
    }
  }

  Widget _saveButton({@required NoteViewModel noteViewModel}) {
    return SizedBox(
//      height: 18,
//      width: 24,
      child: IconButton(
        icon: Icon(
          Icons.save,
          size: 22,
          color: primaryColor,
        ),
        tooltip: "Save",
        alignment: Alignment.center,
        onPressed: () async {
          save(noteViewModel: noteViewModel);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _pinButton({@required NoteViewModel noteViewModel}) {
    return IconButton(
      onPressed: () {
        setState(() {
          pinned = !pinned;
        });
      },
      icon: ImageIcon(
        AssetImage(pinned
            ? "assets/icons/pin_filled.png"
            : "assets/icons/pin_outline.png"),
        size: 20,
      ),
    );
  }

  Widget _deleteButton(
      {@required NoteViewModel noteViewModel, @required Note note}) {
    return IconButton(
      onPressed: () async {
        Navigator.pop(context);
        Future.delayed(Duration(milliseconds: 300)).then((_) {
          // delay for a while before deleting
          // openContainer error
          noteViewModel.deleteNote(note: note);
        });
      },
      icon: Icon(
        CupertinoIcons.delete,
        size: 26,
      ),
      tooltip: "Delete",
    );
  }

  void _backButtonChanges(
      {@required NoteViewModel noteViewModel, @required Note note}) {
    // show a dialog if changes has been made to title or note
    if (noteController.text.isNotEmpty || titleController.text.isNotEmpty) {
      if (!(_oldNoteText == noteController.text) ||
          !(_oldTitleText == titleController.text) ||
          !(_oldPinnedStatus == pinned)) {
        // changes detected
        showModal(
            context: context,
            configuration: FadeScaleTransitionConfiguration(),
            builder: (BuildContext context) {
              return Align(
                alignment: Alignment.center,
                child: Container(
                  height: dimens.height * 0.2,
                  width: dimens.width * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Discard Changes?",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              inherit: false,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "No",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.redAccent.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              padding: EdgeInsets.zero,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context,
                                    true); // pass true to discard changes
                              },
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.green.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).then((discard) {
          if (discard != null) {
            if (discard) {
              Navigator.pop(context);
            }
          }
        });
      } else {
        // no change detected
        Navigator.pop(context);
      }
    } else {
      // go back when note and title text controllers are empty
      // new note tapped but nothing typed
      Navigator.pop(context);
    }
  }
}
