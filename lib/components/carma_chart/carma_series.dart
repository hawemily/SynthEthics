import 'package:charts_flutter/flutter.dart' as charts;
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
    // TODO: implement toString
    return "{Date : $dateLabel , Carma : $carma}";
  }
}