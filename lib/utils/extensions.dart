import 'package:intl/intl.dart';

extension StringCasingExtension on String {
  String toCamelCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
}

extension DateTimeKolkataFormat on String? {
  String toKolkataTime(){
    if(this == null) return '';
    final utcDate = DateTime.tryParse(this!)?.toUtc();
    if (utcDate == null) return '';
    final kolkataDate = utcDate.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('d MMM yyyy hh:mm a').format(kolkataDate);
  }
}