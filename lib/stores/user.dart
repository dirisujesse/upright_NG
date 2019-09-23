import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as fs;

import 'package:flutter/material.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../services/storage_service.dart';
import '../models/user.dart';
import '../services/http_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserBloc extends StatesRebuilder {
  TextEditingController logUsrName = TextEditingController(text: "");
  TextEditingController logPassword = TextEditingController(text: "");
  final TextEditingController signUsrName = TextEditingController(text: "");
  final TextEditingController signName = TextEditingController(text: "");
  final TextEditingController signPassword = TextEditingController(text: "");
  static UserBloc instance;
  var activeUser = User(
    name: "Anonymous User",
    id: "5b3a2ddbdfecff00149ab29c",
    email: "anonymous.user@mail.com",
    username: "anonymous.user",
    avatar: 'https://res.cloudinary.com/jesse-dirisu/image/upload/v1569184517/Mask_Group_4_A12_Group_18_pattern.png',
    telephone: "+234 910 001 5617",
    points: 0,
    isMember: false,
  );
  StreamSubscription<dynamic> topContSub;
  List<dynamic> topConts = [];
  bool isLoggedIn = false;
  bool loginFail = false;
  bool isEdit = false;
  bool isLogin = true;
  bool isLoading = false;
  bool isLoadingStat = false;
  bool isUpdating = false;
  bool isChangingAvatar = false;
  bool isLoadingTopUsrs = false;
  bool loadingTopUsrsFail = false;
  File tempAvatar;
  Map<String, dynamic> usrStat;
  String msgTopUsrs = "Loading top users...";
  final PermissionHandler _permissionHandler = PermissionHandler();

  static UserBloc getInstance() {
    if (instance == null) {
      instance = UserBloc();
    }
    return instance;
  }

  toggleEdit(State state) {
    isEdit = !isEdit;
    rebuildStates(ids: ["profState"], states: [state]);
  }

  logout(BuildContext context) {
    setActiveUser({
      "name": "Anonymous User",
      "id": "5b3a2ddbdfecff00149ab29c",
      "email": "anonymous.user@mail.com",
      "username": "anonymous.user",
      "avatar": 'https://res.cloudinary.com/jesse-dirisu/image/upload/v1569184517/Mask_Group_4_A12_Group_18_pattern.png',
      "points": 0,
      "telephone": "+234 910 001 5617",
      "isMember": false,
    });
    Future.delayed(Duration(milliseconds: 300),
        () => Navigator.pushReplacementNamed(context, '/login'));
  }

  onAppInitCallBack(State state, context) {
    LocalStorage.getItem("isPrevUser").then((prevUser) {
      if (prevUser) {
        LocalStorage.getItem("activeUser").then((val) {
          if (val != null && val is Map) {
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
      rebuildStates(ids: ["authState", "avatarState", "avatarState1", "memberState", "memberState1"]);
    }).catchError((err) {
      final data = User.fromJson(usrData);
      isLoggedIn = !(data.id == "5b3a2ddbdfecff00149ab29c");
      activeUser = data;
      rebuildStates(ids: ["authState", "avatarState", "avatarState1", "memberState", "memberState1"]);
    });
  }

  Future<bool> updateUser(State state, Map<String, dynamic> data) {
    print(data);
    isUpdating = true;
    rebuildStates(states: [state], ids: ["authState", "profState"]);
    return Future.value(
      HttpService.updateProfile(data, activeUser.id).then((val) {
        if (!(val is int)) {
          val = val is Map<String, dynamic> ? val : val[0];
          setActiveUser(val);
          isUpdating = false;
          rebuildStates(states: [state], ids: ["authState", "profState"]);
          return Future.value(true);
        } else {
          isUpdating = false;
          rebuildStates(states: [state], ids: ["authState", "profState"]);
          return Future.value(false);
        }
      }).catchError((err) {
        isUpdating = false;
        rebuildStates(states: [state], ids: ["authState", "profState"]);
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

  Future<bool> login(String username, String password) {
    isLoading = true;
    loginFail = false;
    rebuildStates(ids: ["authFloatBtnState", "authLogState"]);
    return Future.value(
      HttpService.login(username, password).then((val) {
        if (!(val is int) && val is Map<String, dynamic>) {
          setActiveUser(val);
          isLoading = false;
          isLoggedIn = true;
          loginFail = false;
          logUsrName.clear();
          rebuildStates(ids: ["authFloatBtnState", "authLogState"]);
          return Future.value(true);
        } else {
          isLoading = false;
          loginFail = true;
          rebuildStates(ids: ["authFloatBtnState", "authLogState"]);
          return Future.value(false);
        }
      }).catchError((err) {
        isLoading = false;
        loginFail = true;
        rebuildStates(ids: ["authFloatBtnState", "authLogState"]);
        return Future.value(false);
      }),
    );
  }

  Future<bool> signUp(String username, String name, String password, bool isMember) {
    isLoading = true;
    loginFail = false;
    rebuildStates(ids: ["authFloatBtnState", "authRegState"]);
    return Future.value(
      HttpService.signup(username, name, password, isMember).then((val) {
        if (!(val is int) && val is Map<dynamic, dynamic>) {
          setActiveUser(val);
          isLoading = false;
          isLoggedIn = true;
          loginFail = false;
          signName.clear();
          signUsrName.clear();
          rebuildStates(ids: ["authFloatBtnState", "authRegState"]);
          return Future.value(true);
        } else {
          isLoading = false;
          loginFail = true;
          rebuildStates(ids: ["authFloatBtnState", "authRegState"]);
          return Future.value(false);
        }
      }).catchError((err) {
        isLoading = false;
        loginFail = true;
        rebuildStates(ids: ["authFloatBtnState", "authRegState"]);
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

  makeMember() {
    isUpdating = true;
    rebuildStates(ids: ["memberState", "memberState1"]);
    return Future.value(
      HttpService.updateProfile({"isMember": true}, activeUser.id).then((val) {
        if (!(val is int)) {
          val = val is Map<String, dynamic> ? val : val[0];
          setActiveUser(val);
          isUpdating = false;
          rebuildStates(ids: ["memberState", "memberState1"]);
          return Future.value(true);
        } else {
          isUpdating = false;
          rebuildStates(ids: ["memberState", "memberState1"]);
          return Future.value(false);
        }
      }).catchError((err) {
        isUpdating = false;
        rebuildStates(ids: ["memberState", "memberState1"]);
        return Future.value(false);
      }),
    );
  }

  Future getImage(TargetPlatform platform, [isGal = false]) async {
    bool isPermitted = true;
    if (!isGal) {
      PermissionStatus permitStorage = platform == TargetPlatform.android
          ? await _permissionHandler
              .checkPermissionStatus(PermissionGroup.storage)
          : true;
      PermissionStatus permitCam = await _permissionHandler
          .checkPermissionStatus(PermissionGroup.camera);
      isPermitted = (permitCam != null && permitStorage != null)
          ? ((permitCam == PermissionStatus.granted) &&
              (permitCam == PermissionStatus.granted))
          : false;
    }
    if (isPermitted != null && isPermitted == true) {
      var imageData = await ImagePicker.pickImage(
          source: isGal ? ImageSource.gallery : ImageSource.camera);
      if (imageData != null) {
        tempAvatar = imageData;
        isChangingAvatar = true;
        rebuildStates(ids: ["avatarState", "avatarState1"]);
        final tmpDir = await fs.getTemporaryDirectory();
        CompressObject fileData = CompressObject(
          imageFile: imageData,
          path: tmpDir.path,
          // quality: 50,
          // step: 4
        );
        final compFilePath = await Luban.compressImage(fileData);
        if (compFilePath != null) {
          changeAvatar(
              avatar: base64Encode(File(compFilePath).readAsBytesSync()));
        } else {
          isChangingAvatar = false;
          tempAvatar = null;
          rebuildStates(ids: ["avatarState", "avatarState1"]);
        }
      }
    }
  }

  changeAvatar({String avatar}) {
    isChangingAvatar = true;
    rebuildStates(ids: ["avatarState", "avatarState1"]);
    return Future.value(
      HttpService.updateProfile(
        {"avatar": avatar, "isImg": true, "name": activeUser.username},
        activeUser.id,
      ).then((val) {
        if (!(val is int)) {
          val = val is Map<String, dynamic> ? val : val[0];
          setActiveUser(val);
          isChangingAvatar = false;
          activeUser.avatar = val["avatar"];
          tempAvatar = null;
          rebuildStates(ids: ["avatarState", "avatarState1"]);
          return Future.value(true);
        } else {
          tempAvatar = null;
          isChangingAvatar = false;
          rebuildStates(ids: ["avatarState", "avatarState1"]);
          return Future.value(false);
        }
      }).catchError((err) {
        isChangingAvatar = false;
        tempAvatar = null;
        rebuildStates(ids: ["avatarState", "avatarState1"]);
        return Future.value(false);
      }),
    );
  }
}
