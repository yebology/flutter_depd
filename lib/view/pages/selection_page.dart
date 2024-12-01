part of 'pages.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    CostPage(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBack(
        child: _pages[_selectedIndex],
        waitForSecondBackPress: 4,
        onFirstBackPress: (){
          return Fluttertoast.showToast(
            msg: "Press back again to close app!",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 14,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Cost Info'
          ),
        ]
      ),
    );
  }
}