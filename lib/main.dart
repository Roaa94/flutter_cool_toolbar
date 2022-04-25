import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'TitilliumWeb',
        primarySwatch: Colors.pink,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CoolToolbar(),
        ),
      ),
    );
  }
}

class ToolbarItemData {
  final String title;
  final Color color;
  final IconData icon;

  ToolbarItemData({
    required this.title,
    required this.color,
    required this.icon,
  });
}

List<ToolbarItemData> toolbarItems = [
  ToolbarItemData(
    title: 'Edit',
    color: Colors.pinkAccent,
    icon: Icons.edit,
  ),
  ToolbarItemData(
    title: 'Delete',
    color: Colors.lightBlueAccent,
    icon: Icons.delete,
  ),
  ToolbarItemData(
    title: 'Comment',
    color: Colors.cyan,
    icon: Icons.comment,
  ),
  ToolbarItemData(
    title: 'Post',
    color: Colors.deepOrangeAccent,
    icon: Icons.post_add,
  ),
  ToolbarItemData(
    title: 'Favorite',
    color: Colors.pink,
    icon: Icons.star,
  ),
  ToolbarItemData(
    title: 'Details',
    color: Colors.amber,
    icon: Icons.details,
  ),
  ToolbarItemData(
    title: 'Languages',
    color: Colors.pinkAccent,
    icon: Icons.translate,
  ),
  ToolbarItemData(
    title: 'Settings',
    color: Colors.lightBlueAccent,
    icon: Icons.settings,
  ),
  ToolbarItemData(
    title: 'Edit',
    color: Colors.pinkAccent,
    icon: Icons.edit,
  ),
  ToolbarItemData(
    title: 'Delete',
    color: Colors.lightBlueAccent,
    icon: Icons.delete,
  ),
  ToolbarItemData(
    title: 'Comment',
    color: Colors.cyan,
    icon: Icons.comment,
  ),
  ToolbarItemData(
    title: 'Post',
    color: Colors.deepOrangeAccent,
    icon: Icons.post_add,
  ),
  ToolbarItemData(
    title: 'Favorite',
    color: Colors.pink,
    icon: Icons.star,
  ),
  ToolbarItemData(
    title: 'Details',
    color: Colors.amber,
    icon: Icons.details,
  ),
  ToolbarItemData(
    title: 'Languages',
    color: Colors.pinkAccent,
    icon: Icons.translate,
  ),
  ToolbarItemData(
    title: 'Settings',
    color: Colors.lightBlueAccent,
    icon: Icons.settings,
  ),
];

class Constants {
  static const double itemsGutter = 10;
  static const double toolbarHeight = 420;
  static const double toolbarWidth = 70;
  static const double itemsOffset = toolbarWidth - 10;
  static const int itemsInView = 7;
  static const double toolbarVerticalPadding = 10;
  static const double toolbarHorizontalPadding = 10;

  static const Duration longPressAnimationDuration =
      Duration(milliseconds: 400);
  static const Duration scrollScaleAnimationDuration =
      Duration(milliseconds: 700);

  static const Curve longPressAnimationCurve = Curves.easeOutSine;
  static const Curve scrollScaleAnimationCurve = Curves.ease;
}

class CoolToolbar extends StatefulWidget {
  const CoolToolbar({Key? key}) : super(key: key);

  @override
  _CoolToolbarState createState() => _CoolToolbarState();
}

class _CoolToolbarState extends State<CoolToolbar>
    with SingleTickerProviderStateMixin {
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

class ToolbarItem extends StatelessWidget {
  const ToolbarItem(
    this.toolbarItem, {
    required this.height,
    required this.scrollScale,
    this.isLongPressed = false,
    this.gutter = 10,
    Key? key,
  }) : super(key: key);

  final ToolbarItemData toolbarItem;
  final double height;
  final double scrollScale;
  final bool isLongPressed;
  final double gutter;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: height + gutter,
        child: Stack(
          children: [
            AnimatedScale(
              scale: scrollScale,
              duration: Constants.scrollScaleAnimationDuration,
              curve: Constants.scrollScaleAnimationCurve,
              child: AnimatedContainer(
                duration: Constants.longPressAnimationDuration,
                curve: Constants.longPressAnimationCurve,
                height: height + (isLongPressed ? 10 : 0),
                width: isLongPressed ? Constants.toolbarWidth * 2 : height,
                decoration: BoxDecoration(
                  color: toolbarItem.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  bottom: gutter,
                  left: isLongPressed ? Constants.itemsOffset : 0,
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedPadding(
                duration: Constants.longPressAnimationDuration,
                curve: Constants.longPressAnimationCurve,
                padding: EdgeInsets.only(
                  bottom: gutter,
                  left: 12 + (isLongPressed ? Constants.itemsOffset : 0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedScale(
                      scale: scrollScale,
                      duration: Constants.scrollScaleAnimationDuration,
                      curve: Constants.scrollScaleAnimationCurve,
                      child: Icon(
                        toolbarItem.icon,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedOpacity(
                        duration: Constants.longPressAnimationDuration,
                        curve: Constants.longPressAnimationCurve,
                        opacity: isLongPressed ? 1 : 0,
                        child: Text(
                          toolbarItem.title,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
