import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/you_app_api/profile_api.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileApi _profileApi;

  ProfileBloc(this._profileApi) : super(ProfileInitial()) {
    on<CreateProfileEvent>(_handleCreateProfile);
    on<GetProfileEvent>(_handleGetProfile);
    on<UpdateProfileEvent>(_handleUpdateProfile);
  }

  Future<void> _handleCreateProfile(
    CreateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final response = await _profileApi.createProfile(
        event.token,
        event.profileData,
      );

      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        emit(ProfileSuccess(data));
      } else {
        emit(ProfileFailure('Profile creation failed'));
      }
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _handleGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final response = await _profileApi.getProfile(event.token);

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(ProfileSuccess(data));
      } else {
        emit(ProfileFailure('Failed to fetch profile'));
      }
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _handleUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final response = await _profileApi.updateProfile(
        token: event.token,
        name: event.name,
        birthday: event.birthday,
        height: event.height,
        weight: event.weight,
        interests: event.interests,
      );

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(ProfileSuccess(data));
      } else {
        emit(ProfileFailure('Profile update failed'));
      }
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
