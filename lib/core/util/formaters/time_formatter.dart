import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as time_ago;

class TimeFormatter {
  static String convertToTimeAgo(String stringDate) {
    String time = '';
    var dateTime = DateFormat('yyyy-MM-ddThh:mm:ss').parse(stringDate);
    // if (DateTime.now().difference(dateTime).inHours % 24 > 24) {
    //   time = DateFormat('MMM dd, yyyy').format(dateTime);
    // } else {
    time = time_ago.format(dateTime, locale: 'en_short');
    // }
    return time;
  }
}
