import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/booking.dart';
class LostAndFoundHomePage extends StatefulWidget {
  const LostAndFoundHomePage({super.key});

  @override
  LostAndFoundHomePageState createState() => LostAndFoundHomePageState();
}

class LostAndFoundHomePageState extends State<LostAndFoundHomePage> {
  final List<String> _items = [];

  Widget _buildList() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_items[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeItem(index),
          ),
        );
      },
    );
  }

  final TextEditingController _controller = TextEditingController();

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _items.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
           Get.to(()=>const MainHomeScreen());
          },
        ),

        title: const Text('Lost and Found'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/trainBackgrong/01.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: _buildList(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                      child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Item',
                        labelStyle: const TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _addItem,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ),
                    Expanded(
                    child: Center(
                      child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                        title: Text(_items[index], style: const TextStyle(color: Colors.white)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _removeItem(index),
                        ),
                        );
                      },
                      ),
                    ),
                    ),
                  ],
                  ),
            ],
          ),
        );
        }

    }

  