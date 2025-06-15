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
      theme: ThemeData(useMaterial3: true),
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

  // Her sayfa için farklı renk teması
  List<List<Color>> get _pageGradients => [
    // Anasayfa - Mavi tonları
    [
      const Color(0xFFE3F2FD), // Açık mavi
      const Color(0xFFBBDEFB), // Orta mavi
      const Color(0xFF90CAF9), // Koyu mavi
      const Color(0xFF64B5F6), // En koyu mavi
    ],
    // Arama - Yeşil tonları
    [
      const Color(0xFFE8F5E8), // Açık yeşil
      const Color(0xFFC8E6C9), // Orta yeşil
      const Color(0xFFA5D6A7), // Koyu yeşil
      const Color(0xFF81C784), // En koyu yeşil
    ],
    // Favoriler - Kırmızı/Pembe tonları
    [
      const Color(0xFFFCE4EC), // Açık pembe
      const Color(0xFFF8BBD9), // Orta pembe
      const Color(0xFFF48FB1), // Koyu pembe
      const Color(0xFFF06292), // En koyu pembe
    ],
    // Profil - Turuncu tonları
    [
      const Color(0xFFFFF3E0), // Açık turuncu
      const Color(0xFFFFE0B2), // Orta turuncu
      const Color(0xFFFFCC02), // Koyu turuncu
      const Color(0xFFFFB74D), // En koyu turuncu
    ],
    // Ayarlar - Mor tonları
    [
      const Color(0xFFF3E5F5), // Açık mor
      const Color(0xFFE1BEE7), // Orta mor
      const Color(0xFFCE93D8), // Koyu mor
      const Color(0xFFBA68C8), // En koyu mor
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Body'yi tam ekrana uzat
      backgroundColor: Colors.transparent, // Arka plan şeffaf
      body: Stack(
        children: [
          // Background gradient - her sayfa için farklı renk
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _pageGradients[_currentIndex],
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Başlık
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(Icons.search, size: 60, color: Colors.green),
                  SizedBox(height: 12),
                  Text(
                    'Arama Sayfası',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Yeşil temalı arama sayfası',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Arama kutusu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.green),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Buraya arama yapabilirsiniz...',
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            const SizedBox(height: 130), // Navbar için boşluk
          ],
        ),
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Başlık
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(Icons.favorite, size: 60, color: Colors.pink),
                  SizedBox(height: 12),
                  Text(
                    'Favoriler',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pembe temalı favoriler sayfası',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Favori öğeler listesi
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.pink.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.pink,
                          size: 24,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            'Favori Öğe ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.pink.withOpacity(0.7),
                          size: 16,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 130), // Navbar için boşluk
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profil kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profil resmi
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.orange, width: 3),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kullanıcı Adı',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Turuncu temalı profil sayfası',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Profil menü öğeleri
            Expanded(
              child: ListView(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.edit,
                    title: 'Profili Düzenle',
                    color: Colors.orange,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.security,
                    title: 'Güvenlik',
                    color: Colors.orange,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.notifications,
                    title: 'Bildirimler',
                    color: Colors.orange,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.help,
                    title: 'Yardım',
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 130), // Navbar için boşluk
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: color.withOpacity(0.7),
            size: 16,
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Başlık
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(Icons.settings, size: 60, color: Colors.purple),
                  SizedBox(height: 12),
                  Text(
                    'Ayarlar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mor temalı ayarlar sayfası',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Ayar kategorileri
            Expanded(
              child: ListView(
                children: [
                  _SettingsCategory(
                    title: 'Genel Ayarlar',
                    items: [
                      _SettingsItem(
                        icon: Icons.language,
                        title: 'Dil',
                        color: Colors.purple,
                      ),
                      _SettingsItem(
                        icon: Icons.dark_mode,
                        title: 'Tema',
                        color: Colors.purple,
                      ),
                      _SettingsItem(
                        icon: Icons.notifications,
                        title: 'Bildirimler',
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SettingsCategory(
                    title: 'Hesap Ayarları',
                    items: [
                      _SettingsItem(
                        icon: Icons.privacy_tip,
                        title: 'Gizlilik',
                        color: Colors.purple,
                      ),
                      _SettingsItem(
                        icon: Icons.security,
                        title: 'Güvenlik',
                        color: Colors.purple,
                      ),
                      _SettingsItem(
                        icon: Icons.backup,
                        title: 'Yedekleme',
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 130), // Navbar için boşluk
          ],
        ),
      ),
    );
  }
}

class _SettingsCategory extends StatelessWidget {
  const _SettingsCategory({required this.title, required this.items});

  final String title;
  final List<_SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: color.withOpacity(0.7),
            size: 14,
          ),
        ],
      ),
    );
  }
}
