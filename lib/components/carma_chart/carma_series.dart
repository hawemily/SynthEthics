import 'package:flutter/foundation.dart';

class CarmaSeries {
  final String dateLabel;
  final int carma;

  CarmaSeries({
    @required this.dateLabel,
    @required this.carma,
  });

  @override
  String toString() {
    return "{Date : $dateLabel , Carma : $carma}";
  }
}
