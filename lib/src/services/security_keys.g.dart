// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_keys.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SecurityKeys> _$securityKeysSerializer =
    new _$SecurityKeysSerializer();

class _$SecurityKeysSerializer implements StructuredSerializer<SecurityKeys> {
  @override
  final Iterable<Type> types = const [SecurityKeys, _$SecurityKeys];
  @override
  final String wireName = 'SecurityKeys';

  @override
  Iterable<Object?> serialize(Serializers serializers, SecurityKeys object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'privateKeyPem',
      serializers.serialize(object.privateKeyPem,
          specifiedType: const FullType(String)),
      'publicKeyPem',
      serializers.serialize(object.publicKeyPem,
          specifiedType: const FullType(String)),
      'encryptPublicKeyPem',
      serializers.serialize(object.encryptPublicKeyPem,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  SecurityKeys deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SecurityKeysBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'privateKeyPem':
          result.privateKeyPem = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'publicKeyPem':
          result.publicKeyPem = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'encryptPublicKeyPem':
          result.encryptPublicKeyPem = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SecurityKeys extends SecurityKeys {
  @override
  final String privateKeyPem;
  @override
  final String publicKeyPem;
  @override
  final String encryptPublicKeyPem;

  factory _$SecurityKeys([void Function(SecurityKeysBuilder)? updates]) =>
      (new SecurityKeysBuilder()..update(updates))._build();

  _$SecurityKeys._(
      {required this.privateKeyPem,
      required this.publicKeyPem,
      required this.encryptPublicKeyPem})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        privateKeyPem, 'SecurityKeys', 'privateKeyPem');
    BuiltValueNullFieldError.checkNotNull(
        publicKeyPem, 'SecurityKeys', 'publicKeyPem');
    BuiltValueNullFieldError.checkNotNull(
        encryptPublicKeyPem, 'SecurityKeys', 'encryptPublicKeyPem');
  }

  @override
  SecurityKeys rebuild(void Function(SecurityKeysBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SecurityKeysBuilder toBuilder() => new SecurityKeysBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SecurityKeys &&
        privateKeyPem == other.privateKeyPem &&
        publicKeyPem == other.publicKeyPem &&
        encryptPublicKeyPem == other.encryptPublicKeyPem;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, privateKeyPem.hashCode), publicKeyPem.hashCode),
        encryptPublicKeyPem.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SecurityKeys')
          ..add('privateKeyPem', privateKeyPem)
          ..add('publicKeyPem', publicKeyPem)
          ..add('encryptPublicKeyPem', encryptPublicKeyPem))
        .toString();
  }
}

class SecurityKeysBuilder
    implements Builder<SecurityKeys, SecurityKeysBuilder> {
  _$SecurityKeys? _$v;

  String? _privateKeyPem;
  String? get privateKeyPem => _$this._privateKeyPem;
  set privateKeyPem(String? privateKeyPem) =>
      _$this._privateKeyPem = privateKeyPem;

  String? _publicKeyPem;
  String? get publicKeyPem => _$this._publicKeyPem;
  set publicKeyPem(String? publicKeyPem) => _$this._publicKeyPem = publicKeyPem;

  String? _encryptPublicKeyPem;
  String? get encryptPublicKeyPem => _$this._encryptPublicKeyPem;
  set encryptPublicKeyPem(String? encryptPublicKeyPem) =>
      _$this._encryptPublicKeyPem = encryptPublicKeyPem;

  SecurityKeysBuilder();

  SecurityKeysBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _privateKeyPem = $v.privateKeyPem;
      _publicKeyPem = $v.publicKeyPem;
      _encryptPublicKeyPem = $v.encryptPublicKeyPem;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SecurityKeys other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SecurityKeys;
  }

  @override
  void update(void Function(SecurityKeysBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SecurityKeys build() => _build();

  _$SecurityKeys _build() {
    final _$result = _$v ??
        new _$SecurityKeys._(
            privateKeyPem: BuiltValueNullFieldError.checkNotNull(
                privateKeyPem, 'SecurityKeys', 'privateKeyPem'),
            publicKeyPem: BuiltValueNullFieldError.checkNotNull(
                publicKeyPem, 'SecurityKeys', 'publicKeyPem'),
            encryptPublicKeyPem: BuiltValueNullFieldError.checkNotNull(
                encryptPublicKeyPem, 'SecurityKeys', 'encryptPublicKeyPem'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
