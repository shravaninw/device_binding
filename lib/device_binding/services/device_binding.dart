library device_binding;

import 'security_keys.dart';

//For Testing Purpose
// void main() {
//   RsaKeyHelper helper = RsaKeyHelper();
//   final PRAsymmetricKeyPair<PRPublicKey, PRPrivateKey> keyPair =
//       helper.generateKeyPair();
//   final publicpem = helper.encodePublicKeyToPem(keyPair.publicKey);
//   print(publicpem);
//   final privatepem = helper.encodePrivateKeyToPem(keyPair.privateKey);
//   print(privatepem);
//
//   final PRPrivateKey pemedPrivate = helper.parsePrivateKeyFromPem(privatepem);
//   final PRPublicKey pemedPublic = helper.parsePublicKeyFromPem(publicpem);
//
//   final String encrypted = helper.encrypt('HI How are You?', pemedPublic);
//   print(encrypted);
//   final String decrypted = helper.decrypt(encrypted, pemedPrivate);
//   print(decrypted);
// }

abstract class SecureStore {
  Future<void> addSecurityKeys({
    required SecurityKeys securityKeys,
  });

  Future<SecurityKeys?> getSecurityKeys();
}

abstract class DeviceBinding {
  DeviceBinding(this.onOTP);

  SecureStore get store;

  final Future<String> Function() onOTP;

  Future<void> bindDevice() async {
    getServerKey();

    final id = await registerDevice('');
    final String otp = await onOTP.call();
    await submitOTP(id, otp);
  }

  Future<String> getServerKey();

  Future<String> registerDevice(String public);

  Future<String> submitOTP(String id, String otp);
}
