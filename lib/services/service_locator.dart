import 'package:get_it/get_it.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/note_viewmodel.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/database/database_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator(){
  serviceLocator.registerLazySingleton<DatabaseAbs>(() => DatabaseService()); // problem with scalability use for mocking only
  serviceLocator.registerLazySingleton<DatabaseService>(() => DatabaseService());

  serviceLocator.registerLazySingleton<NoteViewModel>(() => NoteViewModel());
  serviceLocator.registerLazySingleton<AllNotesModel>(() => AllNotesModel());

}