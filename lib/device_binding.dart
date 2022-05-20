library device_binding;

import 'package:device_binding/rsa_helper.dart';

/// A Calculator.
void main() {
  RsaKeyHelper helper = RsaKeyHelper();
  final PRAsymmetricKeyPair<PRPublicKey, PRPrivateKey> keyPair =
      helper.generateKeyPair();
  final publicpem = helper.encodePublicKeyToPem(keyPair.publicKey);
  print(publicpem);
  final privatepem = helper.encodePrivateKeyToPem(keyPair.privateKey);
  print(privatepem);

  final PRPrivateKey pemedPrivate = helper.parsePrivateKeyFromPem(privatepem);
  final PRPublicKey pemedPublic = helper.parsePublicKeyFromPem(publicpem);

  final String encrypted = helper.encrypt('HI How are You?', pemedPublic);
  print(encrypted);
  final String decrypted = helper.decrypt(encrypted, pemedPrivate);
  print(decrypted);
}

abstract class SecureStore {
  Future<void> saveStringSecurely(String key, String value);
}

abstract class DeviceBinding {
  DeviceBinding(this.onOTP);

  SecureStore get store;

  final Function() onOTP;

  Future<void> bindDevice() async {
    getServerKey();

    final id = await registerDevice('');
    final String otp = onOTP.call();
    submitOTP(id, otp);
  }

  Future<void> getServerKey();

  Future<String> registerDevice(String public);

  Future<String> submitOTP(String id, String otp);
}
