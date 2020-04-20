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

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Dimens dimens;
  AnimationController _animationController;
  Animation _colorAnimation;

  @override
  void initState() {
    super.initState();
    Provider.of<AllNotesModel>(context, listen: false).loadNotes();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
        reverseDuration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    dimens = Dimens(context);
    final NoteViewModel _noteViewModel = Provider.of<NoteViewModel>(context);
    final AllNotesModel _allNotesModel = Provider.of<AllNotesModel>(context);

    _allNotesModel.mode.addListener(() {
      if (_allNotesModel.mode.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    _colorAnimation = ColorTween(
            begin: Theme.of(this.context).primaryColor, end: Colors.white)
        .animate(CurvedAnimation(
            curve: Curves.fastOutSlowIn, parent: _animationController));

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Notes"),
            backgroundColor: _colorAnimation.value,
            actions: <Widget>[
              _allNotesModel.mode.value
                  ? IconButton(
                      onPressed: () async {
                        await _allNotesModel.deleteSelectedNotes();
//                        print(_allNotesModel.allNotes[_allNotesModel.allNotes.indexWhere((note) => note.title == "sample 8")]);
                        print(_allNotesModel.allNotes[2]);
                      },
                      icon: Icon(CupertinoIcons.delete,
                          size: 26, color: Colors.black),
                    )
                  : SizedBox()
            ],
          ),
          floatingActionButton: OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            closedElevation: 6.0,
            closedShape: CircleBorder(),
            openBuilder: (BuildContext context, VoidCallback _) {
              return CreateEditNote();
            },
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
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
                builder: (context, allNotesModel, child) {
//                  return StaggeredGridView.extentBuilder(
////            crossAxisCount: 3,
//                    maxCrossAxisExtent: dimens.width / 2,
//                    itemCount: allNotesModel.allNotes.length,
//                    itemBuilder: (BuildContext context, int index) {
//                      Note indexNote = allNotesModel.allNotes[index];
//                      print("Index Note - index $index: $indexNote");
//                      return NoteCard(
//                        note: indexNote,
////                    selectionMode: _longPressActivated,
//                        selectionMode: allNotesModel.mode.value,
//                      );
//                    },
//                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
//                    mainAxisSpacing: 10,
//                    crossAxisSpacing: 10,
//                  );

                // changed to listview, thought there was an issue with the gridview package
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 6,
                      );
                    },
                    itemCount: allNotesModel.allNotes.length,
                    itemBuilder: (context, index) {
                      Note indexNote = allNotesModel.allNotes[index];
//                      print("Index Note - index $index: $indexNote");
                      return NoteCard(
                        note: indexNote,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
