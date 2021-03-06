import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:path_provider/path_provider.dart' as fs;
import 'package:path/path.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_luban/flutter_luban.dart';
// import 'package:flutter_video_compress/flutter_video_compress.dart';

import '../models/post.dart';
import './user.dart';
import '../services/http_service.dart';

// final vidCompressor = FlutterVideoCompress();

class PostBloc extends StatesRebuilder {
  StreamSubscription<dynamic> feedsPageInitSub;
  StreamSubscription<dynamic> recFeedsFetchSub;
  StreamSubscription<dynamic> feedPageInitSub;
  StreamSubscription<dynamic> commentsSub;
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
  static PostBloc instance;
  List<dynamic> results = [];
  bool isLoading = false;
  bool isSubmitingPost = false;
  bool isSubmitted = false;
  bool isLoadingPost = false;
  bool isLoadingComments = false;
  bool isFail = false;
  bool failed = false;
  bool isFetching = false;
  bool showComments = false;
  List<dynamic> comments;
  Post post;
  List<dynamic> posts = [];
  List<dynamic> testimonials = [];

  static PostBloc getInstance() {
    if (instance == null) {
      instance = PostBloc();
    }
    return instance;
  }

  Future<bool> addPost(Map<String, dynamic> postData, PostBloc instance) async {
    isSubmitingPost = true;
    isSubmitted = false;
    rebuildStates(ids: ["postCreateState"]);
    if (instance.isImg && instance.image != null) {
      String compFilePath;
      if (instance.image.lengthSync() > 100000) {
        final tmpDir = await fs.getTemporaryDirectory();
        CompressObject fileData = CompressObject(
          imageFile: instance.image,
          path: tmpDir.path,
          // quality: 50,
          // step: 4
        );
        compFilePath = await Luban.compressImage(fileData);
      }
      if (compFilePath != null || instance.image != null) {
        postData["img"] = base64Encode(File(compFilePath ?? instance.image.path).readAsBytesSync());
      } else {
        postData["img"] = "";
      }
    }

    // if (instance.isVid &&
    //     instance.video != null &&
    //     (instance.video.lengthSync() / 1000000) > 2.0) {
    //   FlutterVideoCompress compressor = FlutterVideoCompress();
    //   final compFilePath = await compressor.compressVideo(path: instance.video.absolute.path);
    //   if (compFilePath != null) {
    //     final file = File(compFilePath);
    //     postData["img"] = base64Encode(file.readAsBytesSync());
    //   } else {
    //     postData["img"] = "";
    //   }
    // }

    return Future.value(
      HttpService.addPost(postData).then(
        (val) {
          if (!(val is int)) {
            isSubmitingPost = false;
            isSubmitted = true;
            final hasAuthor = val is Map<String, dynamic> &&
                val.containsKey("author") &&
                val["author"] is Map<String, dynamic> &&
                val["author"].containsKey("points");

            usrData.updatePoints(
                points: hasAuthor ? val["author"]["points"] : 0);
            if (!hasAuthor) {
              val["author"] = usrData.activeUser.toJson();
            }
            posts.insert(0, val);
            rebuildStates(ids: ["postCreateState", "recPostState"]);
            return Future.value(true);
          } else {
            isSubmitingPost = false;
            isSubmitted = false;
            rebuildStates(ids: ["postCreateState"]);
            return Future.value(false);
          }
        },
      ).catchError(
        (err) {
          isSubmitingPost = false;
          isSubmitted = false;
          rebuildStates(ids: ["postCreateState"]);
          return Future.value(false);
        },
      ),
    );

    // isSubmitingPost = false;
    // rebuildStates(ids: ["postCreateState"]);
    // return Future.value(false);
  }

  loadComments(String postId) {
    isLoadingComments = true;
    comments = [];
    showComments = true;
    rebuildStates(ids: ["postComState", "postComState1"]);
    commentsSub = HttpService.getComments(postId).asStream().listen(
      (val) {
        if (!(val is int)) {
          isLoadingComments = false;
          comments = val;
          rebuildStates(ids: ["postComState", "postComState1"]);
        } else {
          isLoadingComments = false;
          rebuildStates(ids: ["postComState", "postComState1"]);
        }
      },
      onError: (err) {
        isLoadingComments = false;
        rebuildStates(ids: ["postComState", "postComState1"]);
      },
    );
  }

  vote([bool up = true]) {
    if (up) {
      HttpService.upVote(true, post.id).then((val) {
        if (!(val is int)) {
          post.upvotes += 1;
          rebuildStates(ids: ["postDetState"]);
        }
      }).catchError((onError) => print(onError));
    } else {
      HttpService.upVote(true, post.id, 'downVote').then((val) {
        if (!(val is int)) {
          post.downvotes += 1;
          rebuildStates(ids: ["postDetState"]);
        }
      }).catchError((onError) => print(onError));
    }
  }

  getCached(State state, String id) {
    var postCache = posts.where((val) => val.id == id).toList();
    if (postCache.length > 0) {
      isLoadingPost = false;
      post = Post.fromJson(postCache[0]);
      rebuildStates(states: [state], ids: ["postDetState"]);
    }
  }

  getPost(State state, String id) {
    isLoadingPost = true;
    post = null;
    showComments = false;
    isLoadingComments = false;
    comments = null;
    rebuildStates(states: [state], ids: ["postDetState"]);
    feedPageInitSub = HttpService.getPost(id).asStream().listen(
      (val) {
        if (!(val is int)) {
          isLoadingPost = false;
          post = Post.fromJson(val);
          rebuildStates(states: [state], ids: ["postDetState"]);
        } else {
          getCached(state, id);
        }
      },
      onError: (err) {
        getCached(state, id);
      },
    );
  }

  loadNew() {
    if (posts != null && posts.length > 0) {
      isFetching = true;
      rebuildStates(ids: ["recPostState"]);
      recFeedsFetchSub =
          HttpService.getPostRange(posts.length, posts.length + 20)
              .asStream()
              .listen(
        (val) {
          if (!(val is int)) {
            if (val.length > 0) {
              posts.addAll(val);
              rebuildStates(ids: ["recPostState"]);
            }
          }
          isFetching = false;
          rebuildStates(ids: ["recPostState"]);
        },
        onError: (err) {
          isFetching = false;
          rebuildStates(ids: ["recPostState"]);
        },
      );
    }
  }

  getFeed(State state, [bool disallowIfLoading = false]) {
    if (disallowIfLoading && (isLoading == true)) {
      return;
    }
    isLoading = true;
    rebuildStates(states: [state]);
    feedsPageInitSub = Future.wait([
      HttpService.getPosts(),
      HttpService.getTestimonials(),
    ]).asStream().listen(
      (val) {
        if (val.length > 0) {
          isLoading = false;
          failed = false;
          posts = val[0] is int ? [] : val[0];
          testimonials = val[1] is int ? [] : val[1];
          rebuildStates(states: [state]);
        } else {
          isLoading = false;
          failed = true;
          rebuildStates(states: [state]);
        }
      },
      onError: (error) {
        isLoading = false;
        failed = true;
        rebuildStates(states: [state]);
      },
    );
  }

  Future<bool> addComment(String body) {
    final data = {
      "body": body,
      "post": post.id,
      "author": usrData.activeUser.id
    };

    return Future.value(
      HttpService.addComment(data).then((val) {
        print(val);
        if (!(val is int)) {
          comments = comments ?? [];
          comments.add(val);
          rebuildStates(ids: ["postComState", "postComState1"]);
          return Future.value(true);
        }
        return Future.value(true);
      }).catchError((onError) => Future.value(false)),
    );
  }

  searchPosts(String query) {
    isLoading = true;
    results = [];
    isFail = false;
    rebuildStates(ids: ["postSearchState"]);
    HttpService.searchPost(query).then((val) {
      if (!(val is int)) {
        results = val;
        isLoading = false;
        rebuildStates(ids: ["postSearchState"]);
      } else {
        results = [];
        isLoading = false;
        isFail = true;
        rebuildStates(ids: ["postSearchState"]);
      }
    }).catchError((err) {
      results = [];
      isLoading = false;
      isFail = true;
      rebuildStates(ids: ["postSearchState"]);
    });
  }

  disposeFeeds() {
    if (feedsPageInitSub != null) {
      feedsPageInitSub.cancel();
    }
    if (recFeedsFetchSub != null) {
      recFeedsFetchSub.cancel();
    }
  }

  disposeFeed() {
    if (feedPageInitSub != null) {
      feedPageInitSub.cancel();
    }
    if (commentsSub != null) {
      commentsSub.cancel();
    }
    comments = null;
  }

  activateRecord(TargetPlatform platform) {
    showRecWidget = true;
    recUsedTime = '00:00';
    rebuildStates(ids: ["postRecBtnState"]);
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
    isSubmitingPost = false;
    isSubmitted = false;
  }

  Future recAudio(TargetPlatform platform) async {
    if (!isRecording) {
      isRecording = true;
      rebuildStates(ids: ["postRecBtnState"]);
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
        rebuildStates(ids: ["postMediaState"]);
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
          rebuildStates(ids: ["postRecBtnState"]);
          if (pos >= 1.0) {
            stopRecAudio();
          }
        });
      } else {
        await _permissionHandler.requestPermissions(
            [PermissionGroup.microphone, PermissionGroup.storage]);
        showRecWidget = false;
        isRecording = false;
        rebuildStates(ids: ["postRecBtnState"]);
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
    rebuildStates(ids: ["postMediaState", "postRecBtnState"]);
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
            source: isGal ? ImageSource.gallery : ImageSource.camera,
            // maxHeight: 500,
            // maxWidth: 500,
          ) ??
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
      rebuildStates(ids: ["postMediaState"]);
    } else {
      await _permissionHandler.requestPermissions(
          [PermissionGroup.camera, PermissionGroup.storage]);
      rebuildStates(ids: ["postMediaState"]);
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
            source: isGal ? ImageSource.gallery : ImageSource.camera,
          ) ??
          video;

      if (vid != null) {
        isImg = false;
        isAud = false;
        video = vid;
        isVid = true;
        image = null;
        audio = null;
        isRecording = false;
        rebuildStates(ids: ["postMediaState"]);
      }
    } else {
      await _permissionHandler.requestPermissions(
          [PermissionGroup.camera, PermissionGroup.storage]);
      rebuildStates(ids: ["postMediaState"]);
    }
  }
}
