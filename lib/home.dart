import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/helpers/custom_colors.dart';
import 'package:notekeeper_flutter_solo/helpers/helpers.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/ui/screens/new_note.dart';
import 'package:notekeeper_flutter_solo/utils/dimens.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Dimens dimens;
  AllNotesModel _allNotesModel = AllNotesModel();

  @override
  void initState() {
    _allNotesModel.loadNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dimens = Dimens(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(title: "Notes"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => NewNote()
          ));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: ChangeNotifierProvider<AllNotesModel>(
          create: (context) => _allNotesModel,
          child: Consumer<AllNotesModel>(
            builder: (context, allNotesModel, child){
              print("all notes length: ${allNotesModel.allNotes.length}");
              return StaggeredGridView.extentBuilder(
//            crossAxisCount: 3,
                maxCrossAxisExtent: dimens.width / 2,
                itemCount: allNotesModel.allNotes.length,
                itemBuilder: (BuildContext context, int index) {
                  Note indexNote = allNotesModel.allNotes[index];
                  return InkWell(
                    onTap: () {},
                    child: Container(
//                  height: 10,
//                  width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          indexNote.title != null ?
                          Text(indexNote.title, style: titleTextStyle(context: context),)
                              : SizedBox(),
                          SizedBox(
                            height: indexNote.title != null ? 6 : 0,
                          ),
                          Text(indexNote.note,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.fit(1),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,);
            },
          ),
        ),
      ),
    );
  }
}
