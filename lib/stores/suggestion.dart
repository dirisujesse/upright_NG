import 'dart:async';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../services/http_service.dart';
import './user.dart';

class SuggestionBloc extends StatesRebuilder {
  static SuggestionBloc instance;
  final usrData = UserBloc.getInstance();
  bool isLoading = false;
  bool failed = false;

  static SuggestionBloc getInstance() {
    if (instance == null) {
      instance = SuggestionBloc();
    }
    return instance;
  }

  Future<bool> makeSuggestion(Map<String, dynamic> data) {
    isLoading = true;
    rebuildStates(ids: ["suggState"]);
    return Future.value(
      HttpService.addSuggestion(data).then((val) {
        if (val is int) {
          isLoading = false;
          failed = true;
          rebuildStates(ids: ["suggState"]);
          return Future.value(false);
        } else {
          isLoading = false;
          failed = false;
          rebuildStates(ids: ["suggState"]);
          return Future.value(true);
        }
      }).catchError((err) {
        isLoading = false;
        failed = true;
        rebuildStates(ids: ["suggState"]);
        return Future.value(false);
      }),
    );
  }
}
