import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';

final _appDataDir = Directory.systemTemp;

const _dataFilesBaseDirectoryName = "store";

/*final _dataFiles = {
  "file1.txt": "abc",
  "file2.txt": "åäö",
  "subdir1/file3.txt": r"@_£$",
  "subdir1/subdir11/file4.txt": "123",
};*/

Future test(List<File> _dataFiles) async {
  print("Start test");
  // test createFromDirectory
  // case 1
  //var zipFile = await _testZip(includeBaseDirectory: false, progress: true);

  var zipFile = await _testZipFiles(_dataFiles, includeBaseDirectory: false);

  // final directory = await getExternalStorageDirectory();
  final directory = await getApplicationDocumentsDirectory();

/*  if ((await directorypath.exists())) {
    return path.path;
  } else {
    path.create();
    return path.path;
  }*/

  final file = File("${directory.path}/" + zipFile.path.split('/').last);
  file.createSync(recursive: true);
  print("Writing file: ${file.path}");
  file.writeAsStringSync(zipFile.path.split('/').last);

  print("ZipPATH" +
      " PATH : " +
      zipFile.path.toString() +
      " DirectoryPATH : " +
      directory.path +
      " FilePATH : " +
      file.path);

  print("DONE!");
}

Future<File> _testZipFiles(List<File> _dataFiles,
    {bool includeBaseDirectory}) async {
  print("_appDataDir=${_appDataDir.path}");
  final storeDir =
      Directory("${_appDataDir.path}${"/$_dataFilesBaseDirectoryName"}");

  final testFiles = _createTestFiles(storeDir, _dataFiles);

  final zipFile = _createZipFile("testZipFiles.zip");
  print("Writing files to zip file: ${zipFile.path}");

  try {
    await ZipFile.createFromFiles(
        sourceDir: storeDir,
        files: testFiles,
        zipFile: zipFile,
        includeBaseDirectory: includeBaseDirectory);
  } on PlatformException catch (e) {
    print(e);
  }
  return zipFile;
}

File _createZipFile(String fileName) {
  final zipFilePath = "${_appDataDir.path}/$fileName";
  final zipFile = File(zipFilePath);

  if (zipFile.existsSync()) {
    print("Deleting existing zip file: ${zipFile.path}");
    zipFile.deleteSync();
  }
  return zipFile;
}

List<File> _createTestFiles(Directory storeDir, List<File> _dataFiles) {
  if (storeDir.existsSync()) {
    storeDir.deleteSync(recursive: true);
  }
  storeDir.createSync();
  final files = <File>[];
  /* for (final fileName in _dataFiles.keys) {
    final file = File("${storeDir.path}/$fileName");
    file.createSync(recursive: true);
    print("Writing file: ${file.path}");
    file.writeAsStringSync(_dataFiles[fileName]!);
    files.add(file);
  }*/
  for (int i = 0; i < _dataFiles.length; i++) {
    final file = File("${storeDir.path}/" + _dataFiles[i].path.split('/').last);
    file.createSync(recursive: true);
    print("Writing file: ${file.path}");
    file.writeAsStringSync(_dataFiles[i].path.split('/').last);
    files.add(file);
  }

  // verify created files
  // _verifyFiles(storeDir);

  return files;
}
