import 'dart:convert';
import 'dart:io';

Map<String, dynamic> fromJsonFile(String filename) =>
    jsonDecode(File('./test/utils/jsons/$filename').readAsStringSync());

List<Map<String, dynamic>> fromJsonListFile(String filename) =>
    (jsonDecode(File('./test/utils/jsons/$filename').readAsStringSync()) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
