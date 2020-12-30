import 'package:flutter/cupertino.dart';
import 'package:synthetics/components/carma_chart/carma_chart.dart';
import 'package:synthetics/components/carma_chart/carma_series.dart';

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
        ],
      ),
    );
  }
}
