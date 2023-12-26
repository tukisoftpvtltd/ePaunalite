import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../app_data/colors.dart';

class ShimmerTopDestination extends StatefulWidget {
  const ShimmerTopDestination({super.key});

  @override
  State<ShimmerTopDestination> createState() => _ShimmerTopDestinationState();
}

class _ShimmerTopDestinationState extends State<ShimmerTopDestination> {
  double baseWidth = 428;
  @override
  Widget build(BuildContext context) {
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.91;
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey[300]!,
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 90 / 100),
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
                decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(width: 0.1, color: greyColor),
              borderRadius: BorderRadius.circular(10),
            )),
          );
        },
      ),
    );
  }
}
