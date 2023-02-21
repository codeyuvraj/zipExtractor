import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var filesExtracting = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Hello World"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result0 = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ["zip"], allowMultiple: true);
                  if (result0 != null) {
                    // String filepath = result0.files.single.path ?? 'default';
                    List<String> filePaths = result0.files.map((e) => e.path as String).toList();
                    // final zipFile = File(filepath);
                    List<File> zipFiles = filePaths.map((e) => File(e)).toList();
                    // debugPrint(zipFile.parent.path);
                    
                    // Directory? destinationDir = null;
                    var permissionGranted = false;
                    if (await Permission.manageExternalStorage.request().isGranted) {
                      permissionGranted = true;
                    }
                    
                    // var status = await Permission.manageExternalStorage.status;
                    final extractedPath = 'storage/emulated/0/Download';
                    // Directory(extractedPath).create().then((value) => destinationDir = value);
                    // debugPrint("printing status: $status");
                    if (!permissionGranted) {
                      if (await Permission.manageExternalStorage.request().isGranted) {
                      permissionGranted = true;
                    }
                    }
                    if(!permissionGranted) return;
                    try {
                      filesExtracting = true;
                      setState(() {
                        
                      });
                      await Future.delayed(Duration(milliseconds: 500));
                      // ZipFile.extractToDirectory(
                      //     zipFile: zipFile, destinationDir: destinationDir as Directory);

                      zipFiles.forEach((zipFile) async{
                        
                        var fileNameWithoutExtension = p.basenameWithoutExtension(zipFile.path);
                        print(fileNameWithoutExtension);
                        var destinationDir;
                        await Directory('$extractedPath/$fileNameWithoutExtension').create(recursive: true).then((value) => destinationDir = Directory(value.path));
                        print('Destination path ${destinationDir.path}');
                        await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: destinationDir);

                      });
                      filesExtracting = false;
                      setState(() {
                        
                      });
                    } catch (e) {
                      filesExtracting = false;
                      setState(() {
                        
                      });
                      debugPrint(e.toString());
                    }
                  } else {
                    // User canceled the picker
                  }
                },
                child:
                    const Text("Extract ZIP", style: TextStyle(fontSize: 32)),
              ),
              const SizedBox(height: 20),
              filesExtracting? Text('extracting files... '): Container(),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () async {

                  
                  FilePickerResult? result1 = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ["pdf"]);
                  if (result1 != null) {
                    String filepath = result1.files.single.path ?? 'default';
                    debugPrint(filepath);
                    final result = await OpenFile.open(filepath);
                  } else {
                    // User canceled the picker
                  }
                },
                child:
                    const Text("Open Document", style: TextStyle(fontSize: 32)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
