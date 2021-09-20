import 'dart:convert';

import 'package:prototype2021/model/safe_http_dto/base.dart';
import 'package:prototype2021/model/safe_http_dto/patch/heart.dart';
import 'package:prototype2021/model/safe_http_dto/post/signup.dart';
import 'package:prototype2021/model/safe_http_dto/get/verification.dart';
import 'package:prototype2021/model/safe_http_dto/post/authentication.dart';
import 'package:prototype2021/model/safe_http_dto/post/login.dart';

final factories = <Type, SafeHttpDataOutput Function(Map<String, dynamic>)>{
  AuthOutput: (Map<String, dynamic> json) => AuthOutput.fromJson(json: json),
  AuthVerificationOutput: (Map<String, dynamic> json) =>
      AuthVerificationOutput.fromJson(json: json),
  IdVerificationOutput: (Map<String, dynamic> json) =>
      IdVerificationOutput.fromJson(json: json),
  SignupOutput: (Map<String, dynamic> json) =>
      SignupOutput.fromJson(json: json),
  LoginOutput: (Map<String, dynamic> json) => LoginOutput.fromJson(json: json),
  PlanHeartOutput: (Map<String, dynamic> _) => PlanHeartOutput.fromJson(),
  ContentsHeartOutput: (Map<String, dynamic> _) =>
      ContentsHeartOutput.fromJson(),
};

T generateOutput<T extends SafeHttpDataOutput>(String jsonString) {
  return factories[T]!(jsonDecode(jsonString)) as T;
}
