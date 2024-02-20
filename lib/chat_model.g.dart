// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      email: json['email'] as String,
      name: json['name'] as String,
      uid: json['uid'] as String,
      message: json['message'] as String,
      messageId: json['messageId'] as String,
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'uid': instance.uid,
      'message': instance.message,
      'messageId': instance.messageId,
    };
