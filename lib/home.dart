import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
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
  final _bgColor = Colors.blueGrey.withOpacity(0.16);

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
    final AllNotesModel _allNotesModel = Provider.of<AllNotesModel>(context);

    _allNotesModel.mode.addListener(() {
      // show or hide options when a note is selected
      if (_allNotesModel.mode.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Notes",
                style: GoogleFonts.dancingScript(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    letterSpacing: 1.1,
                    color: Theme.of(context).primaryColor)),
            elevation: 0,
            backgroundColor: _bgColor,
//            backgroundColor: _colorAnimation.value,
            actions: <Widget>[
              FadeTransition(
                opacity: _animationController,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        await _allNotesModel.deleteSelectedNotes();
                      },
                      icon: Icon(CupertinoIcons.delete,
                          size: 26, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: () {
                        _allNotesModel.pinUnpinSelectedNotes();
                      },
                      icon: ImageIcon(
                        AssetImage(_allNotesModel.evalPinnedIcon()
                            ? "assets/icons/pin_filled.png"
                            : "assets/icons/pin_outline.png"),
                        color: Colors.black,
                        size: 20,
                      ),
                    )
                  ],
                ),
              )
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
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
                tooltip: "Add New Note",
              );
            },
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
              color: _bgColor,
              child: ChangeNotifierProvider.value(
                value: _allNotesModel,
                child: Consumer<AllNotesModel>(
                  builder: (context, allNotesModel, child) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                      return allNotesModel.allNotes.isNotEmpty ? SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              allNotesModel.pinnedNotes.isNotEmpty
                                  ? Text(
                                      "PINNED",
                                      style: TextStyle(
                                        fontSize: 14,
//                                color: Colors.white,
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 6,
                              ),
                              allNotesModel.pinnedNotes.isNotEmpty
                                  ? StaggeredGridView.extentBuilder(
//            crossAxisCount: 3,
                                      maxCrossAxisExtent: dimens.width / 2,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          allNotesModel.pinnedNotes.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Note indexNote =
                                            allNotesModel.pinnedNotes[index];
                                        return NoteCard(
                                          key: Key("${indexNote.id}"),
                                          note: indexNote,
                                        );
                                      },
                                      shrinkWrap: true,
                                      staggeredTileBuilder: (int index) =>
                                          StaggeredTile.fit(1),
                                      mainAxisSpacing: 10,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      crossAxisSpacing: 10,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 6,
                              ),
                              allNotesModel.pinnedNotes.isNotEmpty
                                  ? Text(
                                      "OTHERS",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 6,
                              ),
                              StaggeredGridView.extentBuilder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                maxCrossAxisExtent: dimens.width / 2,
                                itemCount: allNotesModel.allNotes.length,
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                itemBuilder: (BuildContext context, int index) {
                                  Note indexNote =
                                      allNotesModel.allNotes[index];
                                  return NoteCard(
                                    key: Key("${indexNote.id}"),
                                    note: indexNote,
                                  );
                                },
                                staggeredTileBuilder: (int index) =>
                                    StaggeredTile.fit(1),
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              )
                            ],
                          ),
                        ),
                      ) : Center(
                        child: Text(
                          "Wow... such empty 🌚",
                          style: GoogleFonts.dancingScript(
                            color: Theme.of(context).primaryColor,
                            fontSize: 22
                          ),
                        )
                      );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
