import 'dart:async';

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../services/storage_service.dart';
import '../models/user.dart';
import '../services/http_service.dart';

class UserBloc extends StatesRebuilder {
  static UserBloc instance;
  var activeUser = User(
    name: "Anonymous User",
    id: "5b3a2ddbdfecff00149ab29c",
    email: "anonymous.user@mail.com",
    username: "anonymous.user",
    avatar: 'https://www.gravatar.com/avatar',
  );
  StreamSubscription<dynamic> topContSub;
  List<dynamic> topConts = [];
  bool isLoggedIn = false;
  bool loginFail = false;
  bool isLogin = true;
  bool isLoading = false;
  bool isLoadingStat = false;
  bool isUpdating = false;
  bool isLoadingTopUsrs = false;
  bool loadingTopUsrsFail = false;
  Map<String, dynamic> usrStat;
  String msgTopUsrs = "Loading top users...";

  static UserBloc getInstance() {
    if (instance == null) {
      instance = UserBloc();
    }
    return instance;
  }

  logout(BuildContext context) {
    setActiveUser({
      "name": "Anonymous User",
      "id": "5b3a2ddbdfecff00149ab29c",
      "email": "anonymous.user@mail.com",
      "username": "anonymous.user",
      "avatar": 'https://www.gravatar.com/avatar',
    });
    Future.delayed(Duration(milliseconds: 300),
        () => Navigator.pushReplacementNamed(context, '/login'));
  }

  onAppInitCallBack(State state, context) {
    LocalStorage.getItem("isPrevUser").then((prevUser) {
      if (prevUser) {
        LocalStorage.getItem("activeUser").then((val) {
          if (val != null) {
            final data = User.fromJson(val);
            isLoggedIn = !(data.id == "5b3a2ddbdfecff00149ab29c");
            activeUser = data;
            rebuildStates(ids: ["authState"], states: [state]);
          }
          Navigator.pushReplacementNamed(context, "/home");
        }).catchError((err) {
          print(err);
          Navigator.pushReplacementNamed(context, "/home");
        });
      } else {
        Navigator.pushReplacementNamed(context, "/welcome");
      }
    }).catchError((err) {
      print(err);
      Navigator.pushReplacementNamed(context, "/welcome");
    });
  }

  setActiveUser(Map<String, dynamic> usrData) {
    LocalStorage.setItem("activeUser", usrData).then((val) {
      final data = User.fromJson(usrData);
      isLoggedIn = !(data.id == "5b3a2ddbdfecff00149ab29c");
      activeUser = data;
      rebuildStates(ids: ["authState"]);
    }).catchError((err) {
      final data = User.fromJson(usrData);
      isLoggedIn = !(data.id == "5b3a2ddbdfecff00149ab29c");
      activeUser = data;
      rebuildStates(ids: ["authState"]);
    });
  }

  Future<bool> updateUser(State state, Map<String, dynamic> data) {
    isUpdating = true;
    rebuildStates(states: [state], ids: ["profState"]);
    return Future.value(
      HttpService.updateProfile(data).then((val) {
        if (!(val is int)) {
          val = val is Map<String, dynamic> ? val : val[0];
          setActiveUser(val);
          isUpdating = false;
          rebuildStates(states: [state], ids: ["authState", "profState"]);
          return Future.value(true);
        } else {
          isUpdating = false;
          rebuildStates(states: [state], ids: ["profState"]);
          return Future.value(false);
        }
      }).catchError((err) {
        isUpdating = false;
        rebuildStates(states: [state], ids: ["profState"]);
        return Future.value(false);
      }),
    );
  }

  Future<bool> getUserStat(State state) {
    isLoadingStat = true;
    rebuildStates(states: [state], ids: ["profState"]);
    return Future.value(
      HttpService.getStats(activeUser.id).then((val) {
        if (!(val is int) && val is Map<String, dynamic>) {
          print(val);
          usrStat = val;
          isLoadingStat = false;
          rebuildStates(states: [state], ids: ["profState"]);
          return Future.value(true);
        } else {
          isLoadingStat = false;
          rebuildStates(states: [state], ids: ["profState"]);
          return Future.value(false);
        }
      }).catchError((err) {
        isLoadingStat = true;
        rebuildStates(states: [state], ids: ["profState"]);
        return Future.value(false);
      }),
    );
  }

  Future<bool> login(String username) {
    isLoading = true;
    loginFail = false;
    rebuildStates(ids: ["authState"]);
    return Future.value(
      HttpService.login(username).then((val) {
        if (!(val is int) && val is Map<String, dynamic>) {
          setActiveUser(val);
          isLoading = false;
          isLoggedIn = true;
          loginFail = false;
          rebuildStates(ids: ["authState"]);
          return Future.value(true);
        } else {
          isLoading = false;
          loginFail = true;
          rebuildStates(ids: ["authState"]);
          return Future.value(false);
        }
      }).catchError((err) {
        isLoading = false;
        loginFail = true;
        rebuildStates(ids: ["authState"]);
        return Future.value(false);
      }),
    );
  }

  Future<bool> signUp(String username, String name) {
    isLoading = true;
    // isLoggedIn = false;
    loginFail = false;
    rebuildStates(ids: ["authState"]);
    return Future.value(
      HttpService.signup(username, name).then((val) {
        if (!(val is int) && val is Map<dynamic, dynamic>) {
          setActiveUser(val);
          isLoading = false;
          isLoggedIn = true;
          loginFail = false;
          rebuildStates(ids: ["authState"]);
          return Future.value(true);
        } else {
          isLoading = false;
          loginFail = true;
          rebuildStates(ids: ["authState"]);
          return Future.value(false);
        }
      }).catchError((err) {
        isLoading = false;
        loginFail = true;
        rebuildStates(ids: ["authState"]);
        return Future.value(false);
      }),
    );
  }

  getTopConts(State state) {
    isLoadingTopUsrs = true;
    msgTopUsrs = "Loading top users..";
    loadingTopUsrsFail = false;
    topConts = [];
    rebuildStates(states: [state]);
    topContSub = HttpService.getTopUsers().asStream().listen((val) {
      if (!(val is int)) {
        if (val.length > 0) {
          topConts = val;
          msgTopUsrs = "";
          isLoadingTopUsrs = false;
          loadingTopUsrsFail = false;
          rebuildStates(states: [state]);
        } else {
          msgTopUsrs = "";
          isLoadingTopUsrs = false;
          loadingTopUsrsFail = false;
          rebuildStates(states: [state]);
        }
      } else {
        msgTopUsrs =
            "Failed to load top users check that you are connected to the internet";
        loadingTopUsrsFail = true;
        isLoadingTopUsrs = false;
        rebuildStates(states: [state]);
      }
    }, onError: (err) {
      print(err);
      isLoadingTopUsrs = false;
      loadingTopUsrsFail = true;
      msgTopUsrs =
          "Failed to load top users check that you are connected to the internet";
      rebuildStates(states: [state]);
    });
  }

  disposeTopConts() {
    if (topContSub != null) {
      topContSub.cancel();
    }
  }
}
