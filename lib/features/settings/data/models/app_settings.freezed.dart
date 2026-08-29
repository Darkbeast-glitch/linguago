// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  String get preferredSourceLanguageCode => throw _privateConstructorUsedError;
  String get preferredTargetLanguageCode => throw _privateConstructorUsedError;
  bool get autoPlayTranslatedSpeech => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    String preferredSourceLanguageCode,
    String preferredTargetLanguageCode,
    bool autoPlayTranslatedSpeech,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredSourceLanguageCode = null,
    Object? preferredTargetLanguageCode = null,
    Object? autoPlayTranslatedSpeech = null,
  }) {
    return _then(
      _value.copyWith(
            preferredSourceLanguageCode: null == preferredSourceLanguageCode
                ? _value.preferredSourceLanguageCode
                : preferredSourceLanguageCode // ignore: cast_nullable_to_non_nullable
                      as String,
            preferredTargetLanguageCode: null == preferredTargetLanguageCode
                ? _value.preferredTargetLanguageCode
                : preferredTargetLanguageCode // ignore: cast_nullable_to_non_nullable
                      as String,
            autoPlayTranslatedSpeech: null == autoPlayTranslatedSpeech
                ? _value.autoPlayTranslatedSpeech
                : autoPlayTranslatedSpeech // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String preferredSourceLanguageCode,
    String preferredTargetLanguageCode,
    bool autoPlayTranslatedSpeech,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredSourceLanguageCode = null,
    Object? preferredTargetLanguageCode = null,
    Object? autoPlayTranslatedSpeech = null,
  }) {
    return _then(
      _$AppSettingsImpl(
        preferredSourceLanguageCode: null == preferredSourceLanguageCode
            ? _value.preferredSourceLanguageCode
            : preferredSourceLanguageCode // ignore: cast_nullable_to_non_nullable
                  as String,
        preferredTargetLanguageCode: null == preferredTargetLanguageCode
            ? _value.preferredTargetLanguageCode
            : preferredTargetLanguageCode // ignore: cast_nullable_to_non_nullable
                  as String,
        autoPlayTranslatedSpeech: null == autoPlayTranslatedSpeech
            ? _value.autoPlayTranslatedSpeech
            : autoPlayTranslatedSpeech // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    this.preferredSourceLanguageCode = 'en',
    this.preferredTargetLanguageCode = 'fr',
    this.autoPlayTranslatedSpeech = true,
  });

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  final String preferredSourceLanguageCode;
  @override
  @JsonKey()
  final String preferredTargetLanguageCode;
  @override
  @JsonKey()
  final bool autoPlayTranslatedSpeech;

  @override
  String toString() {
    return 'AppSettings(preferredSourceLanguageCode: $preferredSourceLanguageCode, preferredTargetLanguageCode: $preferredTargetLanguageCode, autoPlayTranslatedSpeech: $autoPlayTranslatedSpeech)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(
                  other.preferredSourceLanguageCode,
                  preferredSourceLanguageCode,
                ) ||
                other.preferredSourceLanguageCode ==
                    preferredSourceLanguageCode) &&
            (identical(
                  other.preferredTargetLanguageCode,
                  preferredTargetLanguageCode,
                ) ||
                other.preferredTargetLanguageCode ==
                    preferredTargetLanguageCode) &&
            (identical(
                  other.autoPlayTranslatedSpeech,
                  autoPlayTranslatedSpeech,
                ) ||
                other.autoPlayTranslatedSpeech == autoPlayTranslatedSpeech));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    preferredSourceLanguageCode,
    preferredTargetLanguageCode,
    autoPlayTranslatedSpeech,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    final String preferredSourceLanguageCode,
    final String preferredTargetLanguageCode,
    final bool autoPlayTranslatedSpeech,
  }) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  String get preferredSourceLanguageCode;
  @override
  String get preferredTargetLanguageCode;
  @override
  bool get autoPlayTranslatedSpeech;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
