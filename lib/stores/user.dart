import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Upright_NG/styles/colors.dart';
import 'package:image_cropper/image_cropper.dart';
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
    email: "",
    username: "anonymous.user",
    avatar:
        'https://res.cloudinary.com/jesse-dirisu/image/upload/v1569184517/Mask_Group_4_A12_Group_18_pattern.png',
    telephone: "",
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

  Future<File> _cropImage(File imageFile) async {
    if (imageFile.existsSync()) {
      return ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Profile Picture',
          toolbarColor: appGreen,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        cropStyle: CropStyle.rectangle,
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
    }
    return Future.value(null);
  }

  toggleEdit(State state) {
    isEdit = !isEdit;
    rebuildStates(ids: ["profState"], states: [state]);
  }

  logout(BuildContext context) {
    setActiveUser({
      "name": "Anonymous User",
      "id": "5b3a2ddbdfecff00149ab29c",
      "email": "",
      "username": "anonymous.user",
      "avatar":
          'https://res.cloudinary.com/jesse-dirisu/image/upload/v1569184517/Mask_Group_4_A12_Group_18_pattern.png',
      "points": 0,
      "telephone": "",
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
          Navigator.pushReplacementNamed(context, "/home");
        });
      } else {
        Navigator.pushReplacementNamed(context, "/welcome");
      }
    }).catchError((err) {
      Navigator.pushReplacementNamed(context, "/welcome");
    });
  }

  void updatePoints({int points = 0}) {
    if (points != 0) {
      Map<String, dynamic> usrMap = activeUser.toJson();
      usrMap.containsKey("points")
          ? usrMap.update("points", (val) => points)
          : usrMap.putIfAbsent("points", () => points);
      setActiveUser(usrMap);
    }
  }

  setActiveUser(Map<String, dynamic> usrData) {
    LocalStorage.setItem("activeUser", usrData).then((val) {
      final data = User.fromJson(usrData);
      isLoggedIn = !(data.id == "5b3a2ddbdfecff00149ab29c");
      activeUser = data;
      rebuildStates(ids: [
        "authState",
        "avatarState",
        "avatarState1",
        "memberState",
        "memberState1"
      ]);
    }).catchError((err) {
      final data = User.fromJson(usrData);
      isLoggedIn = !(data.id == "5b3a2ddbdfecff00149ab29c");
      activeUser = data;
      rebuildStates(ids: [
        "authState",
        "avatarState",
        "avatarState1",
        "memberState",
        "memberState1"
      ]);
    });
  }

  Future<bool> updateUser(State state, Map<String, dynamic> data) {
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
          usrStat = val;
          updatePoints(points: val["points"] ?? 0);
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

  Future<bool> signUp(
      String username, String name, String password, bool isMember) {
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
      HttpService.updateProfile(
              {"isMember": true, "isMembership": true}, activeUser.id)
          .then((val) {
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
      ImagePicker.pickImage(
        source: isGal ? ImageSource.gallery : ImageSource.camera,
        // maxHeight: 500,
        // maxWidth: 500,
      ).then((imageData) {
        print(imageData);
        imageData = imageData ?? null;
        print(imageData.absolute.path);
        if (imageData != null && imageData is File) {
          print(imageData.absolute.path);
          _cropImage(imageData.absolute).then((croppedImg) async {
            print(croppedImg);
            if (croppedImg != null) {
              print(croppedImg.absolute.path);
              tempAvatar = croppedImg ?? imageData;
              isChangingAvatar = true;
              rebuildStates(ids: ["avatarState", "avatarState1"]);
              final tmpDir = await fs.getTemporaryDirectory();
              CompressObject fileData = CompressObject(
                imageFile: croppedImg ?? imageData,
                path: tmpDir.path,
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
            } else {
              isChangingAvatar = false;
              tempAvatar = null;
              rebuildStates(ids: ["avatarState", "avatarState1"]);
            }
          }).catchError((err) => print(err));
        } else {
          isChangingAvatar = false;
          tempAvatar = null;
          rebuildStates(ids: ["avatarState", "avatarState1"]);
        }
      }).catchError((err) => print(err));
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
