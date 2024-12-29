import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

DateTime parseRelativeTime(String relativeTime) {
  initializeDateFormatting('en_US'); // Initialize the locale you are using
  final now = DateTime.now();
  relativeTime = "Tomorrow 7:00pm";
  relativeTime = relativeTime.trim().toLowerCase();
  // print("Parsing relative time: $relativeTime");
  // print(relativeTime);

  try {
    if (relativeTime.startsWith("tomorrow")) {
      final timePart = relativeTime.replaceFirst("tomorrow", "").trim();
      // print("Time part: $timePart");
      final time = DateFormat("HH:mm", "en_US")
          .parse(timePart); // Changed to 24-hour format
      return DateTime(now.year, now.month, now.day + 1, time.hour, time.minute);
    } else if (relativeTime.startsWith("today")) {
      final timePart = relativeTime.replaceFirst("today", "").trim();
      // print("Time part: $timePart");
      final time = DateFormat("HH:mm", "en_US")
          .parse(timePart); // Changed to 24-hour format
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    } else {
      throw const FormatException("Unsupported relative time format");
    }
  } catch (e) {
    // print("Error parsing time: $e");
    throw FormatException("Error parsing time: $e");
  }
}

void main() {
  try {
    final scheduledTime = parseRelativeTime("Tomorrow 7:00pm");
    // print("Scheduled Time: $scheduledTime");

    final remainingTime = getRemainingTime(scheduledTime);
    // print("Remaining Time: $remainingTime");
  } catch (e) {
    print("Exception: $e");
  }
}

String getRemainingTime(DateTime scheduledTime) {
  final now = DateTime.now();
  final difference = scheduledTime.difference(now);

  if (difference.inSeconds <= 0) {
    return 'Already Started';
  }

  final hours = difference.inHours;
  final minutes = (difference.inMinutes % 60);
  final formattedTime = '${hours}h ${minutes}m';

  return formattedTime;
}
