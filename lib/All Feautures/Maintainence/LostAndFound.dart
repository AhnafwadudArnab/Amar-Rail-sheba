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

class SearchFoundItemsPage extends StatefulWidget {
  const SearchFoundItemsPage({super.key});

  @override
  State<SearchFoundItemsPage> createState() => _SearchFoundItemsPageState();
}

class _SearchFoundItemsPageState extends State<SearchFoundItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allItems = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final items = await FirebaseService().getFoundItems();
      setState(() {
        _allItems = items;
        _filtered = items;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = query.isEmpty
          ? _allItems
          : _allItems
              .where((item) =>
                  (item['itemName'] ?? '')
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  (item['trainDetails'] ?? '')
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by item name or train...',
            border: InputBorder.none,
          ),
          onChanged: _onSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _onSearch(_searchController.text),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _filtered.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No found items reported yet'
                              : 'No items match your search',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(r.sp12),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final item = _filtered[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: r.sp8),
                      child: ListTile(
                        leading: const Icon(Icons.inventory_2_outlined),
                        title: Text(item['itemName'] ?? 'Unknown item',
                            style: TextStyle(fontSize: r.fs14)),
                        subtitle: Text(
                          '${item['trainDetails'] ?? ''}\n${item['dateTimeFound'] ?? ''}',
                          style: TextStyle(fontSize: r.fs13),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
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