import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:youapp/blocs/profile_bloc/profile_bloc.dart';
import 'package:youapp/blocs/profile_bloc/profile_event.dart';
import 'package:youapp/blocs/profile_bloc/profile_state.dart';
import 'package:youapp/services/you_app_api/profile_api.dart';

@GenerateMocks([ProfileApi])
import 'profile_bloc_test.mocks.dart';

void main() {
  late ProfileBloc profileBloc;
  late MockProfileApi mockProfileApi;

  setUp(() {
    mockProfileApi = MockProfileApi();
    profileBloc = ProfileBloc(mockProfileApi);
  });

  tearDown(() {
    profileBloc.close();
  });

  group(
    'ProfileBloc',
    () {
      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileSuccess] when CreateProfileEvent is added and creation is successful',
        build: () {
          when(mockProfileApi.createProfile(
            'test_token',
            {
              'name': 'John Doe',
              'birthday': '2000-01-01',
              'height': 180,
              'weight': 75,
              'interests': ['coding'],
            },
          )).thenAnswer(
            (_) async => http.Response(
              jsonEncode({
                'name': 'John Doe',
                'birthday': '2000-01-01',
                'height': 180,
                'weight': 75,
                'interests': ['coding'],
              }),
              200,
            ),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          CreateProfileEvent(
            token: 'test_token',
            profileData: const {
              'name': 'John Doe',
              'birthday': '2000-01-01',
              'height': 180,
              'weight': 75,
              'interests': ['coding'],
            },
          ),
        ),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileSuccess>().having(
            (state) => state.data,
            'data',
            {
              'name': 'John Doe',
              'birthday': '2000-01-01',
              'height': 180,
              'weight': 75,
              'interests': ['coding'],
            },
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileFailure] when CreateProfileEvent is added and creation fails',
        build: () {
          when(mockProfileApi.createProfile(
            'test_token',
            {
              'name': 'John Doe',
              'birthday': '2000-01-01',
              'height': 180,
              'weight': 75,
              'interests': ['coding'],
            },
          )).thenAnswer(
            (_) async => http.Response(
              jsonEncode({'message': 'Profile creation failed'}),
              400,
            ),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          CreateProfileEvent(
            token: 'test_token',
            profileData: const {
              'name': 'John Doe',
              'birthday': '2000-01-01',
              'height': 180,
              'weight': 75,
              'interests': ['coding'],
            },
          ),
        ),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileFailure>().having(
            (state) => state.error,
            'message',
            'Profile creation failed',
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileSuccess] when GetProfileEvent is added and retrieval is successful',
        build: () {
          when(mockProfileApi.getProfile('test_token')).thenAnswer(
            (_) async => http.Response(
              jsonEncode(
                {
                  'name': 'John Doe',
                  'birthday': '2000-01-01',
                  'height': 180,
                  'weight': 75,
                  'interests': ['coding'],
                },
              ),
              200,
            ),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(GetProfileEvent(token: 'test_token')),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileSuccess>().having(
            (state) => state.data,
            'data',
            {
              'name': 'John Doe',
              'birthday': '2000-01-01',
              'height': 180,
              'weight': 75,
              'interests': ['coding'],
            },
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileFailure] when GetProfileEvent is added and retrieval fails',
        build: () {
          when(mockProfileApi.getProfile('test_token')).thenAnswer(
            (_) async => http.Response(
              jsonEncode({'error': 'Failed to fetch profile'}),
              404,
            ),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(GetProfileEvent(token: 'test_token')),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileFailure>().having(
            (state) => state.error,
            'message',
            'Failed to fetch profile',
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileSuccess] when UpdateProfileEvent is added and update is successful',
        build: () {
          when(mockProfileApi.updateProfile(
            token: 'test_token',
            name: 'Jane Doe',
            birthday: '2001-02-02',
            height: 170,
            weight: 60,
            interests: ['reading'],
          )).thenAnswer(
            (_) async => http.Response(
              jsonEncode(
                {"message": "Profile updated successfully"},
              ),
              200,
            ),
          );

          return profileBloc;
        },
        act: (bloc) => bloc.add(
          UpdateProfileEvent(
            token: 'test_token',
            name: 'Jane Doe',
            birthday: '2001-02-02',
            height: 170,
            weight: 60,
            interests: const ['reading'],
          ),
        ),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileSuccess>().having(
            (state) => state.data,
            'data',
            {'message': 'Profile updated successfully'},
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileFailure] when UpdateProfileEvent is added and update fails',
        build: () {
          when(mockProfileApi.updateProfile(
            token: 'test_token',
            name: 'Jane Doe',
            birthday: '2001-02-02',
            height: 170,
            weight: 60,
            interests: ['reading'],
          )).thenAnswer(
            (_) async => http.Response(
              jsonEncode({'error': 'Profile update failed'}),
              400,
            ),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          UpdateProfileEvent(
            token: 'test_token',
            name: 'Jane Doe',
            birthday: '2001-02-02',
            height: 170,
            weight: 60,
            interests: const ['reading'],
          ),
        ),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileFailure>().having(
            (state) => state.error,
            'message',
            'Profile update failed',
          ),
        ],
      );
    },
  );
}
