import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/link.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1), brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: 'Inter',
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
  late AnimationController _fadeController;
  late Animation<double> _heroAnimation;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _fadeController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _heroAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic));

    _heroController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _fadeController.dispose();
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
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _heroAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - _heroAnimation.value)),
              child: Opacity(
                opacity: _heroAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.1)],
                        ),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      child: const Icon(Icons.code, size: 100, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Kris Pypen',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Flutter Developer & Mobile Enthusiast',
                      style: TextStyle(fontSize: 24, color: Colors.white70, letterSpacing: 1),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          icon: Icons.work,
                          label: 'LinkedIn',
                          uri: Uri.parse('https://www.linkedin.com/in/krispypen/'),
                        ),
                        const SizedBox(width: 20),
                        _buildSocialButton(
                          icon: Icons.code,
                          label: 'GitHub',
                          uri: Uri.parse('https://github.com/krispypen'),
                        ),
                        const SizedBox(width: 20),
                        _buildSocialButton(
                          icon: Icons.chat,
                          label: 'Bluesky',
                          uri: Uri.parse('https://bsky.app/profile/krispypen.bsky.social'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text(
            'About Me',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 30),
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Text(
              'Passionate Flutter developer with extensive experience in mobile and web development. '
              'I love combining the best of both worlds to create amazing user experiences. '
              'Currently working at InvestSuite and co-owner of ijsjesradar.app. '
              'Organizer of Flutter Belgium Meetup since 2018, helping to build and grow the Flutter community.',
              style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.6),
              textAlign: TextAlign.center,
            ),
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
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text(
            'Experience',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: experiences.map((experience) {
                  return SizedBox(
                    width: constraints.maxWidth > 800 ? (constraints.maxWidth - 60) / 2 : constraints.maxWidth - 80,
                    child: _buildExperienceCard(experience),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(Map<String, dynamic> experience) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildExperienceIcon(experience['icon']),
          const SizedBox(height: 12),
          Text(
            experience['title'] as String,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            experience['company'] as String,
            style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            experience['period'] as String,
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              experience['description'] as String,
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7), height: 1.3),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceIcon(dynamic icon) {
    if (icon is String) {
      // Handle image path
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(image: AssetImage(icon), fit: BoxFit.cover),
        ),
      );
    } else {
      // Handle IconData
      return Icon(icon as IconData, color: Colors.white, size: 32);
    }
  }

  Widget _buildProjectsSection() {
    final projects = [
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
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text(
            'Featured Projects',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 40),
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (project['color'] as Color).withValues(alpha: 0.2),
            (project['color'] as Color).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (project['color'] as Color).withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: project['color'] as Color, borderRadius: BorderRadius.circular(15)),
            child: _buildProjectIcon(project['icon'], project['color'] as Color),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['title'] as String,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  project['description'] as String,
                  style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.8), height: 1.4),
                ),
              ],
            ),
          ),
          Link(
            uri: Uri.parse(project['url'] as String),
            builder: (context, followLink) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                onPressed: followLink,
                icon: const Icon(Icons.open_in_new, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectIcon(dynamic icon, Color backgroundColor) {
    if (icon is String) {
      // Handle image path - show the image with rounded corners
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: AssetImage(icon), fit: BoxFit.cover),
        ),
      );
    } else {
      // Handle IconData - show icon with background color
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(15)),
        child: Icon(icon as IconData, color: Colors.white, size: 40),
      );
    }
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text(
            'Get In Touch',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text('Feel free to reach out and connect!', style: TextStyle(fontSize: 18, color: Colors.white70)),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContactButton(icon: Icons.email, label: 'Email', uri: Uri.parse('mailto:krispypen@gmail.com')),
              const SizedBox(width: 20),
              _buildContactButton(
                icon: Icons.work,
                label: 'LinkedIn',
                uri: Uri.parse('https://www.linkedin.com/in/krispypen/'),
              ),
              const SizedBox(width: 20),
              _buildContactButton(icon: Icons.code, label: 'GitHub', uri: Uri.parse('https://github.com/krispypen')),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            '© ${DateTime.now().year} Kris Pypen. Built with Flutter 💙',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 10),
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
