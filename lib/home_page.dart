import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_view_animation/providers/home_provider.dart';
import 'package:tab_view_animation/widgets/grey_container.dart';
import 'package:tab_view_animation/widgets/white_overlay.dart';

class MyHomePage extends StatelessWidget {
  // Define a constant color to ensure consistency
  static const Color backgroundColor = Color(0xFF424242); // Colors.grey.shade800
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(), // Create an instance of HomeProvider
      child: OrientationBuilder(
          builder: (context, orientation) {
            return Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                backgroundColor: backgroundColor,
                elevation: 0,
                title: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Cinnabon - Grainger Street',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  // Horizontal Tab Bar
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Consumer<HomeProvider>(
                      builder: (context, provider, child) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: provider.scrollController, // Use the scroll controller from the provider
                          child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    Row(
                                      children: List.generate(provider.tabNames.length, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          child: GreyContainer(provider: provider, index: index),
                                        );
                                      }),
                                    ),
                                    ValueListenableBuilder<double>(
                                      valueListenable: provider.overlayLeftNotifier,
                                      builder: (context, overlayLeft, child) {
                                        return AnimatedPositioned(
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                          left: overlayLeft,
                                          child: WhiteOverlay(provider: provider),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Consumer<HomeProvider>(
                      builder: (context, provider, child) {
                        return PageView.builder(
                          controller: provider.pageController, // Use the page controller from the provider
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          itemCount: provider.listItems.length,
                          onPageChanged: (index) {
                            provider.onTabSelected(index); // Notify the provider when the page changes
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              color: backgroundColor,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.listItems[index].length,
                                  itemBuilder: (context, itemIndex) {
                                    return ListTile(
                                      title: Text(
                                        provider.listItems[index][itemIndex],
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}