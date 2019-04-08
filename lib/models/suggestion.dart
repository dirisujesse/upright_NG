import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

// import '../services/storage_service.dart';
part 'suggestion.g.dart';

@JsonSerializable()
class Suggestion {
  String id;
  String contributor;
  String email;
  String subject;
  String suggestion;

  Suggestion({
    this.id,
    @required this.contributor,
    @required this.email,
    @required this.subject,
    @required this.suggestion,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => _$SuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestionToJson(this);
}
