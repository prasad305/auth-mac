import 'package:flutter/material.dart';
import 'file_encryptor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FileEncryptor encryptor = FileEncryptor("my_secure_password");
  String? filePath;

  void encryptFile() async {
    String? path = await encryptor.pickFile();
    if (path != null) {
      String encryptedPath = await encryptor.encryptFile(path);
      setState(() {
        filePath = encryptedPath;
      });
    }
  }

  void decryptFile() async {
    String? path = await encryptor.pickFile();
    if (path != null) {
      String decryptedPath = await encryptor.decryptFile(path);
      setState(() {
        filePath = decryptedPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter File Encryptor")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: encryptFile,
                child: Text("Encrypt File"),
              ),
              ElevatedButton(
                onPressed: decryptFile,
                child: Text("Decrypt File"),
              ),
              if (filePath != null) Text("Output: $filePath"),
            ],
          ),
        ),
      ),
    );
  }
}
