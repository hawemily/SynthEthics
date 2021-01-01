import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/achievements_page/achievement.dart';
import 'package:synthetics/services/achievements/achievement_images.dart';
import 'package:synthetics/theme/custom_colours.dart';

class ExpandedAchievementCard extends StatefulWidget {
  final Achievement achievement;
  final Function onClose;

  const ExpandedAchievementCard({Key key,
    this.achievement, this.onClose}) : super(key: key);

  @override
  _ExpandedAchievementCardState createState() => _ExpandedAchievementCardState();
}

class _ExpandedAchievementCardState extends State<ExpandedAchievementCard> {
  @override
  Widget build(BuildContext context) {
    Widget achievementTypeWidget;

    // Prevent division by 0
    int progressDenominator = widget.achievement.nextTarget -
        widget.achievement.previousTarget;
    progressDenominator = (progressDenominator == 0) ?
      widget.achievement.progressToTarget : progressDenominator;

    if (widget.achievement.type == AchievementType.Tiered) {
      achievementTypeWidget = Column (
          children : [
          Expanded(
            flex: 2,
            child: Center(
              child: Text("Level : " + widget.achievement.level.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: widget.achievement.progressToTarget / progressDenominator,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColours.iconGreen()),
                  backgroundColor: CustomColours.offWhite(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.achievement.previousTarget.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w200
                  ),
                ),
                Text((widget.achievement.progressToTarget +
                    widget.achievement.previousTarget).toString() +
                    "/" + widget.achievement.nextTarget.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w400
                  ),
                ),
                Text(widget.achievement.nextTarget.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w800
                  ),
                )
              ],
            ),
          ),
        ]);
    } else {
      achievementTypeWidget = Center(
        child: Text((widget.achievement.achieved) ?
          "Achieved!" : "Not yet achieved",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: (widget.achievement.achieved) ? CustomColours.iconGreen() :
                CustomColours.negativeRed()
          )
        ),
      );
    }

    List<Expanded> achievementCardElements = [
      Expanded(
        flex: 5,
        child:(widget.achievement.type == AchievementType.Unlock)
            ? AchievementImages
            .retrieveOneTimeImage(widget.achievement.id)
            : AchievementImages
            .retrieveLevelImage(widget.achievement.id,
            widget.achievement.level),
      )
    ];
    achievementCardElements.add(Expanded(
      flex: 3,
      child: achievementTypeWidget
    ));
    achievementCardElements.add(Expanded(
        flex: 2,
        child: Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: CustomColours.iconGreen(),
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: Center(
            child: Text(widget.achievement.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: CustomColours.offWhite()
              )
            ),
          ),
        )
    ));

    return Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Stack(
                  children: [
                    Center(
                        child : Text(widget.achievement.name.toUpperCase(),
                          style: TextStyle(
                              color: CustomColours.offWhite(),
                              fontWeight: FontWeight.bold
                          ),)
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: CustomColours.offWhite(),
                            ),
                            onPressed: () => widget.onClose()
                        )
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: CustomColours.greenNavy(),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: achievementCardElements,
                ),
              ),
            ),
          ]
        )
    );
  }
}
