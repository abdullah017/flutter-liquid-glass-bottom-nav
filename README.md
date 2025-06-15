# 🌊 Liquid Bottom Navbar

Modern ve şık bir Flutter bottom navigation bar widget'ı - **Liquid Glass** efekti ile!

## ✨ Özellikler

- 🎨 **Liquid Glass Efekti**: BackdropFilter ve blur efektleri ile gerçekçi cam görünümü
- 🌈 **Özelleştirilebilir Renkler**: Her tab için ayrı renk desteği
- ⚡ **Akıcı Animasyonlar**: Elastic curve ile liquid animasyon efektleri
- 📱 **Responsive Tasarım**: Farklı ekran boyutlarına uyumlu
- 🎯 **Kolay Kullanım**: Basit API ile hızlı entegrasyon
- 🔧 **Esnek Ayarlar**: Cam kalınlığı, blur miktarı ve animasyon süreleri ayarlanabilir

## 📸 Ekran Görüntüleri

> **Not**: Bu proje liquid glass efekti ile bottom navigation bar widget'ı içerir. Gerçek görünüm için projeyi çalıştırmanız önerilir.

## 🚀 Kurulum

### 1. Bağımlılıkları Ekleyin

`pubspec.yaml` dosyanıza aşağıdaki bağımlılığı ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_shaders: ^0.1.3  # Shader efektleri için gerekli
```

### 2. Assets'leri Tanımlayın

`pubspec.yaml` dosyanızda assets bölümünü güncelleyin:

```yaml
flutter:
  uses-material-design: true
  shaders:
    - assets/shaders/liquid_navbar.frag
  assets:
    - assets/images/
```

## 💻 Kullanım

### Temel Kullanım

```dart
import 'package:flutter/material.dart';
import 'src/liquid_bottom_navbar.dart';
import 'src/liquid_glass_settings.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<LiquidNavbarItem> _navbarItems = [
    LiquidNavbarItem(
      icon: Icon(Icons.home_outlined, size: 28, color: Colors.white70),
      activeIcon: Icon(Icons.home, size: 28, color: Colors.blue),
      title: 'Anasayfa',
      color: Colors.blue,
    ),
    LiquidNavbarItem(
      icon: Icon(Icons.search_outlined, size: 28, color: Colors.white70),
      activeIcon: Icon(Icons.search, size: 28, color: Colors.green),
      title: 'Arama',
      color: Colors.green,
    ),
    // Daha fazla item...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: LiquidBottomNavbar(
        items: _navbarItems,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
```

### Gelişmiş Özelleştirme

```dart
LiquidBottomNavbar(
  items: _navbarItems,
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  settings: LiquidGlassSettings(
    glassColor: Color(0x60FFFFFF),           // Cam rengi ve şeffaflığı
    thickness: 20.0,                        // Cam kalınlığı
    blurRadius: 15.0,                       // Blur yarıçapı
    lightIntensity: 1.2,                    // Işık yoğunluğu
    animationDuration: Duration(milliseconds: 1000), // Animasyon süresi
  ),
  height: 90,                               // Navbar yüksekliği
  backgroundColor: Colors.black.withOpacity(0.1), // Arka plan rengi
)
```

## 🎨 LiquidNavbarItem Özellikleri

| Özellik | Tür | Açıklama |
|---------|-----|----------|
| `icon` | Widget | Normal durumda gösterilen ikon (zorunlu) |
| `activeIcon` | Widget? | Aktif durumda gösterilen ikon (opsiyonel) |
| `title` | String | Tab başlığı (zorunlu) |
| `color` | Color? | Tab rengi (opsiyonel) |

## ⚙️ LiquidGlassSettings Parametreleri

| Parametre | Tür | Varsayılan | Açıklama |
|-----------|-----|------------|----------|
| `glassColor` | Color | `Color(0x40FFFFFF)` | Cam efektinin rengi ve şeffaflığı |
| `thickness` | double | `15.0` | Cam kalınlığı (refraksiyon miktarı) |
| `blurRadius` | double | `10.0` | Blur yarıçapı |
| `lightIntensity` | double | `1.0` | Işık yoğunluğu (parlaklık efekti) |
| `animationDuration` | Duration | `Duration(milliseconds: 800)` | Animasyon süresi |
| `animationCurve` | Curve | `ElasticOutCurve()` | Animasyon curve'u |

## 🎭 Animasyon Detayları

- **Elastic Out Curve**: Liquid efekt için özel tasarlanmış elastik animasyon
- **Bubble Scaling**: Aktif tab için büyüyen bubble efekti
- **Color Transitions**: Renk geçişleri için akıcı animasyonlar
- **Icon Switching**: Aktif/pasif ikon değişimi için AnimatedSwitcher

## 🏗️ Proje Yapısı

```
lib/
├── main.dart                    # Demo uygulaması
└── src/
    ├── liquid_bottom_navbar.dart    # Ana widget
    ├── liquid_glass_settings.dart   # Ayarlar sınıfı
    └── liquid_navbar_render.dart    # Render logic
```

## 🛠️ Geliştirme

### Gereksinimler

- Flutter SDK 3.7.2 veya üzeri
- Dart 3.0 veya üzeri

### Projeyi Çalıştırma

```bash
# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

### Test

```bash
# Testleri çalıştır
flutter test
```

## 📝 Lisans

Bu proje MIT lisansı altında dağıtılmaktadır. Detaylar için `LICENSE` dosyasına bakınız.

## 🤝 Katkıda Bulunma

1. Bu repository'yi fork edin
2. Feature branch'i oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 🐛 Hata Bildirimi

Herhangi bir hata ile karşılaştığınızda, lütfen GitHub Issues bölümünde hata raporu oluşturun.

## 🙏 Teşekkürler

Bu proje Flutter topluluğunun desteği ile geliştirilmiştir.

---

**Made with ❤️ and Flutter**
