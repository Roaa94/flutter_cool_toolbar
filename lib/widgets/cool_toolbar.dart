import 'package:cool_tool_bar/constants.dart';
import 'package:cool_tool_bar/items.dart';
import 'package:cool_tool_bar/widgets/toolbar_item.dart';
import 'package:flutter/material.dart';

class CoolToolbar extends StatefulWidget {
  const CoolToolbar({Key? key}) : super(key: key);

  @override
  _CoolToolbarState createState() => _CoolToolbarState();
}

class _CoolToolbarState extends State<CoolToolbar> {
  late ScrollController scrollController;

  double get itemHeight =>
      Constants.toolbarWidth - (Constants.toolbarHorizontalPadding * 2);

  void scrollListener() {
    if (scrollController.hasClients) {
      _updateItemsScrollData(
        scrollPosition: scrollController.position.pixels,
      );
    }
  }

  List<double> itemScrollScaleValues = [];
  List<double> itemYPositions = [];

  void _updateItemsScrollData({double scrollPosition = 0}) {
    List<double> _itemScrollScaleValues = [];
    List<double> _itemYPositions = [];
    for (int i = 0; i <= toolbarItems.length - 1; i++) {
      double itemTopPosition = i * (itemHeight + Constants.itemsGutter);
      _itemYPositions.add(itemTopPosition - scrollPosition);

      double itemBottomPosition =
          (i + 1) * (itemHeight + Constants.itemsGutter);
      double distanceToMaxScrollExtent =
          Constants.toolbarHeight + scrollPosition - itemTopPosition;
      bool itemIsOutOfView =
          distanceToMaxScrollExtent < 0 || scrollPosition > itemBottomPosition;
      _itemScrollScaleValues.add(itemIsOutOfView ? 0.4 : 1);
    }
    setState(() {
      itemScrollScaleValues = _itemScrollScaleValues;
      itemYPositions = _itemYPositions;
    });
  }

  List<bool> longPressedItemsFlags = [];

  void _updateLongPressedItemsFlags({double longPressYLocation = 0}) {
    List<bool> _longPressedItemsFlags = [];
    for (int i = 0; i <= toolbarItems.length - 1; i++) {
      bool isLongPressed = itemYPositions[i] >= 0 &&
          longPressYLocation > itemYPositions[i] &&
          longPressYLocation <
              (itemYPositions.length > i + 1
                  ? itemYPositions[i + 1]
                  : Constants.toolbarHeight);
      _longPressedItemsFlags.add(isLongPressed);
    }
    setState(() {
      longPressedItemsFlags = _longPressedItemsFlags;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateItemsScrollData();
    _updateLongPressedItemsFlags();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.toolbarHeight,
      margin: const EdgeInsets.only(left: 20, top: 90),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: Constants.toolbarWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onLongPressStart: (LongPressStartDetails details) {
              _updateLongPressedItemsFlags(
                longPressYLocation: details.localPosition.dy,
              );
            },
            onLongPressMoveUpdate: (details) {
              _updateLongPressedItemsFlags(
                longPressYLocation: details.localPosition.dy,
              );
            },
            onLongPressEnd: (LongPressEndDetails details) {
              _updateLongPressedItemsFlags(longPressYLocation: 0);
            },
            onLongPressCancel: () {
              _updateLongPressedItemsFlags(longPressYLocation: 0);
            },
            child: ListView.builder(
              controller: scrollController,
              // clipBehavior: Clip.none,
              padding: const EdgeInsets.all(10),
              itemCount: toolbarItems.length,
              itemBuilder: (c, i) => ToolbarItem(
                toolbarItems[i],
                height: itemHeight,
                scrollScale: itemScrollScaleValues[i],
                isLongPressed: longPressedItemsFlags[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
