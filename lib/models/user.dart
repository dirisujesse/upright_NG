import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'post.dart';
import 'comment.dart';
import '../services/storage_service.dart';

part 'user.g.dart';
@JsonSerializable()
class User {
  String name;
  String username;
  String city;
  String state;
  String country;
  String avatar;
  List<Post> posts;
  int postCount;
  List<Comment> comments;
  String email;

  User({
    @required this.name,
    @required this.username,
    this.city,
    this.state,
    this.country,
    this.avatar = 'https://www.gravatar.com/avatar',
    this.posts,
    this.postCount,
    this.comments,
    this.email
  });

  Future<String> logOut() async {
    final status = await Store.removeItem("userData");
    return status;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

mixin UserModel on Model {
  User user;
  bool isLoggedIn = false;
}