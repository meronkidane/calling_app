// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

AuthState _$AuthStateFromJson(Map<String, dynamic> json) {
  return _AuthState.fromJson(json);
}

/// @nodoc
mixin _$AuthState {
  bool get isLoading => throw _privateConstructorUsedError;
  AuthTokens? get tokens => throw _privateConstructorUsedError;
  UserProfile? get user => throw _privateConstructorUsedError;
  bool get isAuthenticated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  $Res call(
      {bool isLoading, AuthTokens? tokens, UserProfile? user, bool isAuthenticated});

  $AuthTokensCopyWith<$Res>? get tokens;
  $UserProfileCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? tokens = freezed,
    Object? user = freezed,
    Object? isAuthenticated = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      tokens: tokens == freezed
          ? _value.tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as AuthTokens?,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      isAuthenticated: isAuthenticated == freezed
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  $AuthTokensCopyWith<$Res>? get tokens {
    if (_value.tokens == null) {
      return null;
    }

    return $AuthTokensCopyWith<$Res>(_value.tokens!, (value) {
      return _then(_value.copyWith(tokens: value) as $Val);
    });
  }

  @override
  $UserProfileCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
          _$AuthStateImpl value, $Res Function(_$AuthStateImpl) then) =
      __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isLoading,
      AuthTokens? tokens,
      UserProfile? user,
      bool isAuthenticated});

  @override
  $AuthTokensCopyWith<$Res>? get tokens;
  @override
  $UserProfileCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
      _$AuthStateImpl _value, $Res Function(_$AuthStateImpl) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? tokens = freezed,
    Object? user = freezed,
    Object? isAuthenticated = freezed,
  }) {
    return _then(_$AuthStateImpl(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      tokens: tokens == freezed
          ? _value.tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as AuthTokens?,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      isAuthenticated: isAuthenticated == freezed
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl(
      {this.isLoading = false,
      this.tokens,
      this.user,
      this.isAuthenticated = false});

  factory _$AuthStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthStateImplFromJson(json);

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final AuthTokens? tokens;
  @override
  final UserProfile? user;
  @override
  @JsonKey()
  final bool isAuthenticated;

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, tokens: $tokens, user: $user, isAuthenticated: $isAuthenticated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            other.isLoading == isLoading &&
            other.tokens == tokens &&
            other.user == user &&
            other.isAuthenticated == isAuthenticated);
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, tokens, user, isAuthenticated);

  @JsonKey(ignore: true)
  @override
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthStateImplToJson(this);
  }
}

abstract class _AuthState implements AuthState {
  const factory _AuthState(
      {final bool isLoading,
      final AuthTokens? tokens,
      final UserProfile? user,
      final bool isAuthenticated}) = _$AuthStateImpl;

  factory _AuthState.fromJson(Map<String, dynamic> json) =
      _$AuthStateImpl.fromJson;

  @override
  bool get isLoading;
  @override
  AuthTokens? get tokens;
  @override
  UserProfile? get user;
  @override
  bool get isAuthenticated;
  @override
  @JsonKey(ignore: true)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) {
  return _AuthTokens.fromJson(json);
}

/// @nodoc
mixin _$AuthTokens {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthTokensCopyWith<AuthTokens> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthTokensCopyWith<$Res> {
  factory $AuthTokensCopyWith(
          AuthTokens value, $Res Function(AuthTokens) then) =
      _$AuthTokensCopyWithImpl<$Res, AuthTokens>;
  $Res call({String accessToken, String refreshToken});
}

/// @nodoc
class _$AuthTokensCopyWithImpl<$Res, $Val extends AuthTokens>
    implements $AuthTokensCopyWith<$Res> {
  _$AuthTokensCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @override
  $Res call({
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: accessToken == freezed
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: refreshToken == freezed
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthTokensImplCopyWith<$Res>
    implements $AuthTokensCopyWith<$Res> {
  factory _$$AuthTokensImplCopyWith(
          _$AuthTokensImpl value, $Res Function(_$AuthTokensImpl) then) =
      __$$AuthTokensImplCopyWithImpl<$Res>;
  @override
  $Res call({String accessToken, String refreshToken});
}

/// @nodoc
class __$$AuthTokensImplCopyWithImpl<$Res>
    extends _$AuthTokensCopyWithImpl<$Res, _$AuthTokensImpl>
    implements _$$AuthTokensImplCopyWith<$Res> {
  __$$AuthTokensImplCopyWithImpl(
      _$AuthTokensImpl _value, $Res Function(_$AuthTokensImpl) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(_$AuthTokensImpl(
      accessToken: accessToken == freezed
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: refreshToken == freezed
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthTokensImpl implements _AuthTokens {
  const _$AuthTokensImpl(
      {required this.accessToken, required this.refreshToken});

  factory _$AuthTokensImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthTokensImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;

  @override
  String toString() {
    return 'AuthTokens(accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthTokensImpl &&
            other.accessToken == accessToken &&
            other.refreshToken == refreshToken);
  }

  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken);

  @JsonKey(ignore: true)
  @override
  _$$AuthTokensImplCopyWith<_$AuthTokensImpl> get copyWith =>
      __$$AuthTokensImplCopyWithImpl<_$AuthTokensImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthTokensImplToJson(this);
  }
}

abstract class _AuthTokens implements AuthTokens {
  const factory _AuthTokens(
      {required final String accessToken,
      required final String refreshToken}) = _$AuthTokensImpl;

  factory _AuthTokens.fromJson(Map<String, dynamic> json) =
      _$AuthTokensImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  @JsonKey(ignore: true)
  _$$AuthTokensImplCopyWith<_$AuthTokensImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get phoneE164 => throw _privateConstructorUsedError;
  String get kycStatus => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;
  String? get locale => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  $Res call(
      {String id,
      String phoneE164,
      String kycStatus,
      List<String> roles,
      String? timezone,
      String? locale});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? phoneE164 = freezed,
    Object? kycStatus = freezed,
    Object? roles = freezed,
    Object? timezone = freezed,
    Object? locale = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phoneE164: phoneE164 == freezed
          ? _value.phoneE164
          : phoneE164 // ignore: cast_nullable_to_non_nullable
              as String,
      kycStatus: kycStatus == freezed
          ? _value.kycStatus
          : kycStatus // ignore: cast_nullable_to_non_nullable
              as String,
      roles: roles == freezed
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timezone: timezone == freezed
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String phoneE164,
      String kycStatus,
      List<String> roles,
      String? timezone,
      String? locale});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? id = freezed,
    Object? phoneE164 = freezed,
    Object? kycStatus = freezed,
    Object? roles = freezed,
    Object? timezone = freezed,
    Object? locale = freezed,
  }) {
    return _then(_$UserProfileImpl(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phoneE164: phoneE164 == freezed
          ? _value.phoneE164
          : phoneE164 // ignore: cast_nullable_to_non_nullable
              as String,
      kycStatus: kycStatus == freezed
          ? _value.kycStatus
          : kycStatus // ignore: cast_nullable_to_non_nullable
              as String,
      roles: roles == freezed
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timezone: timezone == freezed
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.phoneE164,
      required this.kycStatus,
      required final List<String> roles,
      this.timezone,
      this.locale})
      : _roles = roles;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String phoneE164;
  @override
  final String kycStatus;
  final List<String> _roles;
  @override
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final String? timezone;
  @override
  final String? locale;

  @override
  String toString() {
    return 'UserProfile(id: $id, phoneE164: $phoneE164, kycStatus: $kycStatus, roles: $roles, timezone: $timezone, locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            other.id == id &&
            other.phoneE164 == phoneE164 &&
            other.kycStatus == kycStatus &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            other.timezone == timezone &&
            other.locale == locale);
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, phoneE164, kycStatus,
      const DeepCollectionEquality().hash(_roles), timezone, locale);

  @JsonKey(ignore: true)
  @override
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(this);
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String phoneE164,
      required final String kycStatus,
      required final List<String> roles,
      final String? timezone,
      final String? locale}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get phoneE164;
  @override
  String get kycStatus;
  @override
  List<String> get roles;
  @override
  String? get timezone;
  @override
  String? get locale;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

const _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. '
    'This constructor is only meant to be used by Freezed and you are not supposed to need it nor use it.\n'
    'For further information, please check the documentation here: '
    'https://github.com/rrousselGit/freezed#custom-getters-and-methods');
