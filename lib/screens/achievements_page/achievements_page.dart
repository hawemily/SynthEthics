import 'package:flutter/material.dart';
import 'package:synthetics/screens/achievements_page/achievement.dart';
import 'package:synthetics/screens/achievements_page/achievement_card_expanded.dart';
import 'package:synthetics/screens/achievements_page/achievement_card_preview.dart';
import 'package:synthetics/theme/custom_colours.dart';

class AchievementsPage extends StatefulWidget {
  final Function onClose;

  const AchievementsPage({Key key, this.onClose}) : super(key: key);

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  Widget _expandedAchievement;
  List<Achievement> achievements = [
    Achievement(type: AchievementType.Unlock),
    Achievement(type: AchievementType.Tiered),
    Achievement(type: AchievementType.Unlock),
    Achievement(type: AchievementType.Tiered),
    Achievement(type: AchievementType.Unlock),
    Achievement(type: AchievementType.Tiered)
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5))),
      margin: EdgeInsets.all(30),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: (_expandedAchievement == null)
            ? Column(children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          "Achievements",
                          style: TextStyle(
                              color: CustomColours.offWhite(),
                              fontWeight: FontWeight.bold),
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: CustomColours.offWhite(),
                                ),
                                onPressed: () => widget.onClose())
                          ],
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: CustomColours.greenNavy(),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 15),
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(5),
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      crossAxisCount: 3,
                      children: achievements
                          .map((achievement) => PreviewAchievementCard(
                                achievement: achievement,
                                onClick: _expandAchievement,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ])
            : _expandedAchievement,
      ),
    );
  }

  void _collapseAchievement() {
    setState(() {
      _expandedAchievement = null;
    });
  }

  void _expandAchievement(Achievement achievementData) {
    setState(() {
      _expandedAchievement = new ExpandedAchievementCard(
          achievement: achievementData, onClose: _collapseAchievement);
    });
  }
}
