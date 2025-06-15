import 'dart:math';
import 'package:flutter/material.dart';

/// Liquid glass efektinin ayarlarını tutan sınıf
class LiquidGlassSettings {
  const LiquidGlassSettings({
    this.glassColor = const Color(0x40FFFFFF),
    this.thickness = 15.0,
    this.blurRadius = 10.0,
    this.lightIntensity = 1.0,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = const ElasticOutCurve(),
  });

  /// Cam efektinin rengi (alpha değeri cam yoğunluğunu belirler)
  final Color glassColor;

  /// Cam kalınlığı (refraksiyon miktarını etkiler)
  final double thickness;

  /// Blur yarıçapı
  final double blurRadius;

  /// Işık yoğunluğu (parlaklık efekti)
  final double lightIntensity;

  /// Animasyon süresi
  final Duration animationDuration;

  /// Animasyon curve'u
  final Curve animationCurve;

  /// Kopyala ve değiştir metodu
  LiquidGlassSettings copyWith({
    Color? glassColor,
    double? thickness,
    double? blurRadius,
    double? lightIntensity,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return LiquidGlassSettings(
      glassColor: glassColor ?? this.glassColor,
      thickness: thickness ?? this.thickness,
      blurRadius: blurRadius ?? this.blurRadius,
      lightIntensity: lightIntensity ?? this.lightIntensity,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LiquidGlassSettings &&
        other.glassColor == glassColor &&
        other.thickness == thickness &&
        other.blurRadius == blurRadius &&
        other.lightIntensity == lightIntensity &&
        other.animationDuration == animationDuration &&
        other.animationCurve == animationCurve;
  }

  @override
  int get hashCode {
    return Object.hash(
      glassColor,
      thickness,
      blurRadius,
      lightIntensity,
      animationDuration,
      animationCurve,
    );
  }
}

/// Elastic Out curve - liquid glass efekti için ideal
class ElasticOutCurve extends Curve {
  const ElasticOutCurve([this.period = 0.4]);

  final double period;

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) return t;
    return -1.0 *
            pow(2.0, -10.0 * t) *
            sin((t - period / 4.0) * (2.0 * pi) / period) +
        1.0;
  }
}
