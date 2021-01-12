import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:synthetics/components/carma_chart/carma_series.dart';
import 'package:synthetics/theme/custom_colours.dart';

class CarmaChart extends StatelessWidget {
  final List<CarmaSeries> data;

  CarmaChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<CarmaSeries, String>> series = [
      charts.Series(
          id: "Carma",
          data: data,
          domainFn: (CarmaSeries series, _) => series.dateLabel,
          measureFn: (CarmaSeries series, _) => series.carma,
          colorFn: (CarmaSeries series, _) =>
              charts.ColorUtil.fromDartColor(CustomColours.iconGreen()))
    ];
    return Container(
      padding: EdgeInsets.all(20),
      child: charts.BarChart(
        series,
        animate: true,
        behaviors: [
          charts.SlidingViewport(
            charts.SelectionModelType.action,
          ),
          charts.PanBehavior(),
        ],
      ),
    );
  }
}
