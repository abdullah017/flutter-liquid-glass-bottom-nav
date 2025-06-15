import 'dart:ui';
import 'package:flutter/material.dart';

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
    super.key,
    required this.items,
    required this.onTap,
    this.currentIndex = 0,
    this.settings = const LiquidGlassSettings(),
    this.height = 70.0,
    this.backgroundColor = Colors.transparent,
  });

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: widget.settings.glassColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: _NavbarContent(
              items: widget.items,
              currentIndex: widget.currentIndex,
              onTap: widget.onTap,
            ),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  child: SizedBox(
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Liquid bubble background - sadece aktif tab için
                        if (isActive)
                          AnimatedBuilder(
                            animation: _bubbleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _bubbleAnimation.value,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        // Tab content
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon - boyutunu sınırla ve ortalama
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 24,
                              width: 24,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child:
                                    isActive && item.activeIcon != null
                                        ? item.activeIcon!
                                        : item.icon,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Title - boyutunu sınırla
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: isActive ? 10 : 8,
                                fontWeight:
                                    isActive
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    isActive
                                        ? item.color ?? Colors.white
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
