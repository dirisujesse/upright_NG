// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

// import '../services/storage_service.dart';
// import '../models/post.dart';
import '../services/http_service.dart';

class PostBloc extends StatesRebuilder {
  List<dynamic> results = [];
  bool isLoading = false;
  bool isFail = false;

  searchPosts(State state, String query) {
    isLoading = true;
    results = [];
    isFail = false;
    rebuildStates(states: [state]);
    HttpService.searchPost(query).then((val) {
      if (!(val is int)) {
        results = val;
        isLoading = false;
        rebuildStates(states: [state]);
      } else {
        results = [];
        isLoading = false;
        isFail = true;
        rebuildStates(states: [state]);
      }
    }).catchError((err) {
      results = [];
        isLoading = false;
        isFail = true;
        rebuildStates(states: [state]);
    });
  }
}
