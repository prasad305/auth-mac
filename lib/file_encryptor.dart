import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class FileEncryptor {
  final encrypt.Key key;
  final encrypt.IV iv;
  final encrypt.Encrypter encrypter;

  FileEncryptor(String password)
      : key = encrypt.Key.fromUtf8(password.padRight(32).substring(0, 32)),
        iv = encrypt.IV.fromLength(16),
        encrypter = encrypt.Encrypter(encrypt.AES(
          encrypt.Key.fromUtf8(password.padRight(32).substring(0, 32)),
          mode: encrypt.AESMode.cbc,
        ));

  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    return result?.files.single.path;
  }

  Future<String> encryptFile(String filePath) async {
    File file = File(filePath);
    Uint8List fileBytes = await file.readAsBytes();

    final encryptedBytes = encrypter.encryptBytes(fileBytes, iv: iv).bytes;

    String encryptedPath = '${filePath}.enc';
    File encryptedFile = File(encryptedPath);
    await encryptedFile.writeAsBytes(encryptedBytes);

    return encryptedPath;
  }

  Future<String> decryptFile(String filePath) async {
    File file = File(filePath);
    Uint8List encryptedBytes = await file.readAsBytes();

    final decryptedBytes = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

    String decryptedPath = filePath.replaceAll('.enc', '_decrypted');
    File decryptedFile = File(decryptedPath);
    await decryptedFile.writeAsBytes(decryptedBytes);

    return decryptedPath;
  }
}
