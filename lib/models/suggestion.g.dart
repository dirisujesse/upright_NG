// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Suggestion _$SuggestionFromJson(Map<String, dynamic> json) {
  return Suggestion(
      id: json['id'] as String,
      contributor: json['contributor'] as String,
      email: json['email'] as String,
      subject: json['subject'] as String,
      suggestion: json['suggestion'] as String);
}

Map<String, dynamic> _$SuggestionToJson(Suggestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contributor': instance.contributor,
      'email': instance.email,
      'subject': instance.subject,
      'suggestion': instance.suggestion
    };
