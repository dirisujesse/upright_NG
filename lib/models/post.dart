import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user.dart';
import 'comment.dart';
// import '../services/storage_service.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  String id;
  String title;
  bool anonymous;
  String body;
  bool featured;
  User author;
  bool hasVideo;
  int upvotes;
  int downvotes;
  String time;
  double long;
  double lat;
  String loc;
  List<Comment> comments;
  bool fromTwitter;
  List<dynamic> urls;
  String image;

  Post({
    @required this.id,
    @required this.title,
    @required this.anonymous,
    @required this.body,
    @required this.featured,
    @required this.author,
    this.hasVideo,
    this.upvotes,
    this.downvotes,
    this.time,
    this.long,
    this.lat,
    this.loc,
    this.comments,
    this.fromTwitter,
    this.urls,
    this.image = "https://4.bp.blogspot.com/-i_6lnKy8NU4/WCRylC1DQrI/AAAAAAAANnk/kTX9v5v32XMHuJ70c8Ms_e3cZo5T18gywCLcB/s1600/default-thumbnail.png",
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
