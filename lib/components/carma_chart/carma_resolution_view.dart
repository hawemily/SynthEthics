import 'package:flutter/cupertino.dart';
import 'package:synthetics/components/carma_chart/carma_chart.dart';
import 'package:synthetics/components/carma_chart/carma_series.dart';
import 'package:synthetics/components/carma_chart/carma_stat.dart';
import 'package:synthetics/theme/custom_colours.dart';

class CarmaResolutionView extends StatefulWidget {
  final List<CarmaSeries> data;

  const CarmaResolutionView({Key key, this.data}) : super(key: key);

  @override
  _CarmaResolutionViewState createState() => _CarmaResolutionViewState();
}

class _CarmaResolutionViewState extends State<CarmaResolutionView> {
  @override
  Widget build(BuildContext context) {

    return Container(
      child : Column(
        children: [
          Expanded(
            flex: 6,
            child: CarmaChart(data: widget.data),
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
