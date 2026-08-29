// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TranslationState {
  TranslationStatus get status => throw _privateConstructorUsedError;
  Language get sourceLanguage => throw _privateConstructorUsedError;
  Language get targetLanguage => throw _privateConstructorUsedError;
  String? get transcription => throw _privateConstructorUsedError;
  String? get translation => throw _privateConstructorUsedError;
  bool get isSpeaking => throw _privateConstructorUsedError;
  bool get isModelReady => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of TranslationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationStateCopyWith<TranslationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationStateCopyWith<$Res> {
  factory $TranslationStateCopyWith(
    TranslationState value,
    $Res Function(TranslationState) then,
  ) = _$TranslationStateCopyWithImpl<$Res, TranslationState>;
  @useResult
  $Res call({
    TranslationStatus status,
    Language sourceLanguage,
    Language targetLanguage,
    String? transcription,
    String? translation,
    bool isSpeaking,
    bool isModelReady,
    String? errorMessage,
  });

  $LanguageCopyWith<$Res> get sourceLanguage;
  $LanguageCopyWith<$Res> get targetLanguage;
}

/// @nodoc
class _$TranslationStateCopyWithImpl<$Res, $Val extends TranslationState>
    implements $TranslationStateCopyWith<$Res> {
  _$TranslationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
    Object? transcription = freezed,
    Object? translation = freezed,
    Object? isSpeaking = null,
    Object? isModelReady = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TranslationStatus,
            sourceLanguage: null == sourceLanguage
                ? _value.sourceLanguage
                : sourceLanguage // ignore: cast_nullable_to_non_nullable
                      as Language,
            targetLanguage: null == targetLanguage
                ? _value.targetLanguage
                : targetLanguage // ignore: cast_nullable_to_non_nullable
                      as Language,
            transcription: freezed == transcription
                ? _value.transcription
                : transcription // ignore: cast_nullable_to_non_nullable
                      as String?,
            translation: freezed == translation
                ? _value.translation
                : translation // ignore: cast_nullable_to_non_nullable
                      as String?,
            isSpeaking: null == isSpeaking
                ? _value.isSpeaking
                : isSpeaking // ignore: cast_nullable_to_non_nullable
                      as bool,
            isModelReady: null == isModelReady
                ? _value.isModelReady
                : isModelReady // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of TranslationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LanguageCopyWith<$Res> get sourceLanguage {
    return $LanguageCopyWith<$Res>(_value.sourceLanguage, (value) {
      return _then(_value.copyWith(sourceLanguage: value) as $Val);
    });
  }

  /// Create a copy of TranslationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LanguageCopyWith<$Res> get targetLanguage {
    return $LanguageCopyWith<$Res>(_value.targetLanguage, (value) {
      return _then(_value.copyWith(targetLanguage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TranslationStateImplCopyWith<$Res>
    implements $TranslationStateCopyWith<$Res> {
  factory _$$TranslationStateImplCopyWith(
    _$TranslationStateImpl value,
    $Res Function(_$TranslationStateImpl) then,
  ) = __$$TranslationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TranslationStatus status,
    Language sourceLanguage,
    Language targetLanguage,
    String? transcription,
    String? translation,
    bool isSpeaking,
    bool isModelReady,
    String? errorMessage,
  });

  @override
  $LanguageCopyWith<$Res> get sourceLanguage;
  @override
  $LanguageCopyWith<$Res> get targetLanguage;
}

/// @nodoc
class __$$TranslationStateImplCopyWithImpl<$Res>
    extends _$TranslationStateCopyWithImpl<$Res, _$TranslationStateImpl>
    implements _$$TranslationStateImplCopyWith<$Res> {
  __$$TranslationStateImplCopyWithImpl(
    _$TranslationStateImpl _value,
    $Res Function(_$TranslationStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TranslationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
    Object? transcription = freezed,
    Object? translation = freezed,
    Object? isSpeaking = null,
    Object? isModelReady = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$TranslationStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TranslationStatus,
        sourceLanguage: null == sourceLanguage
            ? _value.sourceLanguage
            : sourceLanguage // ignore: cast_nullable_to_non_nullable
                  as Language,
        targetLanguage: null == targetLanguage
            ? _value.targetLanguage
            : targetLanguage // ignore: cast_nullable_to_non_nullable
                  as Language,
        transcription: freezed == transcription
            ? _value.transcription
            : transcription // ignore: cast_nullable_to_non_nullable
                  as String?,
        translation: freezed == translation
            ? _value.translation
            : translation // ignore: cast_nullable_to_non_nullable
                  as String?,
        isSpeaking: null == isSpeaking
            ? _value.isSpeaking
            : isSpeaking // ignore: cast_nullable_to_non_nullable
                  as bool,
        isModelReady: null == isModelReady
            ? _value.isModelReady
            : isModelReady // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TranslationStateImpl implements _TranslationState {
  const _$TranslationStateImpl({
    this.status = TranslationStatus.idle,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.transcription,
    this.translation,
    this.isSpeaking = false,
    this.isModelReady = false,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final TranslationStatus status;
  @override
  final Language sourceLanguage;
  @override
  final Language targetLanguage;
  @override
  final String? transcription;
  @override
  final String? translation;
  @override
  @JsonKey()
  final bool isSpeaking;
  @override
  @JsonKey()
  final bool isModelReady;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TranslationState(status: $status, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, transcription: $transcription, translation: $translation, isSpeaking: $isSpeaking, isModelReady: $isModelReady, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage) &&
            (identical(other.transcription, transcription) ||
                other.transcription == transcription) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.isSpeaking, isSpeaking) ||
                other.isSpeaking == isSpeaking) &&
            (identical(other.isModelReady, isModelReady) ||
                other.isModelReady == isModelReady) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    sourceLanguage,
    targetLanguage,
    transcription,
    translation,
    isSpeaking,
    isModelReady,
    errorMessage,
  );

  /// Create a copy of TranslationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationStateImplCopyWith<_$TranslationStateImpl> get copyWith =>
      __$$TranslationStateImplCopyWithImpl<_$TranslationStateImpl>(
        this,
        _$identity,
      );
}

abstract class _TranslationState implements TranslationState {
  const factory _TranslationState({
    final TranslationStatus status,
    required final Language sourceLanguage,
    required final Language targetLanguage,
    final String? transcription,
    final String? translation,
    final bool isSpeaking,
    final bool isModelReady,
    final String? errorMessage,
  }) = _$TranslationStateImpl;

  @override
  TranslationStatus get status;
  @override
  Language get sourceLanguage;
  @override
  Language get targetLanguage;
  @override
  String? get transcription;
  @override
  String? get translation;
  @override
  bool get isSpeaking;
  @override
  bool get isModelReady;
  @override
  String? get errorMessage;

  /// Create a copy of TranslationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationStateImplCopyWith<_$TranslationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
