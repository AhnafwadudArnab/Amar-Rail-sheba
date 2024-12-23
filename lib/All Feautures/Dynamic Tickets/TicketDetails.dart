import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainTicketPage extends StatefulWidget {
  const MainTicketPage({
    super.key,
    required this.name,
    required this.from,
    required this.to,
    required this.travelClass,
    required this.date,
    required this.departTime,
    required this.seat,
  });

  final String name;
  final String from;
  final String to;
  final String travelClass;
  final String date;
  final String departTime;
  final String seat;

  @override
  _MainTicketPageState createState() => _MainTicketPageState();
}

class _MainTicketPageState extends State<MainTicketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Ticket> pastTickets = [];
  List<Ticket> upcomingTickets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    List<Ticket> tickets = getTicketsFromUserPaymentsAndOtherPages();

    DateTime now = DateTime.now();
    for (var ticket in tickets) {
      if (ticket.date.isBefore(now)) {
        pastTickets.add(ticket);
      } else {
        upcomingTickets.add(ticket);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Ticket> getTicketsFromUserPaymentsAndOtherPages() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Tickets',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming Tickets'),
            Tab(text: 'Past Tickets'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TicketListView(
            title: 'Upcoming Tickets',
            tickets: upcomingTickets,
          ),
          TicketListView(
            title: 'Past Tickets',
            tickets: pastTickets,
          ),
        ],
      ),
    );
  }
}

class TrainTicketPage extends StatelessWidget {
  final String name;
  final String from;
  final String to;
  final String travelClass;
  final String date;
  final String departTime;
  final String seat;

  const TrainTicketPage({
    super.key,
    required this.name,
    required this.from,
    required this.to,
    required this.travelClass,
    required this.date,
    required this.departTime,
    required this.seat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 240, 232, 232),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () {
            Get.to(() => const MainTicketPage(
              name: '',
              from: '',
              to: '',
              travelClass: '',
              date: '',
              departTime: '',
              seat: '',
            ));
          },
        ),
        centerTitle: true,
        title: const Text('My Tickets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 100),
          Container(
            height: MediaQuery.of(context).size.height * 0.38,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Train Ticket',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.train, color: Colors.white),
                      Text(
                        'Train Ticket',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Middle Section
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    color: Colors.white,
                    child: Row(
                      children: [
                        // Left Part
                        Expanded(
                          flex: -2,
                          child: Container(
                            padding: const EdgeInsets.all(1.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                right: BorderSide(
                                  color: Colors.redAccent,
                                  width: 0.7,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('NAME',
                                    style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('FROM',
                                    style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  from,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('TO', style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  to,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('CLASS',
                                    style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  travelClass,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('DATE',
                                    style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Barcode Section
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              Container(
                                height: 100,
                                width: 24,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/trainBackgrong/ladder.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Middle Part
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('PASSENGER NAME',
                                  style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('FROM', style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                from,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('TO', style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                to,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('CLASS',
                                  style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                travelClass,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('DEPART TIME',
                                  style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                departTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Seat and QR Section
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 8),
                              const Text('SEAT', style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                seat,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 70),
                              Container(
                                height: 60,
                                width: 65,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.lightBlueAccent,
                                    width: 2,
                                  ),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/trainBackgrong/qr.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '* Please be at the platform well ahead of departure time',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
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

class TicketFormPage extends StatefulWidget {
  const TicketFormPage({super.key});

  @override
  _TicketFormPageState createState() => _TicketFormPageState();
}

class _TicketFormPageState extends State<TicketFormPage> {
  final List<TrainTicketPage> tickets = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController travelClassController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController departTimeController = TextEditingController();
  final TextEditingController seatController = TextEditingController();

  void addTicket() {
    setState(() {
      tickets.add(TrainTicketPage(
        name: nameController.text,
        from: fromController.text,
        to: toController.text,
        travelClass: travelClassController.text,
        date: dateController.text,
        departTime: departTimeController.text,
        seat: seatController.text,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tickets'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: fromController,
              decoration: const InputDecoration(labelText: 'From'),
            ),
            TextField(
              controller: toController,
              decoration: const InputDecoration(labelText: 'To'),
            ),
            TextField(
              controller: travelClassController,
              decoration: const InputDecoration(labelText: 'Class'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: departTimeController,
              decoration: const InputDecoration(labelText: 'Depart Time'),
            ),
            TextField(
              controller: seatController,
              decoration: const InputDecoration(labelText: 'Seat'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addTicket,
              child: const Text('Add Ticket'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(tickets[index].name),
                      subtitle: Text('${tickets[index].from} to ${tickets[index].to}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketListView extends StatelessWidget {
  final String title;
  final List<Ticket> tickets;

  const TicketListView({super.key, required this.title, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tickets[index].title),
                  subtitle: Text(tickets[index].date.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Ticket {
  final String title;
  final DateTime date;

  Ticket(this.title, this.date);
}

class TicketList extends StatefulWidget {
  final String title;
  final List<Ticket> tickets;

  const TicketList({super.key, required this.title, required this.tickets});

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.tickets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.tickets[index].title),
                  subtitle: Text(widget.tickets[index].date.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
