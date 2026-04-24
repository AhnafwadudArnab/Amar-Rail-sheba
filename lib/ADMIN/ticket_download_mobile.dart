import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Mobile implementation — saves ticket to external storage.
Future<void> downloadTicketFile({
  required String fileName,
  required String content,
}) async {
  // Request storage permission on Android
  if (Platform.isAndroid) {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Storage permission denied');
    }
  }

  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();

  if (directory == null) {
    throw Exception('Could not determine save directory');
  }

  final filePath = '${directory.path}/$fileName';
  final file = File(filePath);
  await file.writeAsString(content);
}
