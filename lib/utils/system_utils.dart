import 'package:logging/logging.dart';

void logError(String message, dynamic error, [StackTrace? stackTrace]) {
  Logger('errors').severe(message, error, stackTrace);
}
