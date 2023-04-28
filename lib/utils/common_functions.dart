import 'package:intl/intl.dart';

String processLastTime(String timestamp) {
  DateTime parsedDate = DateTime.parse(timestamp).toLocal();
  var time_now = DateTime.now();
  Duration duration = time_now.difference(parsedDate);
  if (duration.inHours < 24) {
    int hour = parsedDate.hour;
    int minute = parsedDate.minute;
    String suffix = "AM";
    if (hour > 12) {
      hour -= 12;
      suffix = "PM";
    }
    String time =
        minute < 10 ? "$hour:0$minute $suffix" : "$hour:$minute $suffix";
    return '$time';
  }
  if (duration.inDays < 7) {
    return DateFormat.E().format(parsedDate);
  }
  if (duration.inDays < 365) {
    return DateFormat.MMMd().format(parsedDate);
  }
  return '${DateFormat.MMMd().format(parsedDate)}, ${parsedDate.year}';
}

String processMessageTime(String timestamp) {
  DateTime parsedDate = DateTime.parse(timestamp).toLocal();
  var time_now = DateTime.now();
  Duration duration = time_now.difference(parsedDate);
  int hour = parsedDate.hour;
  int minute = parsedDate.minute;
  String suffix = "AM";
  if (hour > 12) {
    hour -= 12;
    suffix = "PM";
  }
  String time =
      minute < 10 ? "$hour:0$minute $suffix" : "$hour:$minute $suffix";
  String ret = "";
  if (duration.inHours < 24) {
    return '$time';
  } else if (duration.inDays < 7) {
    ret = DateFormat.E().format(parsedDate);
  } else if (duration.inDays < 365) {
    ret = DateFormat.MMMd().format(parsedDate);
  } else
    ret = '${DateFormat.MMMd().format(parsedDate)}, ${parsedDate.year}';

  return ret + " $time";
}
