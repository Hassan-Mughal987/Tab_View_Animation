import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier with WidgetsBindingObserver {
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final ValueNotifier<double> overlayLeftNotifier = ValueNotifier(4);
  final ValueNotifier<Color> overlayColorNotifier = ValueNotifier(Colors.white);
  final ScrollController scrollController = ScrollController();
  final PageController pageController = PageController();

  bool _isProcessingPageChange = false;
  bool _isAnimating = false;
  bool _isDisposed = false;

  final List<String> tabNames = [
    "Popular",
    "Classic CinnaPack's",
    "MiniBon Cinnap!",
    "MiniBon",
    "MiniBon",
    "MiniBon",
    "Extra Tab 1",
    "Extra Tab 2",
    "Extra Tab 3",
    "Extra Tab 4",
    "Extra Tab 5",
  ];

  final List<List<String>> listItems = [
    ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"],
    ["Item 11", "Item 12", "Item 13", "Item 14", "Item 15", "Item 16", "Item 17", "Item 18", "Item 19", "Item 20"],
    ["Item A", "Item B", "Item C", "Item D", "Item E", "Item F", "Item G", "Item H", "Item I", "Item J"],
    ["Item X", "Item Y", "Item Z", "Item W", "Item V", "Item U", "Item T", "Item S", "Item R", "Item Q"],
    ["Item P", "Item Q", "Item R", "Item S", "Item T", "Item U", "Item V", "Item W", "Item X", "Item Y"],
    ["Item M", "Item N", "Item O", "Item P", "Item Q", "Item R", "Item S", "Item T", "Item U", "Item V"],
    ["Item D", "Item E", "Item F", "Item G", "Item H", "Item I", "Item J", "Item K", "Item L", "Item M"],
    ["Item G", "Item H", "Item I", "Item J", "Item K", "Item L", "Item M", "Item N", "Item O", "Item P"],
    ["Item J", "Item K", "Item L", "Item M", "Item N", "Item O", "Item P", "Item Q", "Item R", "Item S"],
    ["Item S", "Item T", "Item U", "Item V", "Item W", "Item X", "Item Y", "Item Z", "Item A", "Item B"],
    ["Item V", "Item W", "Item X", "Item Y", "Item Z", "Item A", "Item B", "Item C", "Item D", "Item E"],
  ];

  final Map<String, double> _tabWidths = {
    "Classic CinnaPack's": 150,
    "MiniBon Cinnap!": 150,
    "Popular": 70,
  };

  List<double> _cachedOverlayPositions = [];

  HomeProvider() {
    _precomputeOverlayPositions();
    WidgetsBinding.instance.addObserver(this);
  }

  void _precomputeOverlayPositions() {
    _cachedOverlayPositions.clear();
    double position = 4;
    for (int i = 0; i < tabNames.length; i++) {
      _cachedOverlayPositions.add(position);
      position += getContainerWidth(tabNames[i]) + 8;
    }
  }

  double _calculateOverlayPosition(int index) {
    return _cachedOverlayPositions[index];
  }

  double getContainerWidth(String text) {
    // Get device width to calculate responsive widths
    double deviceWidth = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;

    // Base widths from the original implementation
    double baseWidth = _tabWidths[text] ?? 100;

    // For small screens, reduce the width proportionally
    if (deviceWidth < 360) {
      return baseWidth * 0.7; // 70% of original width for small screens
    } else if (deviceWidth < 600) {
      return baseWidth * 0.85; // 85% of original width for medium screens
    }

    return baseWidth; // Original width for larger screens
  }

  @override
  void didChangeMetrics() {
    // When screen metrics change (rotation, resize), recalculate positions
    _precomputeOverlayPositions();
    // Update the overlay position for the currently selected tab
    overlayLeftNotifier.value = _calculateOverlayPosition(selectedIndexNotifier.value);
    notifyListeners();
  }

  void onTabSelected(int index) {
    if (_isProcessingPageChange || _isAnimating) return;

    _isAnimating = true;
    _isProcessingPageChange = true;

    int previousIndex = selectedIndexNotifier.value;
    selectedIndexNotifier.value = index;
    overlayLeftNotifier.value = _calculateOverlayPosition(index);
    overlayColorNotifier.value = Colors.white.withOpacity(0.5);

    Future.delayed(Duration(milliseconds: 400), () {
      overlayColorNotifier.value = Colors.white70;
      _isProcessingPageChange = false;
      _isAnimating = false;
    });

    _scrollToSelectedTab(index, previousIndex);
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToSelectedTab(int index, int previousIndex) {
    double offset = _cachedOverlayPositions[index];

    if (scrollController.hasClients) {
      // Calculate the offset required to move the previous tab to the left
      double previousTabOffset = _cachedOverlayPositions[previousIndex];
      double scrollOffset = offset - previousTabOffset;

      scrollController.animateTo(
        (scrollController.offset + scrollOffset).clamp(0, scrollController.position.maxScrollExtent),
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      scrollController.dispose();
      pageController.dispose();
      WidgetsBinding.instance.removeObserver(this);
      _isDisposed = true;
    }
    super.dispose();
  }
}

