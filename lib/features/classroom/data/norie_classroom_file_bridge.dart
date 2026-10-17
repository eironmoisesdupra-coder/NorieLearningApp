import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'norie_classroom_codec.dart';
import '../domain/norie_classroom_models.dart';

abstract final class NorieClassroomFileBridge {
  static Future<Uri?> exportAssignment(NorieClassroomAssignment a) => _save(
      '${_name(a.id)}.norieclass',
      NorieClassroomCodec.encodeAssignment(a),
      'Save classroom assignment');
  static Future<Uri?> exportSubmission(NorieClassroomSubmission s) => _save(
      '${_name(s.id)}.noriesubmission',
      NorieClassroomCodec.encodeSubmission(s),
      'Save classroom submission');
  static Future<Uri?> exportReport(NorieClassroomAssignment a,
          Iterable<NorieClassroomSubmission> submissions) =>
      _save(
          '${_name(a.id)}-report.csv',
          NorieClassroomCodec.csvReport(a, submissions),
          'Save classroom report',
          mime: 'text/csv');
  static String _name(String value) =>
      value.replaceAll(RegExp('[^A-Za-z0-9_-]'), '_');
  static Future<Uri?> _save(String name, String text, String title,
          {String mime = 'application/json'}) =>
      FilePicker.saveFile(
          fileName: name,
          bytes: Uint8List.fromList(utf8.encode(text)),
          mimeType: mime,
          dialogTitle: title);
  static Future<String?> _pick(List<String> extensions) async {
    final file = await FilePicker.pickFile(
        type: FileType.custom, allowedExtensions: extensions);
    if (file == null) return null;
    final size = await file.length();
    if (size == null || size > NorieClassroomCodec.maxBytes) {
      throw const FormatException('Package too large.');
    }
    final bytes = await file.readAsBytes();
    if (bytes.length > NorieClassroomCodec.maxBytes) {
      throw const FormatException('Package too large.');
    }
    return utf8.decode(bytes);
  }

  static Future<NorieClassroomAssignment?> importAssignment() async {
    final text = await _pick(const ['norieclass', 'json']);
    return text == null ? null : NorieClassroomCodec.decodeAssignment(text);
  }

  static Future<NorieClassroomSubmission?> importSubmission() async {
    final text = await _pick(const ['noriesubmission', 'json']);
    return text == null ? null : NorieClassroomCodec.decodeSubmission(text);
  }
}
