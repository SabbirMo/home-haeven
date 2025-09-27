import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_haven/features/carouselslider/presentation/controller/carousel_slider_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselSliderScreen extends StatelessWidget {
  const CarouselSliderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyCarouselSliderController>(
      init: MyCarouselSliderController(),
      builder: (controller) {
        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: controller.images.length,
              itemBuilder: (context, index, realIndex) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Image.asset(
                    controller.images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                height: 180,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  controller.onPageChange(index);
                },
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSmoothIndicator(
              activeIndex: controller.activeIndex,
              count: controller.images.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
                activeDotColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}
