import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'dart:convert';

class PaymentUtil {
  static String encypt3DES({required String key, required String data}) {
    while (key.length < 24) {
      key += '\0';
    }
    key = key.substring(0, 24);
    final keyBytes = Uint8List.fromList(utf8.encode(key));
    final dataBytes = Uint8List.fromList(utf8.encode(data));
    final keyParameter = KeyParameter(keyBytes);
    final params = ParametersWithIV(keyParameter, Uint8List(8));
    final cipher = BlockCipher('DESede')
      ..init(true, params); 
    final paddedData = _pad(dataBytes, cipher.blockSize);

    final encryptedData = Uint8List(paddedData.length);
    for (var offset = 0; offset < paddedData.length; offset += cipher.blockSize) {
      cipher.processBlock(paddedData, offset, encryptedData, offset);
    }

    return base64.encode(encryptedData);
  }
   static Uint8List _pad(Uint8List data, int blockSize) {
    final paddingLength = blockSize - (data.length % blockSize);
    final paddedData = Uint8List(data.length + paddingLength)..setAll(0, data);
    for (var i = data.length; i < paddedData.length; i++) {
      paddedData[i] = paddingLength;
    }
    return paddedData;
  }
}
