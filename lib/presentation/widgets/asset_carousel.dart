import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/asset.dart';

class AssetCarousel extends StatelessWidget {
  final List<Asset> assets;
  final AutoSizeGroup textGroup;
  final Function changingIndex;
  const AssetCarousel({
    Key? key,
    required this.assets,
    required this.textGroup,
    required this.changingIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // build widget to display from asset
    List<Widget> widgetList = [];
    for (Asset asset in assets) {
      widgetList.add(
        LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              color: ColorPalette().backgroundContentCard,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '${asset.numberOfAnimals} x ${asset.type.name}',
                        style: const TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 8,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(asset.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      'Price: \$${asset.price}',
                      style: const TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                      ),
                      group: textGroup,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      'Income: \$${asset.income} / year',
                      style: const TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                      ),
                      group: textGroup,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      'Life Expectancy: ${asset.lifeExpectancy} years',
                      style: const TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                      ),
                      group: textGroup,
                    ),
                  ),
                  if (asset.riskLevel > 0)
                    Expanded(
                      flex: 2,
                      child: AutoSizeText(
                        'Risk: 1 out of ${(100 / (asset.riskLevel * 100)).toStringAsFixed(0)} will not survive',
                        style: TextStyle(
                          fontSize: 100,
                          color: Colors.grey[200],
                        ),
                        group: textGroup,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 1.0,
          //viewportFraction: 0.8,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            changingIndex(index);
          }),
      items: widgetList,
    );
  }
}
