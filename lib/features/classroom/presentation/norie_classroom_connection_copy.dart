enum NorieClassroomConnectionIssue {
  teacherNotFound,
  differentNetwork,
  joinCodeExpired,
  teacherEndedSession,
  submissionPending,
  alreadySubmitted,
  firewallBlocked,
}

abstract final class NorieClassroomConnectionCopy {
  static String message(NorieClassroomConnectionIssue issue) => switch (issue) {
        NorieClassroomConnectionIssue.teacherNotFound =>
          'Cannot reach the teacher. Check that the classroom is open and both devices use the same trusted Wi-Fi or hotspot. Your saved work stays on this device.',
        NorieClassroomConnectionIssue.differentNetwork =>
          'Check that both devices use the same trusted Wi-Fi or hotspot. Guest networks may block device-to-device connections.',
        NorieClassroomConnectionIssue.joinCodeExpired =>
          'The code or session was not accepted. Ask your teacher for the current code or scan the current QR, then join again.',
        NorieClassroomConnectionIssue.teacherEndedSession =>
          'The classroom or shared work changed. Ask for the current QR and rejoin. Your saved work stays on this device.',
        NorieClassroomConnectionIssue.submissionPending =>
          'Saved on this device. Reconnect to the classroom, then return this saved result. Retrying does not create an extra attempt.',
        NorieClassroomConnectionIssue.alreadySubmitted =>
          'This submission was already received. No duplicate was created.',
        NorieClassroomConnectionIssue.firewallBlocked =>
          'If Windows Firewall is blocking the host, allow NorieLearning on the trusted Private network. Check the teacher address and retry.',
      };
}
