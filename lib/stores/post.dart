import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:path_provider/path_provider.dart' as fs;
import 'package:path/path.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/post.dart';
import './user.dart';
import '../services/http_service.dart';

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
  bool isLoadingPost = false;
  bool isLoadingComments = false;
  bool isFail = false;
  bool failed = false;
  bool isFetching = false;
  bool showComments = false;
  List<dynamic> comments;
  Post post;
  List<dynamic> posts = [];
  List<dynamic> fposts = [];
  List<dynamic> tposts = [];

  static PostBloc getInstance() {
    if (instance == null) {
      instance = PostBloc();
    }
    return instance;
  }

  Future<bool> addPost(Map<String, dynamic> postData) {
    isSubmitingPost = true;
    rebuildStates(ids: ["postCreateState"]);
    return Future.value(
      HttpService.addPost(postData).then(
        (val) {
          if (!(val is int)) {
            print(val);
            isSubmitingPost = false;
            rebuildStates(ids: ["postCreateState"]);
            return Future.value(true);
          } else {
            print(val);
            isSubmitingPost = false;
            rebuildStates(ids: ["postCreateState"]);
            return Future.value(false);
          }
        },
      ).catchError(
        (err) {
          print(err + " ");
          isSubmitingPost = false;
          rebuildStates(ids: ["postCreateState"]);
          return Future.value(false);
        },
      ),
    );
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
    } else {
      postCache = tposts.where((val) => val.id == id).toList();
      if (postCache.length > 0) {
        isLoadingPost = false;
        post = Post.fromJson(postCache[0]);
        rebuildStates(states: [state], ids: ["postDetState"]);
      } else {
        postCache = fposts.where((val) => val.id == id).toList();
        if (postCache.length > 0) {
          isLoadingPost = false;
          post = Post.fromJson(postCache[0]);
          rebuildStates(states: [state], ids: ["postDetState"]);
        } else {
          isLoadingPost = false;
          rebuildStates(states: [state], ids: ["postDetState"]);
        }
      }
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
    isFetching = true;
    rebuildStates(ids: ["recPostState"]);
    recFeedsFetchSub = HttpService.getPostRange(posts.length, posts.length + 20)
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
        print(err);
        isFetching = false;
        rebuildStates(ids: ["recPostState"]);
      },
    );
  }

  getFeed(State state) {
    isLoading = true;
    rebuildStates(states: [state]);
    feedsPageInitSub = Future.wait([
      HttpService.getPosts(),
      HttpService.getFeaturedPosts(),
      HttpService.getTrendingPosts()
    ]).asStream().listen(
      (val) {
        if (val.length > 0) {
          isLoading = false;
          failed = false;
          posts = val[0] is int ? [] : val[0];
          fposts = val[1] is int ? [] : val[1];
          tposts = val[2] is int ? [] : val[2];
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
        if (!(val is int)) {
          if (comments != null) {
            comments.add(val);
            rebuildStates(ids: ["postComState", "postComState1"]);
            return Future.value(true);
          }
          return Future.value(false);
        }
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
    rebuildStates(ids: ["postMediaState", "postRecBtnState"]);
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
      final imageData = await ImagePicker.pickImage(
              source: isGal ? ImageSource.gallery : ImageSource.camera) ??
          image;

      if (imageData != null) {
        print("ok");
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
      print("checking permissions");
    }
    if (isPermitted != null && isPermitted == true) {
      reset();

      var vid = await ImagePicker.pickVideo(
              source: isGal ? ImageSource.gallery : ImageSource.camera) ??
          video;

      if (vid != null) {
        var saiz = await vid.length();
        print("file is ${saiz / 1000000} mb");
        if ((saiz / 1000000) > 4.0) {
          vid = null;
        }
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
      }
    } else {
      await _permissionHandler.requestPermissions(
          [PermissionGroup.camera, PermissionGroup.storage]);
      rebuildStates(ids: ["postMediaState"]);
    }
  }
}
