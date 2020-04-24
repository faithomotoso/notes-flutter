import 'package:flutter_test/flutter_test.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';


void main(){
  setupServiceLocator();
  group("All notes view model test", () {
    test("List of notes should be empty", () {
      final model = AllNotesModel();

      expect(model.allNotes, []);
    });

    test("List of pinned notes should be empty", () {
      expect(AllNotesModel().pinnedNotes, []);
    });

    test("List of selected notes should be empty", () {
      expect(AllNotesModel().selectedNotes, []);
    });
  });
}