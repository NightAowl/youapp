import 'package:flutter/material.dart';

@immutable
abstract class ProfileEvent {}

class CreateProfileEvent extends ProfileEvent {
  final String token;
  final Map<String, dynamic> profileData;

  CreateProfileEvent({
    required this.token,
    required this.profileData,
  });
}

class GetProfileEvent extends ProfileEvent {
  final String token;

  GetProfileEvent({
    required this.token,
  });
}

class UpdateProfileEvent extends ProfileEvent {
  final String token;
  final String name;
  final String birthday;
  final int height;
  final int weight;
  final List<String> interests;

  UpdateProfileEvent({
    required this.token,
    this.name = '',
    this.birthday = '',
    this.height = -1,
    this.weight = -1,
    this.interests = const [],
  });
}
