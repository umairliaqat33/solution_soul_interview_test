import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  String name;
  String email;
  String uid;
  String message;
  String messageId;

  ChatModel({
    required this.email,
    required this.name,
    required this.uid,
    required this.message,
    required this.messageId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
