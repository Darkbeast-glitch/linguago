/// A voice reported by the device's local speech engine.
class TtsVoice {
  const TtsVoice({required this.name, required this.locale, this.identifier});

  factory TtsVoice.fromPlatformMap(Map<dynamic, dynamic> value) {
    return TtsVoice(
      name: value['name'] as String,
      locale: (value['locale'] as String).replaceAll('_', '-'),
      identifier: value['identifier'] as String?,
    );
  }

  final String name;
  final String locale;
  final String? identifier;

  String get id =>
      identifier?.isNotEmpty == true ? identifier! : '$locale::$name';

  Map<String, String> toPlatformMap() => {
    'name': name,
    'locale': locale,
    if (identifier?.isNotEmpty == true) 'identifier': identifier!,
  };
}
