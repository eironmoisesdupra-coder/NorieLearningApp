import '../lan/norie_classroom_lan.dart';
import 'norie_classroom_connection_copy.dart';

String norieClassroomLanMessage(Object error) {
  if (error is NorieLanConnectionException) {
    return switch (error.failure) {
      NorieLanFailure.unreachable => NorieClassroomConnectionCopy.message(
          NorieClassroomConnectionIssue.teacherNotFound),
      NorieLanFailure.unauthorized => NorieClassroomConnectionCopy.message(
          NorieClassroomConnectionIssue.joinCodeExpired),
      NorieLanFailure.changed => NorieClassroomConnectionCopy.message(
          NorieClassroomConnectionIssue.teacherEndedSession),
      _ => error.message,
    };
  }
  if (error is FormatException) {
    return error.message;
  }
  if (error is StateError) {
    return error.message;
  }
  if (error is UnsupportedError) {
    return 'Use the installed Windows or Android app for local Wi-Fi Classroom.';
  }
  return NorieClassroomConnectionCopy.message(
      NorieClassroomConnectionIssue.teacherNotFound);
}
