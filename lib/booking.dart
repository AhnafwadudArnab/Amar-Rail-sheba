// ignore_for_file: camel_case_types, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:trackers/All%20Feautures/Maintainence/about.dart';
import 'package:trackers/All%20Feautures/second%20pagee/Book_page_after_search.dart';
import 'All Feautures/Dynamic Tickets/TicketDetails.dart';
import 'All Feautures/Emergencies/emergencies.dart';
import 'All Feautures/Maintainence/LostAndFound.dart';
import 'All Feautures/Tracking or live locations/Live_location.dart';
import 'Info page/Announcement.dart';
import 'Info page/ratings&review.dart';
import 'Login&Signup/sign_up.dart';
import 'profileBar.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // under-List of pages to navigate
  final List<Widget> _pages = [
    const RailwayBookingPage(),
    const MainTicketPage(
      name: '',
      from: '',
      to: '',
      travelClass: '',
      date: '',
      departTime: '',
      seat: '',
    ),
    const ProfileBar(
      loggedIn: true,
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 59,
          decoration: BoxDecoration(
            // Add some border radius to top
            color: const Color.fromARGB(145, 12, 9, 9).withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 5),
                blurRadius: 20,
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              selectedItemColor: const Color.fromARGB(255, 251, 251, 251),
              unselectedItemColor: const Color.fromARGB(255, 204, 143, 74),
              showSelectedLabels: true,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor:
                  Colors.transparent, // This removes extra background color
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_time),
                  label: 'My Tickets',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'My Account',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RailwayBookingPage extends StatefulWidget {
  const RailwayBookingPage({super.key});

  @override
  _RailwayBookingPageState createState() => _RailwayBookingPageState();
}

class _RailwayBookingPageState extends State<RailwayBookingPage> {
  final TextEditingController fromStationController = TextEditingController();
  final TextEditingController toStationController = TextEditingController();
  final yourController = SidebarXController(selectedIndex: 2);
  final TextEditingController _dateController = TextEditingController();
  final FocusNode fromStationFocusNode = FocusNode();
  final FocusNode toStationFocusNode = FocusNode();
  String selectedClass = 'AC';
  bool isSingleTripSelected = true;
  bool isRoundTripSelected = false;
  final List<String> _stations = [
    'Airport',
    'Akhaura',
    'Bhairab-Bazar',
    'Bhola',
    'Brahman_Baria',
    'Chandpur',
    'Chattogram',
    'Comilla',
    'Dewanganj',
    'Dhaka',
    'Feni',
    'Gafargaon',
    'Jamalpur',
    'Joydebpur',
    'Khulna',
    'Laksham',
    'Madaripur',
    'Mohonganj',
    'Munshiganj',
    'Mymensingh',
    'Narshingdi',
    'Narayanganj',
    'Shibchar',
  ]; // Add your station names here
  @override
  void initState() {
    super.initState();

    fromStationFocusNode.addListener(() {
      // Add any additional logic if needed
    });

    toStationFocusNode.addListener(() {
      // Add any additional logic if needed
    });
  }

  @override
  void dispose() {
    fromStationController.dispose();
    toStationController.dispose();
    _dateController.dispose();
    fromStationFocusNode.dispose();
    toStationFocusNode.dispose();
    super.dispose();
  }

  void swapStation() {
    setState(() {
      final tempText = fromStationController.text;
      fromStationController.text = toStationController.text;
      toStationController.text = tempText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(209, 4, 10, 24),
              ),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                          'assets/trainBackgrong/12.png'), // Add your image path here
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Train Information'),
                onTap: () {
                  // Navigate to Privacy & Policy page
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.not_interested_rounded),
                title: const Text('Lost & Found'),
                onTap: () {
                  Get.offAll(() => const LostAndFoundHomePage());
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.rate_review_rounded),
                title: const Text('Rating & Reviews'),
                onTap: () {
                  Get.offAll(() => const RatingsReviewsPage());
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.announcement_rounded),
                title: const Text('Announcement'),
                onTap: () {
                  Get.offAll(() => const AnnouncementPage());
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy & Policy'),
                onTap: () {
                  // Navigate to Privacy & Policy page
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_food_beverage_rounded),
                title: const Text('About'),
                onTap: () {
                  Get.offAll(() => const DeveloperInfoDialog());
                },
              ),
            ),
            const Card(),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/trainBackgrong/05.jpeg'), // Add background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main Content
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Color.fromARGB(255, 245, 245, 245),
                          size: 30,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    // Navigation
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => const LiveLocation());
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.transparent,
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Color.fromARGB(255, 245, 240, 240)),
                              NavButton(label: 'Live Location'),
                            ],
                          ),
                        ),
                        // Emergency Alert Button icon
                        IconButton(
                          icon: const Icon(Icons.railway_alert,
                              color: Color.fromARGB(255, 245, 240, 240)),
                          onPressed: () {
                            Get.to(() =>
                                EmergencyScreen(user: User('defaultUser')));
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => const SignUp());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black12,
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Color.fromARGB(255, 245, 240, 240),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 200), //150
                // Title and Subtitle
                const Text(
                  'Bangladesh Railway',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  'Heartily enjoy every journey through our boundless hospitality.\nThrough Bangladesh railways, The Lifeline of the Nation.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                // Search Form {From, To, Class, Date}
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          SizedBox(height: 20),
                          Spacer(),
                          ChoiceChip(
                              label: Text('Book Your Ticket'), selected: true),
                          Spacer(),
                        ],
                      ),
                      //from here to//
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.black, // Outline color
                            width: 2.5, // Outline width
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.train_rounded),
                                    labelText: 'From'),
                                value: fromStationController.text.isEmpty
                                    ? null
                                    : fromStationController.text,
                                items: _stations.map((station) {
                                  return DropdownMenuItem<String>(
                                    value: station,
                                    child: Text(station),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    fromStationController.text = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.swap_calls_rounded),
                          onPressed: swapStation,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.black, // Outline color
                            width: 2.5, // Outline width
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.train_rounded),
                                    labelText: 'To'),
                                value: toStationController.text.isEmpty
                                    ? null
                                    : toStationController.text,
                                items: _stations.map((station) {
                                  return DropdownMenuItem<String>(
                                    value: station,
                                    child: Text(station),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    toStationController.text = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'From and To stations cannot be the same.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration:
                                  const InputDecoration(labelText: 'Class'),
                              value: selectedClass,
                              items: ['AC', 'Cabin', 'S_chair']
                                  .map((classType) => DropdownMenuItem(
                                        value: classType,
                                        child: Text(classType),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedClass = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                  labelText: 'Journey Date'),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 10)),
                                );
                                if (pickedDate != null) {
                                  _dateController.text = pickedDate
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0];
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      /* const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Get.offAll(() => const TrainSchedulePage());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: const Text(
                          'Search Train',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),*/
                      ElevatedButton(
                        onPressed: () {
                          int emptyFields = 0;
                          if (fromStationController.text.isEmpty ||
                              fromStationController.text == 'to') {
                            emptyFields++;
                          }
                          if (toStationController.text.isEmpty ||
                              toStationController.text == '') {
                            emptyFields++;
                          }
                          if (_dateController.text.isEmpty) emptyFields++;

                          if (fromStationController.text ==
                              toStationController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'From and To stations cannot be the same.'),
                              ),
                            );
                          } else if (emptyFields == 0) {
                            Get.offAll(() => TrainSearchPage(
                                  fromStation: fromStationController.text,
                                  toStation: toStationController.text,
                                  travelClass: selectedClass,
                                  journeyDate: _dateController.text,
                                ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('You left $emptyFields box(es) empty'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: const Text(
                          'Search Train',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final String label;
  const NavButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
