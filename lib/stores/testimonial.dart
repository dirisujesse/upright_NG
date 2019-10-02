import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:Upright_NG/models/testimonial.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:path_provider/path_provider.dart' as fs;
import 'package:path/path.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_luban/flutter_luban.dart';

import '../models/testimonial.dart';
import './user.dart';
import '../services/http_service.dart';

class TestimonialBloc extends StatesRebuilder {
  final usrData = UserBloc.getInstance();
  final FlutterSound recorder = FlutterSound();
  final PermissionHandler _permissionHandler = PermissionHandler();
  Timer interval;
  var _recorderObserver;
  double pos = 0;
  bool isVid = false;
  bool isAud = false;
  bool isImg = false;
  bool isRecording = false;
  bool showRecWidget = false;
  String recUsedTime = '00:00';
  String audioPath;
  File image;
  File video;
  File audio;
  static TestimonialBloc instance;
  List<dynamic> results = [];
  bool isLoading = false;
  bool loadFail = false;
  bool isSubmitingTestimonial = false;
  bool isSubmitted = false;
  bool submitFail = false;
  bool isFetching = false;
  bool showComments = false;
  List<dynamic> comments;
  Testimonial testimonial;
  List<dynamic> testimonials = [];

  static TestimonialBloc getInstance() {
    if (instance == null) {
      instance = TestimonialBloc();
    }
    return instance;
  }

  void fetchTestimonials({
    @required State state,
    @required BuildContext context,
    skip = 0,
    limit = 10,
  }) async {
    isLoading = true;
    rebuildStates(states: [state], ids: ["tmnState"]);
    HttpService.getTestimonials(skip: skip, limit: limit).then(
      (val) async {
        if (val is int) {
          loadFail = true;
          isLoading = false;
          rebuildStates(states: [state], ids: ["tmnState"]);
        } else {
          testimonials = val;
          loadFail = false;
          isLoading = false;
          rebuildStates(states: [state], ids: ["tmnState"]);
        }
      },
      onError: (err) async {
        loadFail = true;
        isLoading = false;
        rebuildStates(states: [state], ids: ["tmnState"]);
      },
    );
  }

  Future<bool> addTestimonial(
      Map<String, dynamic> testimonialData, TestimonialBloc instance) async {
    isSubmitingTestimonial = true;
    isSubmitted = false;
    rebuildStates(ids: ["testimonialCreateState"]);
    testimonialData["author"] = usrData.activeUser.id;
    testimonialData["mediaType"] =
        instance.isAud ? "audio" : instance.isImg ? "image" : "video";
    if (instance.isImg &&
        instance.image != null &&
        instance.image.lengthSync() > 100000) {
      final tmpDir = await fs.getTemporaryDirectory();
      CompressObject fileData = CompressObject(
        imageFile: instance.image,
        path: tmpDir.path,
      );
      final compFilePath = await Luban.compressImage(fileData);
      if (compFilePath != null) {
        testimonialData["media"] =
            base64Encode(File(compFilePath).readAsBytesSync());
      } else {
        testimonialData["media"] = "";
      }
    }

    return Future.value(
      HttpService.addTestimonial(testimonialData).then(
        (val) {
          if (!(val is int)) {
            isSubmitingTestimonial = false;
            isSubmitted = true;
            final hasAuthor = val is Map<String, dynamic> &&
                val.containsKey("author") &&
                val["author"] is Map<String, dynamic> &&
                val["author"].containsKey("points");
            usrData.updatePoints(
                points: hasAuthor ? val["author"]["points"] : 0);
            rebuildStates(ids: ["testimonialCreateState"]);
            return Future.value(true);
          } else {
            isSubmitingTestimonial = false;
            isSubmitted = false;
            rebuildStates(ids: ["testimonialCreateState"]);
            return Future.value(false);
          }
        },
      ).catchError(
        (err) {
          isSubmitingTestimonial = false;
          isSubmitted = false;
          rebuildStates(ids: ["testimonialCreateState"]);
          return Future.value(false);
        },
      ),
    );
  }

  activateRecord(TargetPlatform platform) {
    showRecWidget = true;
    recUsedTime = '00:00';
    rebuildStates(ids: ["testimonialRecBtnState"]);
    recAudio(platform);
  }

  reset() {
    image = null;
    video = null;
    audio = null;
    isImg = false;
    isAud = false;
    isVid = false;
    recUsedTime = '00:00';
    isRecording = false;
    showRecWidget = false;
    audioPath = null;
    isSubmitingTestimonial = false;
    isSubmitted = false;
  }

  Future recAudio(TargetPlatform platform) async {
    if (!isRecording) {
      isRecording = true;
      rebuildStates(ids: ["testimonialRecBtnState"]);
      bool isPermitted;
      PermissionStatus permitAud = await _permissionHandler
          .checkPermissionStatus(PermissionGroup.microphone);
      PermissionStatus permitStorage = platform == TargetPlatform.android
          ? await _permissionHandler
              .checkPermissionStatus(PermissionGroup.storage)
          : true;
      isPermitted = (permitAud != null && permitStorage != null)
          ? ((permitAud == PermissionStatus.granted) &&
              (permitStorage == PermissionStatus.granted))
          : false;
      if (isPermitted != null && isPermitted == true) {
        image = null;
        video = null;
        audio = null;
        isImg = false;
        isAud = false;
        audioPath = null;
        isVid = false;
        rebuildStates(ids: ["testimonialMediaState"]);
        int progress = 0;
        int seconds = 0;
        int minutes = 0;

        final recordingPath = await fs.getApplicationDocumentsDirectory();
        audioPath = await recorder.startRecorder(
            join(recordingPath.path, DateTime.now().toIso8601String()));

        _recorderObserver = recorder.onRecorderStateChanged.listen((e) {});
        interval = Timer.periodic(Duration(seconds: 1), (duration) {
          progress += 1;
          seconds += 1;
          if (seconds == 59) {
            seconds = 0;
            minutes += 1;
          }
          pos = progress / (60 * 5);
          recUsedTime = '0$minutes:$seconds';
          rebuildStates(ids: ["testimonialRecBtnState"]);
          if (pos >= 1.0) {
            stopRecAudio();
          }
        });
      } else {
        await _permissionHandler.requestPermissions(
            [PermissionGroup.microphone, PermissionGroup.storage]);
        showRecWidget = false;
        isRecording = false;
        rebuildStates(ids: ["testimonialRecBtnState"]);
      }
    }
  }

  Future stopRecAudio() async {
    await recorder.stopRecorder();
    if (_recorderObserver != null) {
      _recorderObserver.cancel();
    }
    _recorderObserver = null;
    showRecWidget = false;
    if (interval != null) {
      interval.cancel();
    }
    recUsedTime = '00:00';
    isRecording = false;
    isVid = false;
    isImg = false;
    image = null;
    video = null;
    audio = File(audioPath);
    isAud = true;
    pos = 0;
    rebuildStates(ids: ["testimonialMediaState", "testimonialRecBtnState"]);
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
      reset();
      var imageData = await ImagePicker.pickImage(
              source: isGal ? ImageSource.gallery : ImageSource.camera) ??
          image;

      if (imageData != null) {
        isAud = false;
        isVid = false;
        image = imageData;
        video = null;
        audio = null;
        isImg = true;
        isRecording = false;
      }
      rebuildStates(ids: ["testimonialMediaState"]);
    } else {
      await _permissionHandler.requestPermissions(
          [PermissionGroup.camera, PermissionGroup.storage]);
      rebuildStates(ids: ["testimonialMediaState"]);
    }
  }

  Future getVideo(TargetPlatform platform, [isGal = false]) async {
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
      reset();

      var vid = await ImagePicker.pickVideo(
              source: isGal ? ImageSource.gallery : ImageSource.camera) ??
          video;

      if (vid != null) {
        isImg = false;
        isAud = false;
        video = vid;
        isVid = true;
        image = null;
        audio = null;
        isRecording = false;
        rebuildStates(ids: ["testimonialMediaState"]);
      }
    } else {
      await _permissionHandler.requestPermissions(
          [PermissionGroup.camera, PermissionGroup.storage]);
      rebuildStates(ids: ["testimonialMediaState"]);
    }
  }
}
