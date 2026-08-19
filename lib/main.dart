import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/link.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized().ensureSemantics();
  runApp(const MyApp());
}

/// Palette borrowed from flutter.dev: white + pale sky sections, bright
/// Flutter blue, deep navy, and a handful of playful accents.
abstract final class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const sky = Color(0xFFE7F8FF);
  static const skyFaint = Color(0xFFF3FCFF);
  static const skyMid = Color(0xFFDCF5FF);
  static const blue = Color(0xFF027DFD);
  static const blueDark = Color(0xFF0553B1);
  static const navy = Color(0xFF042B59);
  static const navyDeep = Color(0xFF042449);
  static const teal = Color(0xFF1CDAC5);
  static const tealBright = Color(0xFF00F6DB);
  static const tealPale = Color(0xFFDFF9F4);
  static const tealInk = Color(0xFF0B7264);
  static const yellow = Color(0xFFFFF275);
  static const yellowPale = Color(0xFFFCFCE2);
  static const yellowInk = Color(0xFF7A6200);
  static const purplePale = Color(0xFFF1EAFE);
  static const purple = Color(0xFF833EF2);
  static const body = Color(0xFF4A4A4A);
  static const border = Color(0xFFDADCE0);
}

abstract final class AppText {
  static TextStyle sans({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.body,
    double height = 1.6,
    double spacing = 0,
  }) {
    return TextStyle(
      fontFamily: 'Google Sans Flex',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: spacing,
    );
  }

  static TextStyle heading({
    required double size,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.navy,
    double height = 1.15,
  }) {
    return sans(size: size, weight: weight, color: color, height: height, spacing: -0.5);
  }

  static TextStyle code({
    double size = 12.5,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.blue,
    double spacing = 1.5,
  }) {
    return TextStyle(
      fontFamily: 'Google Sans Code',
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: spacing,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kris Pypen - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue, brightness: Brightness.light),
        useMaterial3: true,
        fontFamily: 'Google Sans Flex',
        scaffoldBackgroundColor: AppColors.white,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColors.blue.withValues(alpha: 0.2),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _NavBar(),
              _Hero(),
              _BuildSection(),
              _CommunitySection(),
              _ExperienceSection(),
              _ContactSection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

bool _isNarrow(BuildContext context) => MediaQuery.sizeOf(context).width < 760;
bool _isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= 1000;

/// Full-bleed colored band with centered, padded content.
class _Band extends StatelessWidget {
  const _Band({required this.color, required this.child, this.vertical = 88});

  final Color color;
  final Widget child;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    return Container(
      color: color,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: narrow ? 22 : 48,
              vertical: narrow ? vertical * 0.72 : vertical,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _Hover extends StatefulWidget {
  const _Hover({required this.builder});

  final Widget Function(BuildContext context, bool hovered) builder;

  @override
  State<_Hover> createState() => _HoverState();
}

class _HoverState extends State<_Hover> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.builder(context, _hovered),
    );
  }
}

enum _PillStyle { filled, outlined, teal }

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.uri, this.style = _PillStyle.filled, this.icon});

  final String label;
  final Uri uri;
  final _PillStyle style;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: uri,
      builder: (context, followLink) => _Hover(
        builder: (context, hovered) {
          final (bg, fg, border) = switch (style) {
            _PillStyle.filled => (
              hovered ? AppColors.blueDark : AppColors.blue,
              AppColors.white,
              Colors.transparent,
            ),
            _PillStyle.outlined => (
              hovered ? AppColors.skyFaint : Colors.transparent,
              AppColors.navy,
              AppColors.border,
            ),
            _PillStyle.teal => (
              hovered ? AppColors.tealBright : AppColors.teal,
              AppColors.navy,
              Colors.transparent,
            ),
          };
          return GestureDetector(
            onTap: followLink,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: border, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: AppText.sans(size: 15.5, weight: FontWeight.w600, color: fg, height: 1.2)),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 17, color: fg),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.uri, this.dark = false});

  final String label;
  final Uri uri;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: uri,
      builder: (context, followLink) => _Hover(
        builder: (context, hovered) => GestureDetector(
          onTap: followLink,
          child: Text(
            label,
            style: AppText.sans(
              size: 15,
              weight: FontWeight.w500,
              height: 1.2,
              color: hovered
                  ? (dark ? AppColors.tealBright : AppColors.blue)
                  : (dark ? Colors.white.withValues(alpha: 0.85) : AppColors.navy),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8EAED))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: narrow ? 22 : 48, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(width: 10),
                Text('Kris Pypen', style: AppText.sans(size: 18, weight: FontWeight.w600, color: AppColors.navy, height: 1.2)),
                const Spacer(),
                if (!narrow) ...[
                  _NavLink(label: 'GitHub', uri: Uri.parse('https://github.com/krispypen')),
                  const SizedBox(width: 28),
                  _NavLink(label: 'LinkedIn', uri: Uri.parse('https://www.linkedin.com/in/krispypen/')),
                  const SizedBox(width: 28),
                  _NavLink(label: 'Bluesky', uri: Uri.parse('https://bsky.app/profile/krispypen.bsky.social')),
                  const SizedBox(width: 32),
                ],
                _PillButton(label: 'Say hello', uri: Uri.parse('https://www.linkedin.com/in/krispypen/')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Sticker extends StatelessWidget {
  const _Sticker({required this.asset, required this.size, this.angle = 0, this.padding = 14, this.radius = 24});

  final String asset;
  final double size;
  final double angle;
  final double padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.14),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - padding * 0.6),
          child: Image.asset(
            asset,
            width: size,
            height: size,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.color, this.ring = false});

  final double size;
  final Color color;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ring ? null : color,
        border: ring ? Border.all(color: color, width: 10) : null,
      ),
    );
  }
}

/// Slow-moving pastel mesh-gradient shader behind the hero.
/// Falls back to the flat sky color while loading (or if shaders fail).
class _HeroShaderBackground extends StatefulWidget {
  const _HeroShaderBackground();

  @override
  State<_HeroShaderBackground> createState() => _HeroShaderBackgroundState();
}

class _HeroShaderBackgroundState extends State<_HeroShaderBackground>
    with SingleTickerProviderStateMixin {
  static Future<ui.FragmentProgram>? _programFuture;

  ui.FragmentShader? _shader;
  late final Ticker _ticker;
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() => _time = elapsed.inMicroseconds / 1e6);
    });
    _programFuture ??= ui.FragmentProgram.fromAsset('shaders/hero_background.frag');
    _programFuture!.then(
      (program) {
        if (!mounted) return;
        setState(() => _shader = program.fragmentShader());
        _ticker.start();
      },
      onError: (Object _) {}, // keep the flat fallback
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    if (shader == null) return const ColoredBox(color: AppColors.sky);
    return CustomPaint(painter: _ShaderPainter(shader, _time));
  }
}

class _ShaderPainter extends CustomPainter {
  _ShaderPainter(this.shader, this.time);

  final ui.FragmentShader shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ShaderPainter oldDelegate) =>
      oldDelegate.time != time || oldDelegate.shader != shader;
}

class _HeroCollage extends StatelessWidget {
  const _HeroCollage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 470,
      height: 430,
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          Positioned(top: 8, right: 168, child: _Circle(size: 120, color: AppColors.yellow)),
          Positioned(bottom: 96, left: 4, child: _Circle(size: 48, color: AppColors.teal)),
          Positioned(
            top: 40,
            right: 0,
            child: _Sticker(asset: 'assets/images/kris-avatar.png', size: 196, angle: 0.03, radius: 32),
          ),
          Positioned(
            top: 10,
            left: 42,
            child: _Sticker(asset: 'assets/images/flutterbelgium-app-icon.png', size: 76, angle: -0.09),
          ),
          Positioned(
            top: 150,
            left: 66,
            child: _Sticker(asset: 'assets/images/ijsjesradar-app-icon.png', size: 96, angle: -0.05),
          ),
          Positioned(
            bottom: 6,
            left: 158,
            child: _Sticker(asset: 'assets/images/investsuite-app-icon.png', size: 84, angle: 0.06),
          ),
          Positioned(
            top: 0,
            right: 118,
            child: _Sticker(asset: 'assets/images/flutter-logo.png', size: 40, angle: 0.12, padding: 10, radius: 18),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final narrow = _isNarrow(context);
    final wide = _isWide(context);
    final titleSize = width < 500 ? 52.0 : (narrow ? 62.0 : (wide ? 84.0 : 72.0));

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0xFFB8EAFE)),
          ),
          child: Text('FLUTTER DEVELOPER · BELGIUM', style: AppText.code(size: 12)),
        ),
        const SizedBox(height: 26),
        Text('Kris Pypen', style: AppText.heading(size: titleSize, height: 1.0)),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Text(
            'Building Flutter apps at InvestSuite, running the Flutter Belgium '
            'meetup since 2018, and tracking ice-cream trucks with ijsjesradar.app.',
            style: AppText.sans(size: narrow ? 17 : 19),
          ),
        ),
        const SizedBox(height: 34),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _PillButton(
              label: 'Get in touch',
              uri: Uri.parse('https://www.linkedin.com/in/krispypen/'),
              icon: Icons.arrow_forward,
            ),
            _PillButton(
              label: 'GitHub',
              uri: Uri.parse('https://github.com/krispypen'),
              style: _PillStyle.outlined,
              icon: Icons.north_east,
            ),
          ],
        ),
      ],
    );

    return Stack(
      children: [
        const Positioned.fill(child: RepaintBoundary(child: _HeroShaderBackground())),
        _buildForeground(narrow, wide, content),
      ],
    );
  }

  Widget _buildForeground(bool narrow, bool wide, Widget content) {
    return _Band(
      color: Colors.transparent,
      vertical: 96,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, t, child) => Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, 16 * (1 - t)), child: child),
        ),
        child: wide
            ? Row(
                children: [
                  Expanded(child: content),
                  const SizedBox(width: 40),
                  const _HeroCollage(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  content,
                  const SizedBox(height: 44),
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [
                      _Sticker(asset: 'assets/images/kris-avatar.png', size: 88, angle: 0.03, padding: 10, radius: 22),
                      _Sticker(asset: 'assets/images/flutterbelgium-app-icon.png', size: 52, angle: -0.05, padding: 10, radius: 18),
                      _Sticker(asset: 'assets/images/ijsjesradar-app-icon.png', size: 52, angle: 0.06, padding: 10, radius: 18),
                      _Sticker(asset: 'assets/images/investsuite-app-icon.png', size: 52, angle: -0.04, padding: 10, radius: 18),
                      _Sticker(asset: 'assets/images/flutter-logo.png', size: 52, angle: 0.05, padding: 10, radius: 18),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.title, this.dark = false, this.labelColor});

  final String label;
  final String title;
  final bool dark;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.code(color: labelColor ?? AppColors.blue)),
        const SizedBox(height: 14),
        Text(
          title,
          style: AppText.heading(size: narrow ? 30 : 40, color: dark ? AppColors.white : AppColors.navy),
        ),
      ],
    );
  }
}

class _BuildSection extends StatelessWidget {
  const _BuildSection();

  static final _cards = [
    (
      color: AppColors.skyMid,
      icon: 'assets/images/investsuite-app-icon.png',
      title: 'InvestSuite apps',
      description:
          'White-label investment and trading apps for financial institutions '
          'around the world — all built with Flutter.',
      linkLabel: 'investsuite.com',
      url: 'https://investsuite.com/',
    ),
    (
      color: AppColors.yellowPale,
      icon: 'assets/images/ijsjesradar-app-icon.png',
      title: 'ijsjesradar.app',
      description:
          'The ice-cream radar: get a notification the moment an ice-cream '
          'truck turns into your street. Somebody had to build it.',
      linkLabel: 'ijsjesradar.app',
      url: 'https://ijsjesradar.app/',
    ),
    (
      color: AppColors.tealPale,
      icon: 'assets/images/flutter-logo.png',
      title: 'Flutter Embedding',
      description:
          'Open-source tooling that turns a Flutter app into an embeddable module '
          'for iOS, Android, React Native, React Web and Angular — with type-safe '
          'Protocol Buffer communication.',
      linkLabel: 'krispypen.be/flutter_embedding',
      url: 'https://krispypen.be/flutter_embedding',
    ),
    (
      color: AppColors.purplePale,
      icon: null,
      title: 'The earlier years',
      description:
          'Before Flutter: years of Java, PHP and Android — CMSes, web services, '
          'Bolero, Kunstmaan CMS and native mobile apps.',
      linkLabel: 'More on LinkedIn',
      url: 'https://www.linkedin.com/in/krispypen/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _Band(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(label: 'WHAT I BUILD', title: 'Apps, tooling & community'),
          const SizedBox(height: 44),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth > 820;
              if (!twoColumns) {
                return Column(
                  children: [
                    for (final card in _cards) ...[
                      _ProjectCard(data: card),
                      const SizedBox(height: 20),
                    ],
                  ],
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < _cards.length; i += 2) ...[
                    if (i > 0) const SizedBox(height: 24),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _ProjectCard(data: _cards[i], stretch: true)),
                          const SizedBox(width: 24),
                          Expanded(
                            child: i + 1 < _cards.length
                                ? _ProjectCard(data: _cards[i + 1], stretch: true)
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.data, this.stretch = false});

  final ({Color color, String? icon, String title, String description, String linkLabel, String url}) data;

  /// Whether the card is height-stretched in a grid row (enables the Spacer
  /// that pins the link to the bottom; illegal in unbounded columns).
  final bool stretch;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(data.url),
      builder: (context, followLink) => _Hover(
        builder: (context, hovered) => GestureDetector(
          onTap: followLink,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            transform: Matrix4.translationValues(0, hovered ? -4 : 0, 0),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(24),
              boxShadow: hovered
                  ? [
                      BoxShadow(
                        color: AppColors.navy.withValues(alpha: 0.10),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ]
                  : const [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.icon != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(data.icon!, width: 48, height: 48, fit: BoxFit.cover),
                  )
                else
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.history, color: AppColors.purple, size: 26),
                  ),
                const SizedBox(height: 20),
                Text(data.title, style: AppText.heading(size: 22, weight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text(data.description, style: AppText.sans(size: 15.5)),
                const SizedBox(height: 22),
                if (stretch) const Spacer(),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        data.linkLabel,
                        style: AppText.sans(size: 15, weight: FontWeight.w600, color: AppColors.blueDark, height: 1.2),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedSlide(
                      offset: hovered ? const Offset(0.25, 0) : Offset.zero,
                      duration: const Duration(milliseconds: 150),
                      child: const Icon(Icons.arrow_forward, size: 17, color: AppColors.blueDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CommunitySection extends StatelessWidget {
  const _CommunitySection();

  @override
  Widget build(BuildContext context) {
    final wide = _isWide(context);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          label: 'COMMUNITY',
          title: 'Flutter Belgium, since 2018',
          dark: true,
          labelColor: AppColors.teal,
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Text(
            'Monthly meetups with talks, demos and pizza — helping the Belgian '
            'Flutter community grow from a handful of curious developers to a '
            'packed room every month.',
            style: AppText.sans(size: 17, color: Colors.white.withValues(alpha: 0.82)),
          ),
        ),
        const SizedBox(height: 32),
        _PillButton(
          label: 'Join a meetup',
          uri: Uri.parse('https://www.meetup.com/flutter-belgium/'),
          style: _PillStyle.teal,
          icon: Icons.north_east,
        ),
      ],
    );

    return _Band(
      color: AppColors.navy,
      child: wide
          ? Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: 60),
                SizedBox(
                  width: 300,
                  height: 280,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: const [
                      Positioned(top: 20, right: 16, child: _Circle(size: 110, color: AppColors.yellow)),
                      Positioned(bottom: 24, left: 6, child: _Circle(size: 64, color: AppColors.teal, ring: true)),
                      Positioned(
                        top: 62,
                        left: 62,
                        child: _Sticker(asset: 'assets/images/flutterbelgium-app-icon.png', size: 130, angle: -0.06, radius: 28),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : content,
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection();

  static final _items = [
    (
      chipBg: AppColors.skyMid,
      chipFg: AppColors.blueDark,
      period: 'NOW',
      title: 'Flutter developer',
      company: 'InvestSuite',
      description: 'Building white-label investment apps for financial institutions.',
    ),
    (
      chipBg: AppColors.skyMid,
      chipFg: AppColors.blueDark,
      period: 'NOW',
      title: 'Co-owner & developer',
      company: 'ijsjesradar.app',
      description: 'An app that notifies you when an ice-cream truck is nearby.',
    ),
    (
      chipBg: AppColors.tealPale,
      chipFg: AppColors.tealInk,
      period: '2018 —',
      title: 'Meetup organizer',
      company: 'Flutter Belgium',
      description: 'Organizing the monthly meetups and community events of the Belgian Flutter scene.',
    ),
    (
      chipBg: AppColors.yellowPale,
      chipFg: AppColors.yellowInk,
      period: 'BEFORE',
      title: 'Java, PHP & Android developer',
      company: 'various',
      description: 'CMSes, web services, Bolero, Kunstmaan CMS and native Android apps — the road that led to Flutter.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    return _Band(
      color: AppColors.skyFaint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(label: 'EXPERIENCE', title: 'Where I\'ve been'),
          const SizedBox(height: 40),
          for (final item in _items) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE1EEF5)),
              ),
              child: _ExperienceRow(item: item, narrow: narrow),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExperienceRow extends StatelessWidget {
  const _ExperienceRow({required this.item, required this.narrow});

  final ({Color chipBg, Color chipFg, String period, String title, String company, String description}) item;
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(color: item.chipBg, borderRadius: BorderRadius.circular(40)),
      child: Text(item.period, style: AppText.code(size: 11.5, color: item.chipFg, spacing: 1.2)),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: AppText.heading(size: 19, weight: FontWeight.w600, height: 1.3),
            children: [
              TextSpan(text: item.title),
              TextSpan(
                text: '  ·  ${item.company}',
                style: AppText.sans(size: 17, weight: FontWeight.w500, color: AppColors.blue, height: 1.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(item.description, style: AppText.sans(size: 15.5)),
      ],
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [chip, const SizedBox(height: 14), info],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        chip,
        const SizedBox(width: 28),
        Expanded(child: info),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    return _Band(
      color: AppColors.white,
      vertical: 104,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('SAY HELLO', style: AppText.code()),
          const SizedBox(height: 14),
          Text(
            'Let\'s build something',
            textAlign: TextAlign.center,
            style: AppText.heading(size: narrow ? 32 : 44),
          ),
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              'Got a Flutter question, a meetup idea, or an ice-cream tip? '
              'Ping me on LinkedIn or Bluesky — always happy to chat.',
              textAlign: TextAlign.center,
              style: AppText.sans(size: 17),
            ),
          ),
          const SizedBox(height: 34),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: WrapAlignment.center,
            children: [
              _PillButton(
                label: 'Message me on LinkedIn',
                uri: Uri.parse('https://www.linkedin.com/in/krispypen/'),
                icon: Icons.north_east,
              ),
              _PillButton(
                label: 'Bluesky',
                uri: Uri.parse('https://bsky.app/profile/krispypen.bsky.social'),
                style: _PillStyle.outlined,
                icon: Icons.north_east,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);

    final brand = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 10),
        Text('Kris Pypen', style: AppText.sans(size: 16, weight: FontWeight.w600, color: AppColors.white, height: 1.2)),
        const SizedBox(width: 14),
        Text(
          '© ${DateTime.now().year}',
          style: AppText.sans(size: 14, color: Colors.white.withValues(alpha: 0.55), height: 1.2),
        ),
      ],
    );

    final links = Wrap(
      spacing: 24,
      runSpacing: 12,
      children: [
        _NavLink(label: 'GitHub', uri: Uri.parse('https://github.com/krispypen'), dark: true),
        _NavLink(label: 'LinkedIn', uri: Uri.parse('https://www.linkedin.com/in/krispypen/'), dark: true),
        _NavLink(label: 'Bluesky', uri: Uri.parse('https://bsky.app/profile/krispypen.bsky.social'), dark: true),
      ],
    );

    return _Band(
      color: AppColors.navyDeep,
      vertical: 44,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (narrow) ...[
            brand,
            const SizedBox(height: 20),
            links,
          ] else
            Row(children: [brand, const Spacer(), links]),
          const SizedBox(height: 26),
          Row(
            children: [
              Image.asset('assets/images/flutter-logo.png', width: 16, height: 16),
              const SizedBox(width: 8),
              Text(
                'Built with Flutter',
                style: AppText.sans(size: 13.5, color: Colors.white.withValues(alpha: 0.55), height: 1.2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
