import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/link.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized().ensureSemantics();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kris Pypen - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0175C2), brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late Animation<double> _heroAnimation;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _heroAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic));
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildAboutSection(),
            _buildExperienceSection(),
            _buildProjectsSection(),
            _buildContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF0A0E27)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _heroAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _heroAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - _heroAnimation.value)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0175C2).withValues(alpha: 0.3), width: 2),
                        ),
                        child: const Icon(Icons.code, size: 80, color: Color(0xFF0175C2)),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Kris Pypen',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Flutter Developer & Mobile Enthusiast',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Color(0xFF9CA3AF), letterSpacing: 0),
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildSocialButton(
                            icon: Icons.work,
                            label: 'LinkedIn',
                            uri: Uri.parse('https://www.linkedin.com/in/krispypen/'),
                          ),
                          _buildSocialButton(
                            icon: Icons.code,
                            label: 'GitHub',
                            uri: Uri.parse('https://github.com/krispypen'),
                          ),
                          _buildSocialButton(
                            icon: Icons.chat,
                            label: 'Bluesky',
                            uri: Uri.parse('https://bsky.app/profile/krispypen.bsky.social'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required String label, required Uri uri}) {
    return Link(
      uri: uri,
      builder: (context, followLink) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: followLink,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF0175C2).withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: const Color(0xFF0175C2), size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        children: [
          const Text(
            'About Me',
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Passionate Flutter developer with extensive experience in mobile and web development. '
            'I love combining the best of both worlds to create amazing user experiences. '
            'Currently working at InvestSuite and co-owner of ijsjesradar.app. '
            'Organizer of Flutter Belgium Meetup since 2018, helping to build and grow the Flutter community.',
            style: TextStyle(fontSize: 18, color: Color(0xFF9CA3AF), height: 1.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection() {
    final experiences = [
      {
        'title': 'Flutter Developer',
        'company': 'InvestSuite',
        'period': 'Current',
        'description': 'Developing innovative financial applications using Flutter',
        'icon': 'assets/images/flutter-logo.png',
      },
      {
        'title': 'Co-owner & Developer',
        'company': 'ijsjesradar.app',
        'period': 'Current',
        'description': 'Ice cream radar app for getting notified when an ice cream truck is nearby',
        'icon': 'assets/images/ijsjesradar-app-icon.png',
      },
      {
        'title': 'Meetup Organizer',
        'company': 'Flutter Belgium',
        'period': '2018 - Current',
        'description': 'Organizing monthly Flutter meetups and community events',
        'icon': 'assets/images/flutterbelgium-app-icon.png',
      },
      {
        'title': 'Android Developer',
        'company': 'Various',
        'period': 'Previous',
        'description': 'Mobile application development for Android platform',
        'icon': Icons.phone_android,
      },
      {
        'title': 'PHP Developer',
        'company': 'Various',
        'period': 'Previous',
        'description': 'Kunstmaan CMS and web development',
        'icon': Icons.web,
      },
      {
        'title': 'Java Developer',
        'company': 'Various',
        'period': 'Previous',
        'description': 'CMS, Web services, and Bolero development',
        'icon': Icons.computer,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        children: [
          const Text(
            'Experience',
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900
                  ? 3
                  : constraints.maxWidth > 600
                  ? 2
                  : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.25,
                ),
                itemCount: experiences.length,
                itemBuilder: (context, index) {
                  return _buildExperienceCard(experiences[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(Map<String, dynamic> experience) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0175C2).withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildExperienceIcon(experience['icon']),
          const SizedBox(height: 16),
          Text(
            experience['title'] as String,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            experience['company'] as String,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0175C2), fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            experience['period'] as String,
            style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            experience['description'] as String,
            style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF), height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceIcon(dynamic icon) {
    if (icon is String) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(image: AssetImage(icon), fit: BoxFit.cover),
        ),
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF0175C2).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon as IconData, color: const Color(0xFF0175C2), size: 24),
      );
    }
  }

  Widget _buildProjectsSection() {
    final projects = [
      {
        'title': 'Flutter Embedding',
        'description':
            'Transform your Flutter application into an embeddable module for iOS, Android, React Native, React Web, and Angular — with type-safe Protocol Buffer communication.',
        'url': 'https://krispypen.be/flutter_embedding',
        'icon': 'assets/images/flutter-logo.png',
        'color': const Color(0xFF0175C2),
      },
      {
        'title': 'ijsjesradar.app',
        'description': 'Ice cream radar app for getting notified when an ice cream truck is nearby',
        'url': 'https://ijsjesradar.app/',
        'icon': 'assets/images/ijsjesradar-app-icon.png',
        'color': Colors.pink,
      },
      {
        'title': 'Flutter Belgium Meetup',
        'description': 'Flutter community meetups in Belgium',
        'url': 'https://www.meetup.com/flutter-belgium/',
        'icon': 'assets/images/flutterbelgium-app-icon.png',
        'color': Colors.blue,
      },
      {
        'title': 'InvestSuite Apps',
        'description': 'Financial applications built with Flutter',
        'url': 'https://investsuite.com/',
        'icon': 'assets/images/investsuite-app-icon.png',
        'color': Colors.black,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        children: [
          const Text(
            'Featured Projects',
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Projects I\'ve worked on and contributed to',
            style: TextStyle(fontSize: 18, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 48),
          AnimationLimiter(
            child: Column(
              children: List.generate(projects.length, (index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: _buildProjectCard(projects[index])),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (project['color'] as Color).withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: (project['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildProjectIcon(project['icon'], project['color'] as Color),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['title'] as String,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  project['description'] as String,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF9CA3AF), height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Link(
            uri: Uri.parse(project['url'] as String),
            builder: (context, followLink) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: followLink,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (project['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: (project['color'] as Color).withValues(alpha: 0.3), width: 1),
                  ),
                  child: Icon(Icons.open_in_new, color: project['color'] as Color, size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectIcon(dynamic icon, Color backgroundColor) {
    if (icon is String) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: AssetImage(icon), fit: BoxFit.cover),
        ),
      );
    } else {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon as IconData, color: backgroundColor, size: 40),
      );
    }
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        children: [
          const Text(
            'Get In Touch',
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
          ),
          const SizedBox(height: 16),
          const Text('Feel free to reach out and connect!', style: TextStyle(fontSize: 18, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 48),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildContactButton(icon: Icons.email, label: 'Email', uri: Uri.parse('mailto:krispypen@gmail.com')),
              _buildContactButton(
                icon: Icons.work,
                label: 'LinkedIn',
                uri: Uri.parse('https://www.linkedin.com/in/krispypen/'),
              ),
              _buildContactButton(icon: Icons.code, label: 'GitHub', uri: Uri.parse('https://github.com/krispypen')),
            ],
          ),
          const SizedBox(height: 64),
          Text(
            '© ${DateTime.now().year} Kris Pypen. Built with Flutter 💙',
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({required IconData icon, required String label, required Uri uri}) {
    return Link(
      uri: uri,
      builder: (context, followLink) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: followLink,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0175C2), Color(0xFF025A8F)]),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0175C2).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
