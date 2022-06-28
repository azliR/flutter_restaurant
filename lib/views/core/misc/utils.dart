import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(num number) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  ).format(number);
}

String formatDateTime(DateTime date, {required Locale locale}) {
  return DateFormat('EEEE, d MMMM yyyy, HH:mm', locale.toString()).format(date);
}
