import 'dart:async';
import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> banners = [
    {
      "title": "Today's Special",
      "subtitle":
          "Get a Discount for Every Course Order only Valid for Today.!",
      "badge": "25% OFF*",
      "colors": [Color(0xFF209326), Color(0xFF6FFFB6)],
      "textColor": Colors.green,
    },
    {
      "title": "Skill Upgrade",
      "subtitle":
          "Boost your career with new skills and stay ahead in your industry.",
      "badge": "LEVEL UP",
      "colors": [Colors.blue, Colors.blueAccent],
      "textColor": Colors.blue,
    },
    {
      "title": "Limited Time",
      "subtitle":
          "Seats are filling fast. Exclusive deal available for a short time only.",
      "badge": "FLASH DEAL",
      "colors": [Colors.teal, Colors.tealAccent],
      "textColor": Colors.teal,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % banners.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = banners[_currentIndex];

    return Container(
      width: double.infinity,
      height: 170,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: banner["colors"],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Banner content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  banner["badge"],
                  style: TextStyle(
                    color: banner["textColor"],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                banner["title"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                banner["subtitle"],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),

          // Dot indicators
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
