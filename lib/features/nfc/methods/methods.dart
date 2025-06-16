// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers
import 'package:lottie/lottie.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:flutter/material.dart';
import 'package:nfc_project/core/utils/image_manger.dart';
import 'package:nfc_project/features/nfc/screens/select.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void startNfcSession({required Function(Ndef ndef) onTagDiscovered}) async {
  NfcManager.instance.startSession(
    onDiscovered: (NfcTag tag) async {
      final ndef = Ndef.from(tag);
      if (ndef == null) {
        print('Tag is not NDEF compliant');
        return;}
      final records = ndef.cachedMessage!.records;
      final dataList = records.map((record) {
        final payload = record.payload;
        final languageCodeLength = payload[0];
        final cleanedData = String.fromCharCodes(
          payload.sublist(languageCodeLength + 1),);
        return cleanedData;
      }).toList();
      final allData = dataList.join('\n');
      onTagDiscovered(ndef);
      print(allData);
    },
  );
}
void clearData(context) {
  startNfcSession(onTagDiscovered: (ndef) async {
    final emptyMessage = NdefMessage([NdefRecord.createText('')]);
    await ndef.write(emptyMessage);
    print('Data cleared successfully');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data cleared successfully')),
    );
  });
}
void showDataDialog(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('NFC Data'),
        content: Lottie.asset(ImageManager.doneScanningAnimation),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SelectMethod(),
                ),);},),],);},);
}
final _key = encrypt.Key.fromUtf8('team22_ElShorouk_Academy879125HU');
final _iv = encrypt.IV.fromLength(16);
final _encrypter = encrypt.Encrypter(encrypt.AES(_key));
String encryptData(String _decryptedText, String? _encryptedText) {
  final text = _decryptedText.trim();
  final encrypted = _encrypter.encrypt(text, iv: _iv);
  _encryptedText = encrypted.base64;
  return _encryptedText;
}
// Decrypt the text data after reading from NFC tag
String decryptData(String? _encryptedText) {
  try {
    final decrypted = _encrypter.decrypt(
      encrypt.Encrypted.fromBase64(_encryptedText!),
      iv: _iv,
    );
    final _decryptedText = decrypted;
    return _decryptedText;
  } catch (e) {
    print('Error decrypting data: $e'); // Print error for debugging
    return 'Error decrypting data'; // Return error message
  }
}