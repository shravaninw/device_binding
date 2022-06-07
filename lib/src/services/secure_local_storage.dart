import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'device_binding.dart';
import 'security_keys.dart';

class SecureLocalStorageServiceImpl implements SecureStore {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> addSecurityKeys({
    required SecurityKeys securityKeys,
  }) async {
    final Map<String, dynamic>? jsonValue = securityKeys.toJson();
    final String data = jsonEncode(jsonValue);

    await _storage.write(
      key: 'securityKeys',
      value: data,
    );
  }

  @override
  Future<SecurityKeys?> getSecurityKeys() async {
    final String? value = await _storage.read(
      key: 'securityKeys',
    );
    if (value == null) {
      return null;
    }
    final SecurityKeys securityKeys = SecurityKeys.fromJson(
      jsonDecode(value) as Map<String, dynamic>,
    );
    return securityKeys;
  }
}
