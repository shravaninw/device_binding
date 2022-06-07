import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import "package:asn1lib/asn1lib.dart";
import "package:pointycastle/export.dart";

List<int> _decodePEM(String pem) {
  var startsWith = [
    "-----BEGIN PUBLIC KEY-----",
    "-----BEGIN PRIVATE KEY-----",
    "-----BEGIN RSA PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    "-----BEGIN RSA PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
  ];
  var endsWith = [
    "-----END PUBLIC KEY-----",
    "-----END PRIVATE KEY-----",
    "-----END RSA PUBLIC KEY BLOCK-----",
    "-----END RSA PRIVATE KEY BLOCK-----",
  ];
  bool isOpenPgp = pem.indexOf('BEGIN RSA') != -1;

  for (var s in startsWith) {
    if (pem.startsWith(s)) {
      pem = pem.substring(s.length);
    }
  }

  for (var s in endsWith) {
    if (pem.endsWith(s)) {
      pem = pem.substring(0, pem.length - s.length);
    }
  }

  if (isOpenPgp) {
    var index = pem.indexOf('\r\n');
    pem = pem.substring(0, index);
  }

  pem = pem.replaceAll('\n', '');
  pem = pem.replaceAll('\r', '');

  return base64.decode(pem);
}

class SecurityException implements Exception {
  SecurityException(this.message);

  final String message;

  @override
  String toString() {
    return '$SecurityException->$message';
  }
}

extension IntListUtils on List<int> {
  Uint8List toUint8List() => Uint8List.fromList(this);
}

class PRAsymmetricKeyPair<PRPublicKey extends PublicKey,
    PRPrivateKey extends PrivateKey> {
  PRAsymmetricKeyPair(this.publicKey, this.privateKey);

  final PRPublicKey publicKey;

  final PRPrivateKey privateKey;
}

class PRPublicKey extends RSAPublicKey {
  PRPublicKey(
    BigInt modulus,
    BigInt exponent,
  ) : super(modulus, exponent);
}

class PRPrivateKey extends RSAPrivateKey {
  PRPrivateKey(
    BigInt modulus,
    BigInt privateExponent,
    BigInt? p,
    BigInt? q,
  ) : super(modulus, privateExponent, p, q);
}

class RsaKeyHelper {
  PRAsymmetricKeyPair<PRPublicKey, PRPrivateKey> generateKeyPair() {
    RSAKeyGeneratorParameters keyParams =
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12);

    FortunaRandom secureRandom = FortunaRandom();
    Random random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    ParametersWithRandom<RSAKeyGeneratorParameters> rngParams =
        ParametersWithRandom(keyParams, secureRandom);
    RSAKeyGenerator k = RSAKeyGenerator();
    k.init(rngParams);

    final AsymmetricKeyPair<PublicKey, PrivateKey> keyPair =
        k.generateKeyPair();
    RSAPrivateKey rsaPrivateKey = keyPair.privateKey as RSAPrivateKey;
    RSAPublicKey rsaPublicKey = keyPair.publicKey as RSAPublicKey;
    if (rsaPublicKey.modulus == null ||
        rsaPublicKey.publicExponent == null ||
        rsaPrivateKey.modulus == null ||
        rsaPrivateKey.publicExponent == null ||
        rsaPrivateKey.p == null ||
        rsaPrivateKey.q == null) {
      throw SecurityException;
    }
    PRPublicKey prPublicKey =
        PRPublicKey(rsaPublicKey.modulus!, rsaPublicKey.publicExponent!);
    PRPrivateKey prPrivateKey = PRPrivateKey(rsaPrivateKey.modulus!,
        rsaPrivateKey.privateExponent!, rsaPrivateKey.p!, rsaPrivateKey.q!);
    return PRAsymmetricKeyPair(prPublicKey, prPrivateKey);
  }

  String encrypt(String plaintext, PRPublicKey publicKey) {
    RSAEngine cipher = RSAEngine()
      ..init(true, PublicKeyParameter<PRPublicKey>(publicKey));
    Uint8List cipherText =
        cipher.process(Uint8List.fromList(plaintext.codeUnits));

    return String.fromCharCodes(cipherText);
  }

  String decrypt(String ciphertext, PRPrivateKey privateKey) {
    RSAEngine cipher = RSAEngine()
      ..init(false, PrivateKeyParameter<PRPrivateKey>(privateKey));
    Uint8List decrypted =
        cipher.process(Uint8List.fromList(ciphertext.codeUnits));

    return String.fromCharCodes(decrypted);
  }

  PRPublicKey parsePublicKeyFromPem(String pemString) {
    List<int> publicKeyDER = _decodePEM(pemString);
    ASN1Parser asn1Parser = ASN1Parser(publicKeyDER.toUint8List());
    ASN1Sequence topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    ASN1Object publicKeyBitString = topLevelSeq.elements[1];

    Uint8List? publicContentBytes = publicKeyBitString.contentBytes();
    if (publicContentBytes == null) {
      throw SecurityException;
    }
    ASN1Parser publicKeyAsn = ASN1Parser(publicContentBytes);
    ASN1Sequence publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    ASN1Integer modulus = publicKeySeq.elements[0] as ASN1Integer;
    ASN1Integer exponent = publicKeySeq.elements[1] as ASN1Integer;

    BigInt? modValueAsBigInteger = modulus.valueAsBigInteger;
    BigInt? exponentValueAsBigInteger = exponent.valueAsBigInteger;
    if (modValueAsBigInteger == null || exponentValueAsBigInteger == null) {
      throw SecurityException;
    }
    PRPublicKey rsaPublicKey =
        PRPublicKey(modValueAsBigInteger, exponentValueAsBigInteger);

    return rsaPublicKey;
  }

  PRPrivateKey parsePrivateKeyFromPem(String pemString) {
    List<int> privateKeyDER = _decodePEM(pemString);
    ASN1Parser asn1Parser = ASN1Parser(privateKeyDER.toUint8List());
    ASN1Sequence topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    ASN1Object version = topLevelSeq.elements[0];
    ASN1Object algorithm = topLevelSeq.elements[1];
    ASN1Object privateKey = topLevelSeq.elements[2];

    asn1Parser = ASN1Parser(privateKey.contentBytes()!);
    ASN1Sequence pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    version = pkSeq.elements[0];
    ASN1Integer modulus = pkSeq.elements[1] as ASN1Integer;
    ASN1Integer publicExponent = pkSeq.elements[2] as ASN1Integer;
    ASN1Integer privateExponent = pkSeq.elements[3] as ASN1Integer;
    ASN1Integer p = pkSeq.elements[4] as ASN1Integer;
    ASN1Integer q = pkSeq.elements[5] as ASN1Integer;
    ASN1Integer exp1 = pkSeq.elements[6] as ASN1Integer;
    ASN1Integer exp2 = pkSeq.elements[7] as ASN1Integer;
    ASN1Integer co = pkSeq.elements[8] as ASN1Integer;

    BigInt? modValueAsBigInteger = modulus.valueAsBigInteger;
    BigInt? privateExponentValueAsBigInteger =
        privateExponent.valueAsBigInteger;
    if (modValueAsBigInteger == null ||
        privateExponentValueAsBigInteger == null) {
      throw SecurityException;
    }
    PRPrivateKey rsaPrivateKey = PRPrivateKey(
      modValueAsBigInteger,
      privateExponentValueAsBigInteger,
      p.valueAsBigInteger,
      q.valueAsBigInteger,
    );

    return rsaPrivateKey;
  }

  String encodePublicKeyToPem(PRPublicKey publicKey) {
    var algorithmSeq = ASN1Sequence();
    var algorithmAsn1Obj = ASN1Object.fromBytes(
      Uint8List.fromList(
        [
          0x6,
          0x9,
          0x2a,
          0x86,
          0x48,
          0x86,
          0xf7,
          0xd,
          0x1,
          0x1,
          0x1,
        ],
      ),
    );
    ASN1Object paramsAsn1Obj =
        ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    ASN1Sequence publicKeySeq = ASN1Sequence();
    BigInt? modulus = publicKey.modulus;
    BigInt? exponent = publicKey.exponent;
    if (modulus == null || exponent == null) {
      throw SecurityException;
    }
    publicKeySeq.add(ASN1Integer(modulus));
    publicKeySeq.add(ASN1Integer(exponent));
    ASN1BitString publicKeySeqBitString =
        ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

    ASN1Sequence topLevelSeq = ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqBitString);
    String dataBase64 = base64.encode(topLevelSeq.encodedBytes);

    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  String encodePrivateKeyToPem(PRPrivateKey privateKey) {
    ASN1Integer version = ASN1Integer(BigInt.from(0));

    ASN1Sequence algorithmSeq = ASN1Sequence();
    ASN1Object algorithmAsn1Obj = ASN1Object.fromBytes(
      Uint8List.fromList(
        [
          0x6,
          0x9,
          0x2a,
          0x86,
          0x48,
          0x86,
          0xf7,
          0xd,
          0x1,
          0x1,
          0x1,
        ],
      ),
    );
    ASN1Object paramsAsn1Obj =
        ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    ASN1Sequence privateKeySeq = ASN1Sequence();
    BigInt? n = privateKey.n;
    BigInt? d = privateKey.d;
    BigInt? p2 = privateKey.p;
    BigInt? q2 = privateKey.q;
    if (n == null || d == null || p2 == null || q2 == null) {
      throw SecurityException;
    }
    ASN1Integer modulus = ASN1Integer(n);
    ASN1Integer publicExponent = ASN1Integer(BigInt.parse('65537'));
    ASN1Integer privateExponent = ASN1Integer(d);
    ASN1Integer p = ASN1Integer(p2);
    ASN1Integer q = ASN1Integer(q2);
    BigInt dP = d % (p2 - BigInt.from(1));
    ASN1Integer exp1 = ASN1Integer(dP);
    BigInt dQ = d % (q2 - BigInt.from(1));
    ASN1Integer exp2 = ASN1Integer(dQ);
    BigInt iQ = q2.modInverse(p2);
    ASN1Integer co = ASN1Integer(iQ);

    privateKeySeq.add(version);
    privateKeySeq.add(modulus);
    privateKeySeq.add(publicExponent);
    privateKeySeq.add(privateExponent);
    privateKeySeq.add(p);
    privateKeySeq.add(q);
    privateKeySeq.add(exp1);
    privateKeySeq.add(exp2);
    privateKeySeq.add(co);
    ASN1OctetString publicKeySeqOctetString =
        ASN1OctetString(Uint8List.fromList(privateKeySeq.encodedBytes));

    ASN1Sequence topLevelSeq = ASN1Sequence();
    topLevelSeq.add(version);
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqOctetString);
    String dataBase64 = base64.encode(topLevelSeq.encodedBytes);

    return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
  }
}
