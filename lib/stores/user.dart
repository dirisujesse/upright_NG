import 'dart:async';

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../services/storage_service.dart';
import '../models/user.dart';
import '../services/http_service.dart';

class UserBloc extends StatesRebuilder {
  var activeUser = User(
    name: "Anonymous User",
    id: "2383992922",
    email: "anonymous.user@mail.com",
    username: "anonymous.user",
    avatar: 'https://www.gravatar.com/avatar',
  );
  List<dynamic> topConts = [];
  bool isLoggedIn = false;
  bool loginFail = false;
  bool isLogin = true;
  bool isLoading = false;
  bool isLoadingTopUsrs = false;
  String msgTopUsrs = "Loading top users...";

  UserBloc() {
    // LocalStorage.getItem("activeUser").then((val) {
    //   if (val != false) {
    //     isLoggedIn = true;
    //     activeUser = User.fromJson(val);
    //     rebuildStates(ids: ["authState"]);
    //     setActiveUser(val);
    //     Navigator.pushReplacementNamed(context, "/home");
    //   }
    // }).catchError((err) {
    //   print(err);
    //   Navigator.pushReplacementNamed(context, "/home");
    // });
  }

  setLogin() {
    isLogin = !isLogin;
    rebuildStates(ids: ["authState"]);
  }

  onAppInitCallBack(State state, context) {
    LocalStorage.getItem("isPrevUser").then((prevUser) {
      if (prevUser) {
        LocalStorage.getItem("activeUser").then((val) {
          isLoggedIn = true;
          activeUser = User.fromJson(val);
          rebuildStates(ids: ["authState"], states: [state]);
          setActiveUser(val);
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
      isLoggedIn = true;
      activeUser = User.fromJson(usrData);
      rebuildStates(ids: ["authState"]);
    }).catchError((err) {
      activeUser = User.fromJson(usrData);
      rebuildStates(ids: ["authState"]);
    });
  }

  Future<bool> login(String username) {
    isLoading = true;
    isLoggedIn = false;
    loginFail = false;
    rebuildStates(ids: ["authState"]);
    return Future.value(
      HttpService.login(username).then((val) {
        if (!(val is int) && val is Map<String, dynamic>) {
          setActiveUser(val);
          print(val);
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
    isLoggedIn = false;
    loginFail = false;
    rebuildStates(ids: ["authState"]);
    return Future.value(
      HttpService.signup(username, name).then((val) {
        print(val);
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

  Future<dynamic> getTopConts(State state) {
    isLoadingTopUsrs = true;
    msgTopUsrs = "Loading top users..";
    rebuildStates(states: [state]);
    return Future.value(
      HttpService.getTopUsers().then((val) {
        if (!(val is int) && val.length > 0) {
          topConts = val;
          msgTopUsrs = "";
          isLoadingTopUsrs = false;
          rebuildStates(states: [state]);
          return Future.value(true);
        } else {
          msgTopUsrs = "";
          isLoadingTopUsrs = false;
          rebuildStates(states: [state]);
          return Future.value(false);
        }
      }).catchError((err) {
        print(err);
        isLoadingTopUsrs = false;
        msgTopUsrs =
            "Failed to load top users check that you are connected to the internet";
        rebuildStates(states: [state]);
        return Future.value(false);
      }),
    );
  }
}
