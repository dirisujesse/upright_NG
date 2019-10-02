import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'post.dart';
import 'comment.dart';
import '../services/storage_service.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String name;
  String username;
  String telephone;
  String city;
  String state;
  String country;
  String avatar = 'https://res.cloudinary.com/jesse-dirisu/image/upload/v1569184517/Mask_Group_4_A12_Group_18_pattern.png';
  List<Post> posts;
  int postCount;
  int points = 0;
  List<Comment> comments;
  String email;
  bool isMember;
  String password;
  String gender;

  User({
    @required this.name,
    @required this.id,
    @required this.username,
    this.points,
    this.city,
    this.state,
    this.country,
    this.avatar,
    this.posts = const[],
    this.postCount,
    this.comments = const[],
    this.telephone,
    this.email,
    this.isMember,
    this.password,
    this.gender,
  });

  Future<bool> logOut() async {
    final status = await LocalStorage.removeItem("userData");
    return status;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
