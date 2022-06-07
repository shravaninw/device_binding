import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'security_keys.g.dart';

abstract class SecurityKeys
    implements Built<SecurityKeys, SecurityKeysBuilder> {
  SecurityKeys._();

  factory SecurityKeys([void Function(SecurityKeysBuilder) updates]) =
      _$SecurityKeys;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SecurityKeys.serializer, this)
        as Map<String, dynamic>;
  }

  static SecurityKeys fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SecurityKeys.serializer, json)!;
  }

  static Serializer<SecurityKeys> get serializer => _$securityKeysSerializer;

  String get privateKeyPem;

  String get publicKeyPem;

  String get encryptPublicKeyPem;
}
