// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(
      isLoading: json['isLoading'] as bool? ?? false,
      tokens: json['tokens'] == null
          ? null
          : AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
    );

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{
      'isLoading': instance.isLoading,
      'tokens': instance.tokens,
      'user': instance.user,
      'isAuthenticated': instance.isAuthenticated,
    };

_$AuthTokensImpl _$$AuthTokensImplFromJson(Map<String, dynamic> json) =>
    _$AuthTokensImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$AuthTokensImplToJson(_$AuthTokensImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      phoneE164: json['phoneE164'] as String,
      kycStatus: json['kycStatus'] as String,
      roles:
          (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      timezone: json['timezone'] as String?,
      locale: json['locale'] as String?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneE164': instance.phoneE164,
      'kycStatus': instance.kycStatus,
      'roles': instance.roles,
      'timezone': instance.timezone,
      'locale': instance.locale,
    };
