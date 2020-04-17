import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/note_viewmodel.dart';
import 'package:notekeeper_flutter_solo/helpers/custom_colors.dart';
import 'package:notekeeper_flutter_solo/helpers/helpers.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';
import 'package:notekeeper_flutter_solo/ui/components/note_card.dart';
import 'package:notekeeper_flutter_solo/ui/screens/create_edit_note.dart';
import 'package:notekeeper_flutter_solo/utils/dimens.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Dimens dimens;

  @override
  void initState() {
    super.initState();
    Provider.of<AllNotesModel>(context, listen: false).loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    dimens = Dimens(context);
    final NoteViewModel _noteViewModel = Provider.of<NoteViewModel>(context);
    final AllNotesModel _allNotesModel = Provider.of<AllNotesModel>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(title: "Notes"),
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        closedElevation: 6.0,
        closedShape: CircleBorder(),
        openBuilder: (BuildContext context, VoidCallback _){
          return CreateEditNote();
        },
        closedBuilder: (BuildContext context, VoidCallback openContainer){
          return FloatingActionButton(
            onPressed: openContainer,
            child: Icon(
              Icons.add,
              color: Colors.white,
                size: 25,
            ),
            tooltip: "Add New Note",
          );
        },
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: ChangeNotifierProvider.value(
          value: _allNotesModel,
          child: Consumer<AllNotesModel>(
            builder: (context, allNotesModel, child){
              return StaggeredGridView.extentBuilder(
//            crossAxisCount: 3,
                maxCrossAxisExtent: dimens.width / 2,
                itemCount: allNotesModel.allNotes.length,
                itemBuilder: (BuildContext context, int index) {
                  Note indexNote = allNotesModel.allNotes[index];
//                  return InkWell(
//                    onTap: () {},
//                    child: Container(
////                  height: 10,
////                  width: 50,
//                      decoration: BoxDecoration(
//                          border: Border.all(color: primaryColor),
//                          borderRadius: BorderRadius.circular(10)),
//                      padding: EdgeInsets.all(14),
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          indexNote.title != null ?
//                          Text(indexNote.title, style: titleTextStyle(context: context),)
//                              : SizedBox(),
//                          SizedBox(
//                            height: indexNote.title != null ? 6 : 0,
//                          ),
//                          indexNote.note.isNotEmpty ? Text(indexNote.note,
//                            maxLines: 3,
//                            overflow: TextOverflow.ellipsis,) : SizedBox()
//                        ],
//                      ),
//                    ),
//                  );
                  return NoteCard(
                    note: indexNote,
                    onLongPress: (){
                      print("Long press activated");
                    },
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
