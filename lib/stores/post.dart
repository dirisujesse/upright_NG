import 'dart:async';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../models/post.dart';
import './user.dart';
import '../services/http_service.dart';

class PostBloc extends StatesRebuilder {
  final usrData = UserBloc.getInstance();
  static PostBloc instance;
  List<dynamic> results = [];
  bool isLoading = false;
  bool isLoadingPost = false;
  bool isLoadingComments = false;
  bool isFail = false;
  bool failed = false;
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

  loadComments(String postId) {
    isLoadingComments = true;
    comments = [];
    showComments = true;
    rebuildStates(ids: ["postComState", "postComState1"]);
    HttpService.getComments(postId).then((val) {
      if (!(val is int)) {
        isLoadingComments = false;
        comments = val;
        rebuildStates(ids: ["postComState", "postComState1"]);
      } else {
        isLoadingComments = false;
        rebuildStates(ids: ["postComState", "postComState1"]);
      }
    }).catchError((err) {
      isLoadingComments = false;
      rebuildStates(ids: ["postComState", "postComState1"]);
    });
  }

  vote([bool up = true]) {
    if (up) {
      HttpService.upVote(true, post.id)
        .then((val) {
          if (!(val is int)) {
            post.upvotes += 1;
            rebuildStates(ids: ["postDetState"]);
          }
        }).catchError((onError) => print(onError));
    } else {
      HttpService.upVote(true, post.id, 'downVote')
        .then((val) {
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
    HttpService.getPost(id).then((val) {
      if (!(val is int)) {
        isLoadingPost = false;
        post = Post.fromJson(val);
        rebuildStates(states: [state], ids: ["postDetState"]);
      } else {
        getCached(state, id);
      }
    }).catchError((err) {
      getCached(state, id);
    });
  }

  loadNew(State state) {
    print("object");
    HttpService.getPostRange(posts.length, posts.length + 20).then((val) {
      if (!(val is int)) {
        posts.addAll(val);
        rebuildStates(states: [state]);
      }
    }).catchError((err) => "");
  }

  Future<dynamic> getFeed(State state) {
    isLoading = true;
    rebuildStates(states: [state]);
    return Future.wait([
      HttpService.getPosts(),
      HttpService.getFeaturedPosts(),
      HttpService.getTrendingPosts()
    ]).then((val) {
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
    }).catchError((error) {
      isLoading = false;
      failed = true;
      rebuildStates(states: [state]);
    });
  }

  Future<bool> addComment(String body) {
    final data = {
      "body": body,
      "post": post.id,
      "author": usrData.activeUser.id
    };

    return Future.value(
      HttpService.addComment(data)
      .then((val) {
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
}
