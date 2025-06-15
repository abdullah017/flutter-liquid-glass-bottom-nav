import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'src/liquid_bottom_navbar.dart';
import 'src/liquid_glass_settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Full screen için system UI'ı gizle
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
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
      extendBody: true, // Body'yi tam ekrana uzat
      backgroundColor: Colors.transparent, // Arka plan şeffaf
      body: Stack(
        children: [
          // Background gradient - full screen
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

          // Page content - FULL PAGE, padding yok
          IndexedStack(index: _currentIndex, children: _pages),

          // Liquid Glass Bottom Navbar - Floating overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: false, // Navbar tıklanabilir
              child: LiquidBottomNavbar(
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
                backgroundColor: Colors.transparent, // Şeffaf arka plan
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sample tab pages
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  // Örnek görsel URL'leri
  final List<String> imageUrls = const [
    'https://picsum.photos/400/300?random=1',
    'https://picsum.photos/400/300?random=2',
    'https://picsum.photos/400/300?random=3',
    'https://picsum.photos/400/300?random=4',
    'https://picsum.photos/400/300?random=5',
    'https://picsum.photos/400/300?random=6',
    'https://picsum.photos/400/300?random=7',
    'https://picsum.photos/400/300?random=8',
    'https://picsum.photos/400/300?random=9',
    'https://picsum.photos/400/300?random=10',
    'https://picsum.photos/400/300?random=11',
    'https://picsum.photos/400/300?random=12',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Anasayfa',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.withOpacity(0.3), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),

          // Görsel Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _ImageCard(
                    imageUrl: imageUrls[index % imageUrls.length],
                    title: 'Görsel ${index + 1}',
                  );
                },
                childCount: 20, // 20 tane görsel göster
              ),
            ),
          ),

          // Alt boşluk - navbar için gerekli (full page olduğu için)
          const SliverToBoxAdapter(child: SizedBox(height: 130)),
        ],
      ),
    );
  }
}

// Görsel kartı widget'ı
class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.imageUrl, required this.title});

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Görsel
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),

            // Başlık
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
