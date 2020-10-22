import 'package:flutter/material.dart';

import 'donation_card.dart';

class SuggestionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(20),
      child: ListView(
        children: [
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Swipe down to hide',
                textAlign: TextAlign.center,
              )),
          DonationCard(
            name: 'Amys Shop',
            address: 'W5 8JY',
            distance: 2.0,
          ),
          DonationCard(
            name: 'Oxfam',
            address: 'SW5 6GK',
            distance: 5.0,
          ),
          DonationCard(
            name: 'British Heart Foundation',
            address: 'E14 8BV',
            distance: 8.0,
          )
        ],
      ),
    );
  }
}
