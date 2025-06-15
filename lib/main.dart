import 'package:flutter/material.dart';
import 'src/liquid_bottom_navbar.dart';
import 'src/liquid_glass_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Glass Bottom Navbar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const SearchTab(),
    const FavoritesTab(),
    const ProfileTab(),
    const SettingsTab(),
  ];

  final List<LiquidNavbarItem> _navbarItems = [
    const LiquidNavbarItem(
      icon: Icon(Icons.home_outlined, size: 28, color: Colors.white70),
      activeIcon: Icon(Icons.home, size: 28, color: Colors.blue),
      title: 'Anasayfa',
      color: Colors.blue,
    ),
    const LiquidNavbarItem(
      icon: Icon(Icons.search_outlined, size: 28, color: Colors.white70),
      activeIcon: Icon(Icons.search, size: 28, color: Colors.green),
      title: 'Arama',
      color: Colors.green,
    ),
    const LiquidNavbarItem(
      icon: Icon(Icons.favorite_outline, size: 28, color: Colors.white70),
      activeIcon: Icon(Icons.favorite, size: 28, color: Colors.red),
      title: 'Favoriler',
      color: Colors.red,
    ),
    const LiquidNavbarItem(
      icon: Icon(Icons.person_outline, size: 28, color: Colors.white70),
      activeIcon: Icon(Icons.person, size: 28, color: Colors.orange),
      title: 'Profil',
      color: Colors.orange,
    ),
    const LiquidNavbarItem(
      icon: Icon(Icons.settings_outlined, size: 28, color: Colors.white70),
      activeIcon: Icon(Icons.settings, size: 28, color: Colors.purple),
      title: 'Ayarlar',
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                  Color(0xFF0f3460),
                ],
              ),
            ),
          ),

          // Page content
          IndexedStack(index: _currentIndex, children: _pages),
        ],
      ),

      // Liquid Glass Bottom Navbar
      bottomNavigationBar: LiquidBottomNavbar(
        items: _navbarItems,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        settings: const LiquidGlassSettings(
          glassColor: Color(0x60FFFFFF), // Semi-transparent white
          thickness: 20.0,
          blurRadius: 15.0,
          lightIntensity: 1.2,
          animationDuration: Duration(milliseconds: 1000),
        ),
        height: 90,
        backgroundColor: Colors.black.withValues(alpha: 0.1),
      ),
    );
  }
}

// Sample tab pages
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 80, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Anasayfa',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Liquid Glass Bottom Navbar Demo',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Arama',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 80, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Favoriler',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 80, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'Profil',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 80, color: Colors.purple),
          SizedBox(height: 16),
          Text(
            'Ayarlar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
