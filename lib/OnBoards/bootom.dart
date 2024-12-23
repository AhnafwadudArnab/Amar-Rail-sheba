import 'package:flutter/material.dart';

class BottomNavigators extends StatefulWidget {
  const BottomNavigators({super.key});

  @override
  State<BottomNavigators> createState() => _BottomNavigatorsState();
}

class _BottomNavigatorsState extends State<BottomNavigators> {
  final Color ButtonNavBgColor = Colors.blue; // Define the color here
  final List<String> BottomNavItems = ['Home', 'Ticket', 'Profile']; // Define the items here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 56,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: ButtonNavBgColor.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: ButtonNavBgColor.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(BottomNavItems.length, (index) {
                return SizedBox(
                  height: 36,
                  width: 36,
                  child: IconButton(
                    icon: Icon(
                      index == 0
                          ? Icons.home
                          : index == 1
                              ? Icons.train
                              : Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (index == 0) {
                        // Handle Home button press
                      } else if (index == 1) {
                        // Handle Ticket button press
                      } else {
                        // Handle Profile button press
                      }
                    },
                  ),
                );
              }),
            ),
      ),
    ),
    );

  }
}
