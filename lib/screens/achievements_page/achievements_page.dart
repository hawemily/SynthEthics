import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synthetics/screens/achievements_page/achievement.dart';
import 'package:synthetics/screens/achievements_page/achievement_card_expanded.dart';
import 'package:synthetics/screens/achievements_page/achievement_card_preview.dart';
import 'package:synthetics/services/achievements/achievement_calculator.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/services/initialiser/initialiser.dart';
import 'package:synthetics/theme/custom_colours.dart';

class AchievementsPage extends StatefulWidget {
  final Function onClose;

  const AchievementsPage({Key key, this.onClose}) : super(key: key);

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  Widget _expandedAchievement;
  List<Achievement> achievements = [];

  void getAchievements() async {
    String uid = CurrentUser.getInstance().getUID();
    print("uid: $uid");
    await api_client.get("/getAchievements/" + uid)
        .then((result) {
      List<dynamic> jsonAchievements = json.decode(result.body);

      // First sort by ID
      jsonAchievements.sort((a, b) =>
          a["data"]["achievementId"] < (b["data"]["achievementId"]) ? - 1 : 1);

      // Then for each achievement we parse data and calculate the levelling
      // data if the achievement is tiered
      setState(() {
        achievements = jsonAchievements.map((achievementJson) {
          dynamic achievementData = achievementJson["data"];
          dynamic userData = achievementJson["user"];

          AchievementType type = AchievementType
              .values[achievementData["achievementType"]];

          if (type == AchievementType.Tiered) {
            dynamic levelData = AchievementLevelCalculator.calculate(
              achievementData["achievementTiers"],
              userData[achievementData["achievementAttribute"]]);
            return Achievement(
              id: achievementData["achievementId"],
              name: achievementData["achievementName"],
              description: achievementData["achievementDescription"],
              type: type,
              achieved: achievementJson["achievedStatus"],
              level: levelData["level"],
              previousTarget: levelData["previousAmount"],
              nextTarget: levelData["targetAmount"],
              progressToTarget: levelData["progress"]
            );
          }
          return Achievement(
            id: achievementData["achievementId"],
            name: achievementData["achievementName"],
            description: achievementData["achievementDescription"],
            type: type,
            achieved: achievementJson["achievedStatus"],
          );
        }).toList();
      });
    });
  }

  @override
  void initState() {
    LocalDatabaseInitialiser.initAchievements().then((res) {
      getAchievements();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5))),
      margin: EdgeInsets.fromLTRB(30, 100, 30, 100),
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
