// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TranslationResult _$TranslationResultFromJson(Map<String, dynamic> json) {
  return _TranslationResult.fromJson(json);
}

/// @nodoc
mixin _$TranslationResult {
  String get sourceLanguage => throw _privateConstructorUsedError;
  String get targetLanguage => throw _privateConstructorUsedError;
  String get transcription => throw _privateConstructorUsedError;
  String get translation => throw _privateConstructorUsedError;
  int? get processingDurationMs => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TranslationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranslationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationResultCopyWith<TranslationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationResultCopyWith<$Res> {
  factory $TranslationResultCopyWith(
    TranslationResult value,
    $Res Function(TranslationResult) then,
  ) = _$TranslationResultCopyWithImpl<$Res, TranslationResult>;
  @useResult
  $Res call({
    String sourceLanguage,
    String targetLanguage,
    String transcription,
    String translation,
    int? processingDurationMs,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$TranslationResultCopyWithImpl<$Res, $Val extends TranslationResult>
    implements $TranslationResultCopyWith<$Res> {
  _$TranslationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
    Object? transcription = null,
    Object? translation = null,
    Object? processingDurationMs = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            sourceLanguage: null == sourceLanguage
                ? _value.sourceLanguage
                : sourceLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            targetLanguage: null == targetLanguage
                ? _value.targetLanguage
                : targetLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            transcription: null == transcription
                ? _value.transcription
                : transcription // ignore: cast_nullable_to_non_nullable
                      as String,
            translation: null == translation
                ? _value.translation
                : translation // ignore: cast_nullable_to_non_nullable
                      as String,
            processingDurationMs: freezed == processingDurationMs
                ? _value.processingDurationMs
                : processingDurationMs // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TranslationResultImplCopyWith<$Res>
    implements $TranslationResultCopyWith<$Res> {
  factory _$$TranslationResultImplCopyWith(
    _$TranslationResultImpl value,
    $Res Function(_$TranslationResultImpl) then,
  ) = __$$TranslationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sourceLanguage,
    String targetLanguage,
    String transcription,
    String translation,
    int? processingDurationMs,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$TranslationResultImplCopyWithImpl<$Res>
    extends _$TranslationResultCopyWithImpl<$Res, _$TranslationResultImpl>
    implements _$$TranslationResultImplCopyWith<$Res> {
  __$$TranslationResultImplCopyWithImpl(
    _$TranslationResultImpl _value,
    $Res Function(_$TranslationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TranslationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
    Object? transcription = null,
    Object? translation = null,
    Object? processingDurationMs = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$TranslationResultImpl(
        sourceLanguage: null == sourceLanguage
            ? _value.sourceLanguage
            : sourceLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        targetLanguage: null == targetLanguage
            ? _value.targetLanguage
            : targetLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        transcription: null == transcription
            ? _value.transcription
            : transcription // ignore: cast_nullable_to_non_nullable
                  as String,
        translation: null == translation
            ? _value.translation
            : translation // ignore: cast_nullable_to_non_nullable
                  as String,
        processingDurationMs: freezed == processingDurationMs
            ? _value.processingDurationMs
            : processingDurationMs // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationResultImpl implements _TranslationResult {
  const _$TranslationResultImpl({
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.transcription,
    required this.translation,
    this.processingDurationMs,
    this.createdAt,
  });

  factory _$TranslationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslationResultImplFromJson(json);

  @override
  final String sourceLanguage;
  @override
  final String targetLanguage;
  @override
  final String transcription;
  @override
  final String translation;
  @override
  final int? processingDurationMs;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TranslationResult(sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, transcription: $transcription, translation: $translation, processingDurationMs: $processingDurationMs, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationResultImpl &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage) &&
            (identical(other.transcription, transcription) ||
                other.transcription == transcription) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.processingDurationMs, processingDurationMs) ||
                other.processingDurationMs == processingDurationMs) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sourceLanguage,
    targetLanguage,
    transcription,
    translation,
    processingDurationMs,
    createdAt,
  );

  /// Create a copy of TranslationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationResultImplCopyWith<_$TranslationResultImpl> get copyWith =>
      __$$TranslationResultImplCopyWithImpl<_$TranslationResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationResultImplToJson(this);
  }
}

abstract class _TranslationResult implements TranslationResult {
  const factory _TranslationResult({
    required final String sourceLanguage,
    required final String targetLanguage,
    required final String transcription,
    required final String translation,
    final int? processingDurationMs,
    final DateTime? createdAt,
  }) = _$TranslationResultImpl;

  factory _TranslationResult.fromJson(Map<String, dynamic> json) =
      _$TranslationResultImpl.fromJson;

  @override
  String get sourceLanguage;
  @override
  String get targetLanguage;
  @override
  String get transcription;
  @override
  String get translation;
  @override
  int? get processingDurationMs;
  @override
  DateTime? get createdAt;

  /// Create a copy of TranslationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationResultImplCopyWith<_$TranslationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
