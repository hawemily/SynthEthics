import 'package:flutter/cupertino.dart';
import 'package:synthetics/components/carma_chart/carma_chart.dart';
import 'package:synthetics/components/carma_chart/carma_series.dart';
import 'package:synthetics/components/carma_chart/carma_stat.dart';
import 'package:synthetics/theme/custom_colours.dart';

enum CarmaViewResolution {
  WEEK, MONTH, YEAR
}

class CarmaResolutionView extends StatefulWidget {
  final CarmaViewResolution resolution;

  const CarmaResolutionView({Key key, this.resolution}) : super(key: key);

  @override
  _CarmaResolutionViewState createState() => _CarmaResolutionViewState();
}

class _CarmaResolutionViewState extends State<CarmaResolutionView> {
  @override
  Widget build(BuildContext context) {

    // Temp carma values
    List<CarmaSeries> data;

    if (widget.resolution == CarmaViewResolution.WEEK) {
      data = [
        CarmaSeries(dateLabel: "MON", carma: 51),
        CarmaSeries(dateLabel: "TUE", carma: 240),
        CarmaSeries(dateLabel: "WED", carma: 120),
        CarmaSeries(dateLabel: "THU", carma: 99),
        CarmaSeries(dateLabel: "FRI", carma: 0),
        CarmaSeries(dateLabel: "SAT", carma: 133),
        CarmaSeries(dateLabel: "SUN", carma: 240),
      ];
    } else if (widget.resolution == CarmaViewResolution.MONTH) {
      data = [
        CarmaSeries(dateLabel: "JN", carma: 2901),
        CarmaSeries(dateLabel: "FB", carma: 2403),
        CarmaSeries(dateLabel: "MR", carma: 1230),
        CarmaSeries(dateLabel: "AP", carma: 2399),
        CarmaSeries(dateLabel: "MY", carma: 122),
        CarmaSeries(dateLabel: "JN", carma: 1323),
        CarmaSeries(dateLabel: "JY", carma: 2405),
        CarmaSeries(dateLabel: "AG", carma: 1403),
        CarmaSeries(dateLabel: "SP", carma: 2230),
        CarmaSeries(dateLabel: "OT", carma: 1300),
        CarmaSeries(dateLabel: "NV", carma: 0),
        CarmaSeries(dateLabel: "DC", carma: 0),
      ];
    } else {
      data = [
        CarmaSeries(dateLabel: "2016", carma: 19223),
        CarmaSeries(dateLabel: "2017", carma: 9002),
        CarmaSeries(dateLabel: "2018", carma: 13040),
        CarmaSeries(dateLabel: "2019", carma: 19223),
        CarmaSeries(dateLabel: "2020", carma: 9002),
      ];
    }

    return Container(
      child : Column(
        children: [
          Expanded(
            flex: 6,
            child: CarmaChart(data: data),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CarmaStat(
                  statColor: CustomColours.iconGreen(),
                  statLabel: "Bought",
                  statValue: 3,
                ),
                CarmaStat(
                  statColor: CustomColours.negativeRed(),
                  statLabel: "Worn",
                  statValue: 0,
                ),
                CarmaStat(
                  statColor: CustomColours.iconGreen(),
                  statLabel: "Recycled",
                  statValue: 3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
