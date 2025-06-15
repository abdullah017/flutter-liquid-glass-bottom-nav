import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'liquid_glass_settings.dart';

/// Navbar item modeli
class LiquidNavbarItem {
  const LiquidNavbarItem({
    required this.icon,
    required this.title,
    this.activeIcon,
    this.color,
  });

  /// Normal durumda gösterilen ikon
  final Widget icon;

  /// Aktif durumda gösterilen ikon (opsiyonel)
  final Widget? activeIcon;

  /// Tab başlığı
  final String title;

  /// Tab rengi (opsiyonel)
  final Color? color;
}

/// Liquid Glass Bottom Navigation Bar
class LiquidBottomNavbar extends StatefulWidget {
  const LiquidBottomNavbar({
    Key? key,
    required this.items,
    required this.onTap,
    this.currentIndex = 0,
    this.settings = const LiquidGlassSettings(),
    this.height = 70.0,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  /// Navbar item'ları
  final List<LiquidNavbarItem> items;

  /// Tab tıklandığında çağrılan callback
  final ValueChanged<int> onTap;

  /// Şu anki aktif tab indexi
  final int currentIndex;

  /// Liquid glass efekt ayarları
  final LiquidGlassSettings settings;

  /// Navbar yüksekliği
  final double height;

  /// Arka plan rengi
  final Color backgroundColor;

  @override
  State<LiquidBottomNavbar> createState() => _LiquidBottomNavbarState();
}

class _LiquidBottomNavbarState extends State<LiquidBottomNavbar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 25, // Çok daha yukarı - floating görünüm
        bottom: 55, // Alt boşluk da artırdık - ayrık görünüm
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40), // 30'dan 40'a artırdık
        child: Stack(
          children: [
            // Beyazımsı şeffaf blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  // Daha beyaz şeffaf arka plan
                  color: Colors.white.withValues(
                    alpha: .10,
                  ), // Daha beyaz şeffaflık
                  borderRadius: BorderRadius.circular(
                    100,
                  ), // 35'ten 40'a artırdık
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: .5,
                    ), // Daha belirgin beyaz border
                    width: 1.4, // Daha kalın border
                  ),
                  boxShadow: [
                    // Güçlü elevation shadow
                    BoxShadow(
                      color: Colors.grey.withValues(
                        alpha: 0.01,
                      ), // Colors.black.withValues(alpha: 0.15),
                      blurRadius: 25,
                      offset: const Offset(50, 50),
                      spreadRadius: 10,
                    ),
                    // Orta katman shadow
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.01),
                      blurRadius: 1,
                      offset: const Offset(0, 0),
                      spreadRadius: 0,
                    ),
                    // Üst highlight
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),

            // Beyaz detay katmanı - daha belirgin
            Container(
              decoration: BoxDecoration(
                // Daha belirgin beyaz highlight
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.08), // Daha belirgin
                    Colors.white.withOpacity(0.02), // Hafif geçiş
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(40), // 35'ten 40'a artırdık
              ),
            ),

            // Belirgin beyaz highlight çizgisi
            Positioned(
              top: 2,
              left: 30,
              right: 30,
              height: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.3), // Daha belirgin
                      Colors.white.withOpacity(0.5), // Güçlü merkez
                      Colors.white.withOpacity(0.3), // Daha belirgin
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(0.5),
                ),
              ),
            ),

            // İçerik katmanı - en üstte
            _NavbarContent(
              items: widget.items,
              currentIndex: widget.currentIndex,
              onTap: widget.onTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// Navbar içeriği widget'ı
class _NavbarContent extends StatefulWidget {
  const _NavbarContent({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<LiquidNavbarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<_NavbarContent> createState() => _NavbarContentState();
}

class _NavbarContentState extends State<_NavbarContent>
    with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bubbleAnimation = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void didUpdateWidget(_NavbarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _bubbleController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ), // Apple-style geniş padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = index == widget.currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.onTap(index),
                  child: Container(
                    height: 70, // Büyük ikon/text için daha yüksek
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Şeffaf Apple-style indicator - rahat boyutlar
                        if (isActive)
                          AnimatedBuilder(
                            animation: _bubbleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _bubbleAnimation.value,
                                child: Container(
                                  width: 90, // Büyük ikon/text için daha geniş
                                  height:
                                      55, // Büyük ikon/text için daha yüksek
                                  decoration: BoxDecoration(
                                    // Şeffaf arka plan - cam gibi
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(
                                      30,
                                    ), // Navbar'a orantılı artırdık (25'ten 30'a)
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.25),
                                      width: 0.5,
                                    ),
                                    boxShadow: [
                                      // Çok hafif glow
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.08),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        // Tab content - ön planda (indicator'ın üstünde)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon - daha büyük boyut
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 28, // 24'ten 28'e büyüttük
                              width: 28, // 24'ten 28'e büyüttük
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child:
                                    isActive && item.activeIcon != null
                                        ? item.activeIcon!
                                        : item.icon,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Title - hem aktif hem pasif daha büyük
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize:
                                    isActive
                                        ? 12
                                        : 11, // Pasif tab'ları da büyüttük: 10'dan 11'e
                                fontWeight:
                                    isActive
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    isActive
                                        ? item.color ??
                                            Colors
                                                .white // Tab'ın kendi rengi
                                        : Colors.grey[400],
                              ),
                              child: Text(
                                item.title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
