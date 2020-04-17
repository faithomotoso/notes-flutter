import 'package:flutter/material.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/note_viewmodel.dart';
import 'package:notekeeper_flutter_solo/helpers/custom_colors.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'home.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AllNotesModel>(
          create: (context) => serviceLocator<AllNotesModel>(),
        ),
        ChangeNotifierProvider<NoteViewModel>(
          create: (context) => serviceLocator<NoteViewModel>(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme:
            ThemeData(
                primarySwatch: primaryColor,
                accentColor: secondaryColor),
        home: Home()
      ),
    );
  }
}
