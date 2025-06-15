import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'liquid_glass_settings.dart';

/// Liquid Glass Navbar'ı render eden ana sınıf
class RenderLiquidNavbar extends RenderProxyBox {
  RenderLiquidNavbar({
    required FragmentShader shader,
    required LiquidGlassSettings settings,
    required TickerProvider ticker,
    required int currentIndex,
    required int tabCount,
  }) : _shader = shader,
       _settings = settings,
       _tickerProvider = ticker,
       _currentIndex = currentIndex,
       _tabCount = tabCount {
    _initializeAnimation();
  }

  final FragmentShader _shader;
  LiquidGlassSettings _settings;
  final TickerProvider _tickerProvider;
  int _currentIndex;
  int _tabCount;

  // Animation kontrolü
  late AnimationController _animationController;
  late Animation<double> _animation;
  Ticker? _ticker;

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: _settings.animationDuration,
      vsync: _tickerProvider,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: _settings.animationCurve,
    );

    // Ticker'ı oluştur ama henüz başlatma
    _ticker = _tickerProvider.createTicker((_) {
      markNeedsPaint();
    });
  }

  // Setters
  set settings(LiquidGlassSettings value) {
    if (_settings == value) return;
    _settings = value;
    _updateAnimation();
    markNeedsPaint();
  }

  set currentIndex(int value) {
    if (_currentIndex == value) return;
    _currentIndex = value;
    _animationController.forward(from: 0.0);
    markNeedsPaint();
  }

  set tabCount(int value) {
    if (_tabCount == value) return;
    _tabCount = value;
    markNeedsPaint();
  }

  void _updateAnimation() {
    _animationController.duration = _settings.animationDuration;
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: _settings.animationCurve,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (size.isEmpty) return;

    // Shader uniform parametrelerini ayarla
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final animationProgress = _animation.value;

    _shader
      ..setFloat(0, size.width) // uWidth
      ..setFloat(1, size.height) // uHeight
      ..setFloat(2, _currentIndex.toDouble()) // uActiveTab
      ..setFloat(3, animationProgress) // uAnimationProgress
      ..setFloat(4, _tabCount.toDouble()) // uTabCount
      ..setFloat(5, now % 100) // uTime (mod 100 to prevent overflow)
      // Glass properties
      ..setFloat(6, _settings.glassColor.r / 255.0) // uGlassColorR
      ..setFloat(7, _settings.glassColor.g / 255.0) // uGlassColorG
      ..setFloat(8, _settings.glassColor.b / 255.0) // uGlassColorB
      ..setFloat(9, _settings.glassColor.a / 255.0) // uGlassColorA
      ..setFloat(10, _settings.thickness) // uThickness
      ..setFloat(11, _settings.lightIntensity); // uLightIntensity

    // Navbar alanını clip'le ve backdrop filter uygula
    final navbarRect = Rect.fromLTWH(
      offset.dx + 10,
      offset.dy + 10,
      size.width - 20,
      size.height - 20,
    );

    final navbarRRect = RRect.fromRectAndRadius(
      navbarRect,
      const Radius.circular(25),
    );

    // Clip layer ile navbar şeklini sınırla
    context.pushClipRRect(needsCompositing, offset, navbarRect, navbarRRect, (
      context,
      offset,
    ) {
      // Backdrop filter sadece bu alanda uygula
      context.pushLayer(
        BackdropFilterLayer(filter: ImageFilter.shader(_shader)),
        (context, offset) {
          super.paint(context, offset);
        },
        offset,
      );
    });
  }

  @override
  void dispose() {
    _ticker?.stop();
    _ticker?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    // Ticker'ı sadece henüz başlamamışsa başlat
    if (_ticker != null && !_ticker!.isActive) {
      _ticker!.start();
    }
  }

  @override
  void detach() {
    _ticker?.stop();
    super.detach();
  }
}
