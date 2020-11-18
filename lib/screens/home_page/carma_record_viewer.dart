import 'package:flutter/material.dart';
import 'package:synthetics/components/carma_chart/carma_resolution_view.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';

class CarmaRecordViewer extends StatefulWidget {
  @override
  _CarmaRecordViewerState createState() => _CarmaRecordViewerState();
}

class _CarmaRecordViewerState extends State<CarmaRecordViewer> {

  @override
  void initState() {
    // We want to retrieve the carma records from backend and
    // put them into a format we require
    getCarmaRecords();

    super.initState();
  }

  void getCarmaRecords() async {
    String uid = CurrentUser.getInstance().getUID();
    await api_client.get("/getCarmaRecords", headers: {"uid" : uid})
      .then((result) {
       print("carma records: " + result.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: CustomColours.greenNavy(),
                  child: TabBar(
                    labelColor: CustomColours.greenNavy(),
                    unselectedLabelColor:
                    CustomColours.offWhite(),
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                            color: CustomColours.offWhite())),
                    tabs: [
                      CarmaResolutionTab(label: "WEEK"),
                      CarmaResolutionTab(label: "MONTH"),
                      CarmaResolutionTab(label: "YEAR"),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: TabBarView(
                  children: [
                    CarmaResolutionView(
                        resolution: CarmaViewResolution.WEEK),
                    CarmaResolutionView(
                        resolution: CarmaViewResolution.MONTH),
                    CarmaResolutionView(
                        resolution: CarmaViewResolution.YEAR),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}

class CarmaResolutionTab extends StatefulWidget {
  final String label;

  const CarmaResolutionTab({Key key, this.label}) : super(key: key);

  @override
  _CarmaResolutionTabState createState() => _CarmaResolutionTabState();
}

class _CarmaResolutionTabState extends State<CarmaResolutionTab> {
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        widget.label,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: CustomColours.offWhite()),
      ),
    );
  }
}