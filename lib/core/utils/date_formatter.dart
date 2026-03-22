import 'package:intl/intl.dart';

final weekdaysUk = [
  '', // 1 = Понеділок
  'Понеділок',
  'Вівторок',
  'Середа',
  'Четвер',
  'Пʼятниця',
  'Субота',
  'Неділя',
];

String formatDateWithWeekday(DateTime date) {
  final weekday = weekdaysUk[date.weekday];
  final dayMonthYear = DateFormat('d MMMM yyyy', 'uk_UA').format(date);
  return '$weekday, $dayMonthYear';
}
