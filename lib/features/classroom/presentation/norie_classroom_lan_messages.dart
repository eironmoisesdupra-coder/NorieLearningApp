String norieClassroomLanMessage(Object error) {
  if (error is FormatException) {
    return error.message;
  }
  if (error is StateError) {
    return error.message;
  }
  if (error is UnsupportedError) {
    return 'Use the installed Windows or Android app for local Wi-Fi Classroom.';
  }
  return 'Could not open the classroom connection. Check the Wi-Fi and teacher address, then retry. Saved work stays on this device.';
}
