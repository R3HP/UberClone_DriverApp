import 'package:flutter/material.dart';
import 'package:taxi_line_driver/features/cabing/presentation/screen/cab_screen.dart';
import 'package:taxi_line_driver/features/main_screen/driver_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController tabController;

  List<Widget> bodyWidgets = [
    const CabScreen(),
    const DriverScreen(),
  ];
  final items = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Driver'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: items.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: bodyWidgets,
        controller: tabController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: 0,
        elevation: 50,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => tabController.animateTo(index),
      ),
    );
  }
}
