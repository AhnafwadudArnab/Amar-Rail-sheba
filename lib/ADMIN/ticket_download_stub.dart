/// Stub implementation — used when neither dart:html nor dart:io is available.
Future<void> downloadTicketFile({
  required String fileName,
  required String content,
}) async {
  throw UnsupportedError('Ticket download is not supported on this platform.');
}
