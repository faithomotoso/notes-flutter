import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/note_viewmodel.dart';
import 'package:notekeeper_flutter_solo/helpers/helpers.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';
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

//  NoteViewModel _noteViewModel;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    if (widget.note != null){
      titleController.text = widget.note.title;
      noteController.text = widget.note.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    dimens = Dimens(context);
   final NoteViewModel _noteViewModel = Provider.of<NoteViewModel>(context);
//    final AllNotesModel allNotesModel = Provider.of<AllNotesModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: appBar(title: "Add Note"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _backButton(noteViewModel: _noteViewModel),
                    Row(
                      children: <Widget>[
                       widget.note != null ? _deleteButton(noteViewModel: _noteViewModel, note: widget.note) : SizedBox()
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
//                        height: 30,
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

  Widget _backButton({@required NoteViewModel noteViewModel}){
    return SizedBox(
//      height: 18,
//      width: 24,
      child: IconButton(
        icon: Icon(CupertinoIcons.back, size: 18,),
        onPressed: () async {
          if (widget.note == null){
            // create a new note if title or note field is not empty
            if (titleController.text.isNotEmpty || noteController.text.isNotEmpty){
              noteViewModel.createNewNote(
                  title: titleController.text,
                  note: noteController.text
              );
            }
          } else {
            noteViewModel.saveNote(note: widget.note, titleText: titleController.text, noteText: noteController.text);
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _deleteButton({@required NoteViewModel noteViewModel, @required Note note}){
    return IconButton(
      onPressed: () async {
        Navigator.pop(context);
        Future.delayed(Duration(milliseconds: 300)).then((_){
          // delay for a while before deleting
          // openContainer error
          noteViewModel.deleteNote(note: note);
        });
      },
      icon: Icon(CupertinoIcons.delete, size: 26,),
    );
  }
}
