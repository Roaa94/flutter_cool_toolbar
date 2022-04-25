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
  /// Scroll controller to be hooked with the items list
  late ScrollController scrollController;

  double get itemHeight =>
      Constants.toolbarWidth - (Constants.toolbarHorizontalPadding * 2);

  /// List of item scales
  ///
  /// item at index [x] has scale of [itemScrollScaleValues[x]]
  List<double> itemScrollScaleValues = [];

  /// List of item y positions
  ///
  /// item at index [x] has y position of [itemYPositions[x]]
  /// The position is of the top edge of each item and is local to the toolbar container
  List<double> itemYPositions = [];

  /// List of bool values indicating long press
  ///
  /// item at index [x] is long pressed id [itemYPositions[x]] is true
  List<bool> longPressedItemsFlags = [];

  void scrollListener() {
    if (scrollController.hasClients) {
      _updateItemsScrollData(
        scrollPosition: scrollController.position.pixels,
      );
    }
  }

  /// Updates scale values and item positions
  /// based on the current scroll position
  ///
  /// Called inside scrollListener to update [itemScrollScaleValues] & [itemYPositions]
  void _updateItemsScrollData({double scrollPosition = 0}) {
    List<double> _itemScrollScaleValues = [];
    List<double> _itemYPositions = [];
    for (int i = 0; i <= toolbarItems.length - 1; i++) {
      double itemTopPosition = i * (itemHeight + Constants.itemsGutter);
      // Storing y position values of the items with the scrollPosition value subtracted
      // gives the location of the item relative to the toolbar container
      // For example, at first, item 1 is at the top with a position of 0,
      // but when scrolled a distance of 20, item 2's position is now it's previous position
      // (let's say 20) minus the scrolled distance, making it at the correct position when
      // a long press event is received at this location
      _itemYPositions.add(itemTopPosition - scrollPosition);

      // Difference between the position of the top edge of the item
      // and the position of the bottom edge of the toolbar container plus scroll position
      // A negative value means that the item is out of view below the toolbar container
      double distanceToMaxScrollExtent =
          Constants.toolbarHeight + scrollPosition - itemTopPosition;

      // Position of the bottom edge of the item
      double itemBottomPosition =
          (i + 1) * (itemHeight + Constants.itemsGutter);
      // An item is out of view if it's out of view below the toolbar
      // OR if it's out of view above the toolbar (where the scroll position is further than
      // the position of the bottom edge of the item
      bool itemIsOutOfView =
          distanceToMaxScrollExtent < 0 || scrollPosition > itemBottomPosition;

      // If the item is out of view, scale it down, if it's visible, reset it to default scale
      _itemScrollScaleValues.add(itemIsOutOfView ? 0.4 : 1);
    }
    setState(() {
      itemScrollScaleValues = _itemScrollScaleValues;
      itemYPositions = _itemYPositions;
    });
  }

  /// Updates [longPressedItemsFlags] based on the location of the long press event
  ///
  /// Should be called whenever a long-press related event happens
  /// e.g. Long press started, ended, cancelled, moved while pressed, ...etc.
  void _updateLongPressedItemsFlags({double longPressYLocation = 0}) {
    List<bool> _longPressedItemsFlags = [];
    for (int i = 0; i <= toolbarItems.length - 1; i++) {
      // An item is long pressed if the long press y location is larger than the current
      // item's top edge position and smaller than the next items top edge position
      // If there is no next item, the long press y location should be smaller
      // than the scrollable area (the height of the toolbar_
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
