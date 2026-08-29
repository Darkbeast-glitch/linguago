// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'language.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Language _$LanguageFromJson(Map<String, dynamic> json) {
  return _Language.fromJson(json);
}

/// @nodoc
mixin _$Language {
  /// BCP-47-ish language code, e.g. "en", "fr".
  String get code => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get flagEmoji => throw _privateConstructorUsedError;
  bool get supportsAsr => throw _privateConstructorUsedError;
  bool get supportsTts => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;

  /// Serializes this Language to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageCopyWith<Language> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageCopyWith<$Res> {
  factory $LanguageCopyWith(Language value, $Res Function(Language) then) =
      _$LanguageCopyWithImpl<$Res, Language>;
  @useResult
  $Res call({
    String code,
    String displayName,
    String flagEmoji,
    bool supportsAsr,
    bool supportsTts,
    bool isEnabled,
  });
}

/// @nodoc
class _$LanguageCopyWithImpl<$Res, $Val extends Language>
    implements $LanguageCopyWith<$Res> {
  _$LanguageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? displayName = null,
    Object? flagEmoji = null,
    Object? supportsAsr = null,
    Object? supportsTts = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            flagEmoji: null == flagEmoji
                ? _value.flagEmoji
                : flagEmoji // ignore: cast_nullable_to_non_nullable
                      as String,
            supportsAsr: null == supportsAsr
                ? _value.supportsAsr
                : supportsAsr // ignore: cast_nullable_to_non_nullable
                      as bool,
            supportsTts: null == supportsTts
                ? _value.supportsTts
                : supportsTts // ignore: cast_nullable_to_non_nullable
                      as bool,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LanguageImplCopyWith<$Res>
    implements $LanguageCopyWith<$Res> {
  factory _$$LanguageImplCopyWith(
    _$LanguageImpl value,
    $Res Function(_$LanguageImpl) then,
  ) = __$$LanguageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String code,
    String displayName,
    String flagEmoji,
    bool supportsAsr,
    bool supportsTts,
    bool isEnabled,
  });
}

/// @nodoc
class __$$LanguageImplCopyWithImpl<$Res>
    extends _$LanguageCopyWithImpl<$Res, _$LanguageImpl>
    implements _$$LanguageImplCopyWith<$Res> {
  __$$LanguageImplCopyWithImpl(
    _$LanguageImpl _value,
    $Res Function(_$LanguageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? displayName = null,
    Object? flagEmoji = null,
    Object? supportsAsr = null,
    Object? supportsTts = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _$LanguageImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        flagEmoji: null == flagEmoji
            ? _value.flagEmoji
            : flagEmoji // ignore: cast_nullable_to_non_nullable
                  as String,
        supportsAsr: null == supportsAsr
            ? _value.supportsAsr
            : supportsAsr // ignore: cast_nullable_to_non_nullable
                  as bool,
        supportsTts: null == supportsTts
            ? _value.supportsTts
            : supportsTts // ignore: cast_nullable_to_non_nullable
                  as bool,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguageImpl implements _Language {
  const _$LanguageImpl({
    required this.code,
    required this.displayName,
    required this.flagEmoji,
    this.supportsAsr = true,
    this.supportsTts = true,
    this.isEnabled = true,
  });

  factory _$LanguageImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageImplFromJson(json);

  /// BCP-47-ish language code, e.g. "en", "fr".
  @override
  final String code;
  @override
  final String displayName;
  @override
  final String flagEmoji;
  @override
  @JsonKey()
  final bool supportsAsr;
  @override
  @JsonKey()
  final bool supportsTts;
  @override
  @JsonKey()
  final bool isEnabled;

  @override
  String toString() {
    return 'Language(code: $code, displayName: $displayName, flagEmoji: $flagEmoji, supportsAsr: $supportsAsr, supportsTts: $supportsTts, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.flagEmoji, flagEmoji) ||
                other.flagEmoji == flagEmoji) &&
            (identical(other.supportsAsr, supportsAsr) ||
                other.supportsAsr == supportsAsr) &&
            (identical(other.supportsTts, supportsTts) ||
                other.supportsTts == supportsTts) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    code,
    displayName,
    flagEmoji,
    supportsAsr,
    supportsTts,
    isEnabled,
  );

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageImplCopyWith<_$LanguageImpl> get copyWith =>
      __$$LanguageImplCopyWithImpl<_$LanguageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageImplToJson(this);
  }
}

abstract class _Language implements Language {
  const factory _Language({
    required final String code,
    required final String displayName,
    required final String flagEmoji,
    final bool supportsAsr,
    final bool supportsTts,
    final bool isEnabled,
  }) = _$LanguageImpl;

  factory _Language.fromJson(Map<String, dynamic> json) =
      _$LanguageImpl.fromJson;

  /// BCP-47-ish language code, e.g. "en", "fr".
  @override
  String get code;
  @override
  String get displayName;
  @override
  String get flagEmoji;
  @override
  bool get supportsAsr;
  @override
  bool get supportsTts;
  @override
  bool get isEnabled;

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageImplCopyWith<_$LanguageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
