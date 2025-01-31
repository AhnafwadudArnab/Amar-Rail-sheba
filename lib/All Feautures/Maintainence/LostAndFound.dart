import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
            Get.to(() => const MainHomeScreen());
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
            _buildCard('Report \nLost \nItem', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportLostItemPage()),
              );
            }),
            _buildCard('Search Found \nItems', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchFoundItemsPage()),
              );
            }),
            _buildCard('Report \nFound \nItem', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportFoundItemPage()),
              );
            }),
            _buildCard('Claim Process', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClaimProcessPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ListTile(
          title: Text(title, style: const TextStyle(fontSize: 17)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 30.0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          onTap: onTap,
        ),
      ),
    );
  }
}

class ReportLostItemPage extends StatefulWidget {
  const ReportLostItemPage({super.key});

  @override
  _ReportLostItemPageState createState() => _ReportLostItemPageState();
}

class _ReportLostItemPageState extends State<ReportLostItemPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateTimeLostController = TextEditingController();
  final TextEditingController trainDetailsController = TextEditingController();
  final TextEditingController contactDetailsController = TextEditingController();

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
            _buildTextField(itemNameController, 'Name of the Item'),
            _buildTextField(descriptionController, 'Description'),
            _buildTextField(dateTimeLostController, 'Date & Time Lost'),
            _buildTextField(trainDetailsController, 'Train Name/Number or Station'),
            _buildTextField(contactDetailsController, 'Contact Details'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final data = {
                    'itemName': itemNameController.text,
                    'description': descriptionController.text,
                    'dateTimeLost': dateTimeLostController.text,
                    'trainDetails': trainDetailsController.text,
                    'contactDetails': contactDetailsController.text,
                  };
                  try {
                    final response = await apiService.reportLostItem(data);
                    // Handle success response
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lost item reported successfully!')),
                    );
                  } catch (e) {
                    // Handle error response
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
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
  final ApiService apiService = ApiService();

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateTimeFoundController = TextEditingController();
  final TextEditingController trainDetailsController = TextEditingController();
  final TextEditingController contactDetailsController = TextEditingController();
  final TextEditingController foundAtController = TextEditingController();
  String? contactPreference;

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
            _buildTextField(itemNameController, 'Name of the Item'),
            _buildTextField(descriptionController, 'Description'),
            _buildTextField(dateTimeFoundController, 'Date & Time Found'),
            _buildTextField(trainDetailsController, 'Train Name/Number or Station'),
            _buildTextField(contactDetailsController, 'Contact Details'),
            _buildTextField(foundAtController, 'Found at (optional)'),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Contact Preference'),
              items: const [
                DropdownMenuItem(value: 'Direct', child: Text('Direct')),
                DropdownMenuItem(value: 'Via Railway Authority', child: Text('Via Railway Authority')),
              ],
              onChanged: (value) {
                contactPreference = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a contact preference';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final data = {
                    'itemName': itemNameController.text,
                    'description': descriptionController.text,
                    'dateTimeFound': dateTimeFoundController.text,
                    'trainDetails': trainDetailsController.text,
                    'contactDetails': contactDetailsController.text,
                    'foundAt': foundAtController.text,
                    'contactPreference': contactPreference ?? '',
                  };
                  try {
                    final response = await apiService.reportFoundItem(data);
                    // Handle success response
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Found item reported successfully!')),
                    );
                  } catch (e) {
                    // Handle error response
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
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
  final ApiService apiService = ApiService();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  String? collectionOption;

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
            _buildTextField(descriptionController, 'Description or Evidence'),
            _buildTextField(serialNumberController, 'Serial Number (if applicable)'),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Collection Option'),
              items: const [
                DropdownMenuItem(value: 'In-person', child: Text('In-person')),
                DropdownMenuItem(value: 'Delivery', child: Text('Delivery')),
              ],
              onChanged: (value) {
                collectionOption = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a collection option';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final data = {
                    'description': descriptionController.text,
                    'serialNumber': serialNumberController.text,
                    'collectionOption': collectionOption ?? '',
                  };
                  try {
                    final response = await apiService.claimProcess(data);
                    // Handle success response
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Claim process submitted successfully!')),
                    );
                  } catch (e) {
                    // Handle error response
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}

class ApiService {
  final String baseUrl = 'http://10.15.10.140:3000';

  Future<Map<String, dynamic>> reportLostItem(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/report-lost'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> searchFoundItems() async {
    final response = await http.get(Uri.parse('$baseUrl/search-found'));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> reportFoundItem(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/report-found'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> claimProcess(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/claim-process'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}