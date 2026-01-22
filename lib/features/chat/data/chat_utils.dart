String chatIdFor(String studentId, String mentorId) {
  if (studentId.compareTo(mentorId) < 0) {
    return '${studentId}_$mentorId';
  } else {
    return '${mentorId}_$studentId';
  }
}
