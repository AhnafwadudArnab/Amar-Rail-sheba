import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/All%20Feautures/firstpage/booking.dart';
import 'package:amarRailSheba/services/firebase_service.dart';
import 'package:amarRailSheba/utils/responsive.dart';

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
        child: LayoutBuilder(builder: (ctx, constraints) {
          final r = R.of(ctx);
          final cols = constraints.maxWidth > 500 ? 4 : 2;
          return GridView.count(
            crossAxisCount: cols,
            padding: EdgeInsets.all(r.sp8),
            childAspectRatio: 3 / 2,
            children: [
              _buildCard('Report\nLost Item', r, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportLostItemPage()));
              }),
              _buildCard('Search Found\nItems', r, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SearchFoundItemsPage()));
              }),
              _buildCard('Report\nFound Item', r, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportFoundItemPage()));
              }),
              _buildCard('Claim Process', r, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ClaimProcessPage()));
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCard(String title, R r, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.all(r.sp8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          title: Text(title, style: TextStyle(fontSize: r.fs14)),
          trailing: Icon(Icons.arrow_forward_ios, size: r.fs16),
          contentPadding: EdgeInsets.symmetric(horizontal: r.sp16),
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
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateTimeLostController = TextEditingController();
  final TextEditingController trainDetailsController = TextEditingController();
  final TextEditingController contactDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Report Lost Item', style: TextStyle(fontSize: r.fs16))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(r.sp16),
              children: [
                _buildTextField(itemNameController, 'Name of the Item', r),
                _buildTextField(descriptionController, 'Description', r),
                _buildTextField(dateTimeLostController, 'Date & Time Lost', r),
                _buildTextField(trainDetailsController, 'Train Name/Number or Station', r),
                _buildTextField(contactDetailsController, 'Contact Details', r),
                SizedBox(height: r.sp20),
                SizedBox(
                  height: r.btnH,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await FirebaseService().reportLostItem({
                          'itemName': itemNameController.text,
                          'description': descriptionController.text,
                          'dateTimeLost': dateTimeLostController.text,
                          'trainDetails': trainDetailsController.text,
                          'contactDetails': contactDetailsController.text,
                        });
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: Text('Submit', style: TextStyle(fontSize: r.fs14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label, R r) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: r.fs13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: r.fs13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp12),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Please enter $label' : null,
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
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateTimeFoundController = TextEditingController();
  final TextEditingController trainDetailsController = TextEditingController();
  final TextEditingController contactDetailsController = TextEditingController();
  final TextEditingController foundAtController = TextEditingController();
  String? contactPreference;

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Report Found Item', style: TextStyle(fontSize: r.fs16))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(r.sp16),
              children: [
                _buildTextField(itemNameController, 'Name of the Item', r),
                _buildTextField(descriptionController, 'Description', r),
                _buildTextField(dateTimeFoundController, 'Date & Time Found', r),
                _buildTextField(trainDetailsController, 'Train Name/Number or Station', r),
                _buildTextField(contactDetailsController, 'Contact Details', r),
                _buildTextField(foundAtController, 'Found at (optional)', r),
                SizedBox(height: r.sp8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Contact Preference',
                    labelStyle: TextStyle(fontSize: r.fs13),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp12),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Direct', child: Text('Direct')),
                    DropdownMenuItem(value: 'Via Railway Authority', child: Text('Via Railway Authority')),
                  ],
                  onChanged: (v) => contactPreference = v,
                  validator: (v) => v == null ? 'Please select a contact preference' : null,
                ),
                SizedBox(height: r.sp20),
                SizedBox(
                  height: r.btnH,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await FirebaseService().reportFoundItem({
                          'itemName': itemNameController.text,
                          'description': descriptionController.text,
                          'dateTimeFound': dateTimeFoundController.text,
                          'trainDetails': trainDetailsController.text,
                          'contactDetails': contactDetailsController.text,
                          'foundAt': foundAtController.text,
                          'contactPreference': contactPreference ?? '',
                        });
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: Text('Submit', style: TextStyle(fontSize: r.fs14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label, R r) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: r.fs13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: r.fs13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp12),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Please enter $label' : null,
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
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  String? collectionOption;

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Claim Process', style: TextStyle(fontSize: r.fs16))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(r.sp16),
              children: [
                _buildTextField(descriptionController, 'Description or Evidence', r),
                _buildTextField(serialNumberController, 'Serial Number (if applicable)', r),
                SizedBox(height: r.sp8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Collection Option',
                    labelStyle: TextStyle(fontSize: r.fs13),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp12),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'In-person', child: Text('In-person')),
                    DropdownMenuItem(value: 'Delivery', child: Text('Delivery')),
                  ],
                  onChanged: (v) => collectionOption = v,
                  validator: (v) => v == null ? 'Please select a collection option' : null,
                ),
                SizedBox(height: r.sp20),
                SizedBox(
                  height: r.btnH,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await FirebaseService().submitClaim('unknown', {
                          'description': descriptionController.text,
                          'serialNumber': serialNumberController.text,
                          'collectionOption': collectionOption ?? '',
                        });
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: Text('Submit', style: TextStyle(fontSize: r.fs14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label, R r) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: r.fs13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: r.fs13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp12),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Please enter $label' : null,
    );
  }
}