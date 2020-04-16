import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/helpers/helpers.dart';
import 'package:notekeeper_flutter_solo/utils/dimens.dart';

class NewNote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewNoteState();
  }
}

class _NewNoteState extends State<NewNote> {
  Dimens dimens;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    dimens = Dimens(context);

    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: appBar(title: "Add Note"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 4,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: <Widget>[Text("back widget here")],
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
                          controller: titleController,
//                          expands: true,
                          maxLines: 4,
                          minLines: null,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
//                        height: 30,
                        child: TextField(
                          decoration: InputDecoration.collapsed(
                            hintText: "Note",
                          ),
                          controller: noteController,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          scrollPhysics: BouncingScrollPhysics(),
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
    );
  }
}
