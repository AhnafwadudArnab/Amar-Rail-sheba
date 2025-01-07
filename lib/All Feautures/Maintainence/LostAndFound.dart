import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/booking.dart';

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({super.key});

  @override
  _LostAndFoundPageState createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Lost and Found'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAll(() => const MainHomeScreen());
            },
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 242, 141, 39),
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(8.0),
            childAspectRatio: 3 / 2,
            children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                title: const Text('Report \nLost \nItem', style: TextStyle(fontSize: 19)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 30.0),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportLostItemPage()),
                  );
                },
                ),
              ),
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                title: const Text('Search Found \nItems', style: TextStyle(fontSize: 17)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 30.0),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchFoundItemsPage()),
                  );
                },
                ),
              ),
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                title: const Text('Report \nFound \nItem', style: TextStyle(fontSize: 17)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 30.0),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportFoundItemPage()),
                  );
                },
                ),
              ),
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                title: const Text('\nSecurity Measures', style: TextStyle(fontSize: 17)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 30.0),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserAuthenticationPage()),
                  );
                },
                ),
              ),
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  title: const Text('\nClaim Process', style: TextStyle(fontSize: 17)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 30.0),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClaimProcessPage()),
                  );
                  },
                ),
                ),
              ),
              ),
            ],
          ),
        ));
  }
}

class ReportLostItemPage extends StatefulWidget {
  const ReportLostItemPage({super.key});

  @override
  _ReportLostItemPageState createState() => _ReportLostItemPageState();
}

class _ReportLostItemPageState extends State<ReportLostItemPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Lost Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name of the Item'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the name of the item';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Date & Time Lost'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the date and time lost';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Train Name/Number or Station'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the train name/number or station';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Contact Details'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your contact details';
                }
                return null;
              },
            ),
            // Add more fields as needed
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  // Process data
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchFoundItemsPage extends StatelessWidget {
  const SearchFoundItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(),
      body: const Center(
        child: Text('Search Found Items Page'),
      ),
    );
  }
}

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          // Implement search logic here
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implement search button logic here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ReportFoundItemPage extends StatefulWidget {
  const ReportFoundItemPage({super.key});

  @override
  _ReportFoundItemPageState createState() => _ReportFoundItemPageState();
}

class _ReportFoundItemPageState extends State<ReportFoundItemPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Found Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name of the Item'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the name of the item';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Date & Time Found'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the date and time found';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Train Name/Number or Station'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the train name/number or station';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Contact Details'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your contact details';
                }
                return null;
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Found at (optional)'),
            ),
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: 'Contact Preference'),
              items: const [
                DropdownMenuItem(
                  value: 'Direct',
                  child: Text('Direct'),
                ),
                DropdownMenuItem(
                  value: 'Via Railway Authority',
                  child: Text('Via Railway Authority'),
                ),
              ],
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a contact preference';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  // Process data
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ClaimProcessPage extends StatefulWidget {
  const ClaimProcessPage({super.key});

  @override
  _ClaimProcessPageState createState() => _ClaimProcessPageState();
}

class _ClaimProcessPageState extends State<ClaimProcessPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Process'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Description or Evidence'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a detailed description or evidence';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Serial Number (if applicable)'),
            ),
            const SizedBox(height: 20),
            const Text('Proof of Ownership:'),
            ElevatedButton(
              onPressed: () {
                // Implement image/document upload logic here
              },
              child: const Text('Upload Images/Documents'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Collection Option'),
              items: const [
                DropdownMenuItem(
                  value: 'In-person',
                  child: Text('In-person'),
                ),
                DropdownMenuItem(
                  value: 'Delivery',
                  child: Text('Delivery'),
                ),
              ],
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a collection option';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  // Process data
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Reported Lost Items'),
            onTap: () {
              // Navigate to reported lost items page
            },
          ),
          ListTile(
            title: const Text('Submitted Claims on Found Items'),
            onTap: () {
              // Navigate to submitted claims page
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            onTap: () {
              // Navigate to notifications page
            },
          ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Notifications'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        ListTile(
                          title: const Text(
                              'New found items matching your lost item'),
                          onTap: () {
                            // Navigate to matching found items page
                          },
                        ),
                        ListTile(
                          title: const Text('Updates on reported lost items'),
                          onTap: () {
                            // Navigate to updates on reported lost items page
                          },
                        ),
                        ListTile(
                          title: const Text('Updates on submitted claims'),
                          onTap: () {
                            // Navigate to updates on submitted claims page
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('View Notifications'),
        ),
      ),
    );
  }
}

class UserAuthenticationPage extends StatelessWidget {
  const UserAuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement user authentication logic here
          },
          child: const Text('Authenticate'),
        ),
      ),
    );
  }
}
