import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/requestObjects/donated_item_metadata.dart';
import 'package:synthetics/requestObjects/items_to_donate_request.dart';
import 'package:synthetics/responseObjects/clothingTypeObject.dart';
import 'package:synthetics/screens/closet_page/closet_container.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/screens/closet_page/closet_suggestion_page.dart';
import 'package:synthetics/screens/image_taker_page/add_to_closet_page.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/responseObjects/getClosetResponse.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';

import 'closet_donation_page.dart';

enum ClosetMode { Normal, Select, Donate, UnDonate, Donated }

class Closet extends StatefulWidget {
  Closet({Key key, this.selectingOutfit = false}) : super(key: key);

  final bool selectingOutfit;

  final List<String> categories = [
    "All",
    "Tops",
    "Bottoms",
    "Dresses",
    "Outerwear",
    "Accessories",
    "To Be Donated",
    "Suggested Donations"
  ];

  @override
  _ClosetState createState() => _ClosetState();
}

class _ClosetState extends State<Closet> with SingleTickerProviderStateMixin {
  List<Tab> _tabs;
  TabController _tabController;
  CurrentUser user = CurrentUser.getInstance();

  //Future<List<String>> categories;
  Future<GetClosetResponse> clothingItems;
  Future<ClothingTypeObject> confirmedDonations;

  // can use to hold unconfirmed 'to be donated' clothes, 'undonate' clothes etc
  Set<DonatedItemMetadata> tempClothingBin = Set();

  //Outfit selection
  Set<String> outfitItems = Set();
  bool _savingInProgress = false;

  ClosetMode _mode = ClosetMode.Normal;
  String uid = CurrentUser.getInstance().getUID();

  @override
  void initState() {
    super.initState();
    if (widget.selectingOutfit) {
      _mode = ClosetMode.Select;
    }
    //TODO: call api to init categories from backend using collecitons
    // categories = getCategories();
    List<String> categories = widget.categories;
    confirmedDonations = this.getDonatedItems();
    clothingItems = this.getClothes();

//    confirmedDonations = ;
    print(categories);
    _tabs = <Tab>[for (String c in categories) Tab(text: c)];

    _tabController = TabController(
        vsync: this,
        initialIndex: 1,
        length: widget.selectingOutfit ? (_tabs.length - 2) : _tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  setMode(ClosetMode mode) {
    print("set mode is called $mode");
    setState(() {
      _mode = mode;
    });
  }

  Future<List<String>> getCategories() async {
    final resp = await api_client.get("/getAllClothingTypes");

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      final clothingTypes = body['clothingTypes'];
      return clothingTypes;
    }
  }

  Future<ClothingTypeObject> getDonatedItems() async {
    print("get all items marked as to be donated from backend");
    final response =
        await api_client.get("/closet/allDonatedItems/" + user.getUID());

    if (response.statusCode == 200) {
      print("respBodyInGetDonatedIitems: ${response.body}");
      final resBody = jsonDecode(response.body);
      final toBeDonated = ClothingTypeObject.fromJson(resBody);
      print("final to be donated list: ");
      toBeDonated.clothingItems.forEach((element) {
        print(element);
      });
      return toBeDonated;
    } else {
      throw Exception("Failed to load donatedItems");
    }
  }

//  Future<ClothingTypeObject> getDonationCenterClothes() async {
//    final resp = await api_client.get("/closet/allItemsSentToDonation" + user.getUID());
//
//    if (resp.statusCode == 200) {
//      print("donationCenterResponseBody, line 127: ${resp.body}");
//      final resBody = jsonDecode(resp.body);
//      final donationItems = ClothingTypeObject.fromJson(resBody);
//      print("final donation items: ");
//      donationItems.clothingItems.forEach((e) {
//        print(e);
//      });
//      return donationItems;
//    } else {
//      throw Exception("Failed to load donation center items at line 136 of closet_page.dart!");
//    }
//  }

  Future<GetClosetResponse> getClothes() async {
    print("trying get all clothes from backend");
    final response =
        await api_client.get("/closet/allClothes/" + user.getUID());

    if (response.statusCode == 200) {
//      print("respBody: ${response.body}");
      final resBody = jsonDecode(response.body);
      final closet = GetClosetResponse.fromJson(resBody);
//      print("itemsInCloset");
//      closet.clothingTypes.forEach((element) {print(element.clothingType); print(element.clothingItems);});
      return closet;
    } else {
      throw Exception("Failed to load closet");
    }
  }

  bool isSelectedForDonation(String id) {
    return tempClothingBin.firstWhere((el) => el.id == id,
            orElse: () => null) !=
        null;
  }

  bool isSelectedForOutfit(String id) {
    return outfitItems.firstWhere((el) => el == id, orElse: () => null) != null;
  }

  void addToOutfit(String id, bool toAddToOutfit) {
    if (toAddToOutfit) {
      print("Adding item to outfit, the id is ");
      print(id);
      outfitItems.add(id);
    } else {
      outfitItems.remove(id);
    }
  }

  void donateClothingItem(String id, bool toDonate) {
    if (toDonate) {
      tempClothingBin.add(new DonatedItemMetadata(id));
    } else {
      tempClothingBin.remove(new DonatedItemMetadata(id));
    }
  }

  void undonateClothingItem(String id, bool isSelected) {
    donateClothingItem(id, isSelected);
  }

  Future<void> donateSelected() async {
    print("DONATE SELECTED");
    if (tempClothingBin.isEmpty) {
      setState(() {
        _mode = ClosetMode.Normal;
      });
      return;
    }
    print(tempClothingBin);

    var ls = tempClothingBin.map((each) => each.id).toList();

    await api_client
        .post("/markForDonation",
            body:
                jsonEncode(<String, dynamic>{'uid': user.getUID(), 'ids': ls}))
        .then((e) async {
      print("in closet container");
      print(e.statusCode);
      print(e.body);
      setState(() {
        confirmedDonations = this.getDonatedItems();
        clothingItems = this.getClothes();
        tempClothingBin.clear();
      });

      var donations = await confirmedDonations;
      var clothes = await clothingItems;

      return;
    });
  }

  Future<void> undonateSelected() async {
    if (tempClothingBin.isEmpty) {
      setState(() {
        _mode = ClosetMode.Normal;
      });
      return;
    }
    print(tempClothingBin);

    var ls = tempClothingBin.map((each) => each.id).toList();

    await api_client
        .post("/unmarkForDonation",
            body:
                jsonEncode(<String, dynamic>{'uid': user.getUID(), 'ids': ls}))
        .then((e) async {
      setState(() {
        confirmedDonations = this.getDonatedItems();
        clothingItems = this.getClothes();
        tempClothingBin.clear();
      });

      var donations = await confirmedDonations;
      var clothes = await clothingItems;

      return;
    });
  }

  void sendToDonationCenter() {
    print("DONATION CENTER SELECTED");
    if (tempClothingBin.isEmpty) {
      setState(() {
        _mode = ClosetMode.Normal;
      });
      return;
    }
    print(tempClothingBin);
    var ls = tempClothingBin.map((each) => each.id).toList();

    api_client
        .post("/markDonated",
            body:
                jsonEncode(<String, dynamic>{'uid': user.getUID(), 'ids': ls}))
        .then((e) {
      print("in closet container");
      print(e.statusCode);
      print(e.body);
      setState(() {
        tempClothingBin.clear();
        _mode = ClosetMode.Normal;
        confirmedDonations = this.getDonatedItems();
      });
    });
  }

  void showConfirmDonationsDialog(BuildContext context) {
    Widget confirmButton = FlatButton(
        child: Text(
          "OK",
          style: TextStyle(color: CustomColours.greenNavy()),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          this.sendToDonationCenter();
        });

    AlertDialog alert = AlertDialog(
      title: Text("Are all the donated items correct?"),
      content: Text(
        "This action is not reversible. All items that have been marked for donation will no longer be in your closet.",
        textAlign: TextAlign.justify,
      ),
      actions: [
        confirmButton,
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void showConfirmationSuggestionsDialog(BuildContext context) {
    Widget confirmButton = FlatButton(
        child: Text(
          "OK",
          style: TextStyle(color: CustomColours.greenNavy()),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          donateSelected().then((e) => setMode(ClosetMode.Normal));
        });

    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you want to donate these?"),
      content: Text(
        "All items that have been marked for donation will no longer be in your closet and all outfits with these items will be removed from dressing room.",
        textAlign: TextAlign.justify,
      ),
      actions: [
        confirmButton,
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void outfitSelected() async {
    setState(() {
      _savingInProgress = true;
    });

    print("OUTFIT SELECTED");
    if (outfitItems.isEmpty) {
      Navigator.pop(context, "none");
      return;
    }
    var items = outfitItems.toList();
    print("printing list of items for outfit before pushing");
    print(items);

    print(jsonEncode(<String, dynamic>{'name': "outfitName", 'ids': items}));
    // put in try, loading icon
    await api_client
        .post("/postOutfit",
            body: jsonEncode(<String, dynamic>{
              'uid': user.getUID(),
              'name': "outfitName",
              'ids': items
            }))
        .then((e) {
      print("in closet container");
      print(e.statusCode);
      print(e.body);
      setState(() {
        outfitItems.clear();
        _mode = ClosetMode.Normal;
      });
    });
    Navigator.pop(context);
  }

  Widget generateCloset(String type) {
    return FutureBuilder<GetClosetResponse>(
        future: clothingItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ClothingTypeObject> clothingTypes =
                snapshot.data.clothingTypes.where((e) {
              return e.clothingType == type;
            }).toList();
            List<ClothingItemObject> ls = type == "All"
                ? snapshot.data.clothingTypes
                    .map((t) => t.clothingItems)
                    .expand((x) => x)
                    .toList()
                : clothingTypes.first.clothingItems;

            return ClosetContainer(
              _mode,
              clothingItemObjects: ls,
              setMode: setMode,
              action: widget.selectingOutfit ? addToOutfit : donateClothingItem,
              isFlipped: isSelectedForDonation,
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text(
                "Unable to load clothes from closet! Please contact admin for support");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget generateDonationPage() {
    setState(() {
      confirmedDonations = this.getDonatedItems();
      clothingItems = this.getClothes();
    });

    return FutureBuilder<ClothingTypeObject>(
        future: confirmedDonations,
        builder: (context, snapshot) {
          print("generating donated items in generate donation page");
          if (snapshot.hasData) {
            print(snapshot.data.clothingItems);
            return ClosetDonationPage(
                setMode: setMode,
                mode: _mode,
                action: undonateClothingItem,
                isInDonationList: isSelectedForDonation,
                donatedItems: snapshot.data.clothingItems);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Unable to load donated items");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget generateSuggestionPage() {
    return FutureBuilder<GetClosetResponse>(
        future: clothingItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ClothingItemObject> allSuggestions = [];

            snapshot.data.clothingTypes.forEach((i) {
              List<ClothingItemObject> listClothingItems = i.clothingItems;
              listClothingItems.forEach((element) {
                DateTime lastWorn = DateTime.parse(element.data.lastWornDate);
                if (lastWorn.difference(DateTime.now()).inDays < 30) {
                  allSuggestions.add(element);
                }
              });
            });

            return ClosetSuggestionPage(
                setMode: setMode,
                mode: _mode,
                suggestedItems: allSuggestions,
                donate: donateClothingItem,
                isUnconfirmedDonation: isSelectedForDonation);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Unable to load suggested items");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  bool _notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];
    if (_mode == ClosetMode.Donate || _mode == ClosetMode.Donated) {
      actions.add(Padding(
          padding: EdgeInsets.all(10.0),
          child: RaisedButton(
              color: CustomColours.greenNavy(),
              child: Text('Done',
                  style:
                      TextStyle(fontSize: 16, color: CustomColours.offWhite())),
              onPressed: _mode == ClosetMode.Donate
                  ? () {
                      showConfirmationSuggestionsDialog(context);
                    }
                  : () {
                      showConfirmDonationsDialog(context);
                    })));
    } else if (_mode == ClosetMode.UnDonate) {
      actions.add(Padding(
          padding: EdgeInsets.all(10.0),
          child: RaisedButton(
              color: CustomColours.greenNavy(),
              child: Text('Done',
                  style:
                      TextStyle(fontSize: 16, color: CustomColours.offWhite())),
              onPressed: () {
                undonateSelected().then((e) => setMode(ClosetMode.Normal));
              })));
    } else if (widget.selectingOutfit) {
      actions.add(Padding(
          padding: EdgeInsets.all(10.0),
          child: RaisedButton(
              color: CustomColours.greenNavy(),
              child: ((!_savingInProgress)
                  ? Text('Finish Outfit',
                      style: TextStyle(
                          fontSize: 16, color: CustomColours.offWhite()))
                  : CircularProgressIndicator()),
              onPressed: outfitSelected)));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColours.greenNavy(),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
            _mode == ClosetMode.Donate
                ? 'Select Donations'
                : _mode == ClosetMode.UnDonate
                    ? 'Undo Donations'
                    : _mode == ClosetMode.Donated
                        ? 'Mark Donated'
                        : 'Closet',
            style: TextStyle(color: Colors.white)),
        actions: actions,
        bottom: TabBar(
            tabs: widget.selectingOutfit
                ? _tabs.sublist(0, _tabs.length - 2)
                : _tabs,
            controller: _tabController,
            isScrollable: true,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            onTap: (index) {
              setState(() {
                _tabController.index = _mode == ClosetMode.UnDonate
                    ? widget.categories.indexOf("To Be Donated")
                    : _mode == ClosetMode.Donate
                        ? widget.categories.indexOf("Suggested Donations")
                        : index;
              });
            }),
      ),
      // call future builder here
      body: TabBarView(
        controller: _tabController,
        children: _tabs
            .map((Tab tab) {
              final String label = tab.text;
              if (label == "To Be Donated") {
                if (!widget.selectingOutfit) {
                  return generateDonationPage();
                } else {
                  return null;
                }
              } else if (label == "Suggested Donations") {
                if (!widget.selectingOutfit) {
                  return generateSuggestionPage();
                } else {
                  return null;
                }
              } else {
                return generateCloset(tab.text);
              }
            })
            .where(_notNull)
            .toList(),
      ),
      bottomNavigationBar: NavBar(selected: 1),
    );
//        ClosetContainer(clothingIds: List.generate(20, (index) => index))
  }
}
