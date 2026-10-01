import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CreditToTakaApp());
}

class CreditToTakaApp extends StatelessWidget {
  const CreditToTakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit to Taka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FA),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 2;
  int _tapCount = 10;
  int _cardPoints = 120;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const Center(child: Text("Leaderboard / Stats")),
      const Center(child: Text("Themes & Cards")),
      _buildHomeScreen(),
      _buildStoreScreen(),
      _buildProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          _currentIndex == 2 ? "Home" : _currentIndex == 3 ? "Card Store" : "Profile",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_soccer, color: Color(0xFF00BFA5), size: 18),
                const SizedBox(width: 6),
                Text(
                  "$_cardPoints",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      drawer: _buildDrawer(),
      body: screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          "$_tapCount",
          style: const TextStyle(
            fontSize: 85,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00BFA5),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircleBtn(
              icon: Icons.remove,
              size: 60,
              color: Colors.white,
              iconColor: Colors.black,
              onTap: () => setState(() => _tapCount > 0 ? _tapCount-- : null),
            ),
            const SizedBox(width: 24),
            _buildCircleBtn(
              icon: Icons.add,
              size: 85,
              color: const Color(0xFF00BFA5),
              iconColor: Colors.white,
              onTap: () => setState(() {
                _tapCount++;
                if (_tapCount % 10 == 0) _cardPoints += 5;
              }),
            ),
            const SizedBox(width: 24),
            _buildCircleBtn(
              icon: Icons.refresh,
              size: 60,
              color: Colors.white,
              iconColor: Colors.black,
              onTap: () => setState(() => _tapCount = 0),
            ),
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildStoreScreen() {
    final packs = [
      {'name': '50 Points', 'price': '\$0.49', 'tag': null},
      {'name': '60 Points', 'price': '\$0.51', 'tag': 'Best Deal'},
      {'name': '100 Points', 'price': '\$0.99', 'tag': 'Top Selling'},
      {'name': '110 Points', 'price': '\$1.01', 'tag': 'Best Deal'},
      {'name': '200 Points', 'price': '\$1.99', 'tag': null},
      {'name': '210 Points', 'price': '\$2.01', 'tag': 'Best Deal'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Card Packs Store", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Choose a card pack and top up instantly.", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.88,
              ),
              itemCount: packs.length,
              itemBuilder: (context, index) {
                final item = packs[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE0F2F1), width: 1.5),
                  ),
                  child: Stack(
                    children: [
                      if (item['tag'] != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E5F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item['tag'] as String,
                              style: const TextStyle(fontSize: 10, color: Colors.purple, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.style_rounded, size: 36, color: Color(0xFF00BFA5)),
                            const SizedBox(height: 8),
                            Text(item['name'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF00BFA5)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item['price'] as String,
                                style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE7F6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFF00BFA5),
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sourov", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("sourov@gmail.com", style: TextStyle(color: Colors.black54)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text("Daily Login Streak", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, i) => Container(
              width: 55,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: i == 0 ? const Color(0xFFE0F2F1) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Day ${i + 1}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Icon(i == 0 ? Icons.check_circle : Icons.lock_outline, size: 18, color: i == 0 ? const Color(0xFF00BFA5) : Colors.grey),
                  const SizedBox(height: 4),
                  Text("+${(i + 1) * 10}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleBtn({required IconData icon, required double size, required Color color, required Color iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Icon(icon, color: iconColor, size: size * 0.42),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF00BFA5)),
            child: Text('Credit to Taka', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          ListTile(leading: const Icon(Icons.headset_mic_outlined), title: const Text('Official Support'), onTap: () {}),
          ListTile(leading: const Icon(Icons.code), title: const Text('Contact Developer'), onTap: () {}),
          ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: const Text('Privacy Policy'), onTap: () {}),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Log Out', style: TextStyle(color: Colors.red)), onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.bar_chart_rounded, 0),
          _navItem(Icons.palette_outlined, 1),
          _navItem(Icons.home_filled, 2),
          _navItem(Icons.shopping_bag_outlined, 3),
          _navItem(Icons.person_outline, 4),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F2F1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isSelected ? const Color(0xFF00BFA5) : Colors.grey, size: 24),
      ),
    );
  }
}
