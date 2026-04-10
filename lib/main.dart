import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  runApp(const AkshayPortfolioApp());
}

class AkshayPortfolioApp extends StatelessWidget {
  const AkshayPortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akshay Kumar M - Video Editor & Designer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFF00D9FF),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00D9FF),
          secondary: const Color(0xFFFF6B6B),
          background: const Color(0xFF0A0A0A),
          surface: const Color(0xFF1A1A1A),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({Key? key}) : super(key: key);

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  double _scrollOffset = 0;
  int _selectedSection = 0;
  bool _isScrolling = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _projectController;
  late TextEditingController _messageController;
  bool _isSending = false;

  final List<GlobalKey> _keys = List.generate(6, (index) => GlobalKey());

  bool get _isMobile => MediaQuery.of(context).size.width < 800;
  bool get _isTablet =>
      MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width < 1200;

  double get _horizontalPadding => _isMobile ? 20.0 : (_isTablet ? 40.0 : 80.0);
  double get _verticalPadding => _isMobile ? 60.0 : 120.0;

  final List<String> _navItems = [
    'Home',
    'About',
    'Skills',
    'Experience',
    'Portfolio',
    'Contact'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
        if (!_isScrolling) {
          _updateActiveSection();
        }
      });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _projectController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _projectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),

          // Main Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildHeroSection(),
              _buildAboutSection(),
              _buildSkillsSection(),
              _buildExperienceSection(),
              _buildGamingSection(),
              _buildPortfolioSection(),
              _buildEducationSection(),
              _buildContactSection(),
              _buildFooterSection(),
            ],
          ),

          // Floating Navigation
          _buildFloatingNav(),
        ],
      ),
    );
  }

  void _updateActiveSection() {
    for (int i = _keys.length - 1; i >= 0; i--) {
      final key = _keys[i];
      if (key.currentContext != null) {
        final box = key.currentContext!.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;
        if (position <= 150) {
          if (_selectedSection != i) {
            setState(() {
              _selectedSection = i;
            });
          }
          break;
        }
      }
    }
  }

  void _onSendMessage() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String project = _projectController.text.trim();
    final String message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      _showToast('Please fill in Name, Email, and Message', isError: true);
      return;
    }

    setState(() => _isSending = true);

    try {
      // PRO TIP: To make this actually send to your email, 
      // Replace these placeholders with your real EmailJS keys:
      // https://www.emailjs.com/
      const String serviceId = 'YOUR_SERVICE_ID';
      const String templateId = 'YOUR_TEMPLATE_ID';
      const String publicKey = 'YOUR_PUBLIC_KEY';

      // For now, we'll simulate a 1.5s network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check if we have real keys or placeholders
      if (serviceId != 'YOUR_SERVICE_ID') {
        final response = await http.post(
          Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': publicKey,
            'template_params': {
              'from_name': name,
              'from_email': email,
              'project_type': project,
              'message': message,
              'to_email': 'akshaytheking101@gmail.com',
            },
          }),
        );

        if (response.statusCode == 200) {
          _clearFormAndShowSuccess();
        } else {
          _showToast('Failed to send (Error ${response.statusCode}). Check console.', isError: true);
        }
      } else {
        // DEMO MODE: Successfully clear and show toast without real API call
        _clearFormAndShowSuccess();
      }
    } catch (e) {
      _showToast('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _clearFormAndShowSuccess() {
    _nameController.clear();
    _emailController.clear();
    _projectController.clear();
    _messageController.clear();
    _showToast('Message Sent Successfully!');
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isError ? Colors.redAccent.withOpacity(0.9) : const Color(0xFF1A1A1A).withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isError ? Colors.red : const Color(0xFF00D9FF).withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isError ? Colors.red : const Color(0xFF00D9FF)).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: isError ? Colors.white : const Color(0xFF00D9FF),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToSection(int index) {
    setState(() {
      _isScrolling = true;
      _selectedSection = index;
    });

    final key = _keys[index];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      ).then((_) {
        _isScrolling = false;
      });
    }
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A0A0A),
                  const Color(0xFF1A1A1A).withOpacity(0.8),
                  const Color(0xFF0A0A0A),
                ],
              ),
            ),
            child: CustomPaint(
              painter: GridPainter(
                scrollOffset: _scrollOffset,
                animationValue: _animationController.value,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingNav() {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _scrollOffset > 100 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A).withOpacity(0.9),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: const Color(0xFF00D9FF).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D9FF).withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _navItems.asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isMobile ? 10 : 15,
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _scrollToSection(entry.key),
                        child: Text(
                          entry.value,
                          style: GoogleFonts.spaceMono(
                            color: _selectedSection == entry.key
                                ? const Color(0xFF00D9FF)
                                : Colors.white70,
                            fontSize: _isMobile ? 12 : 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        key: _keys[0],
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Cinematic overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0A0A0A).withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated name
                    FadeInSlide(
                      delay: 0.3,
                      child: Text(
                        'AKSHAY KUMAR M',
                        style: GoogleFonts.bebasNeue(
                          fontSize: _isMobile ? 60 : (_isTablet ? 90 : 120),
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                          letterSpacing: _isMobile ? 4 : 8,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                Color(0xFF00D9FF),
                                Color(0xFFFFFFFF),
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0, 0, 800, 100),
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title with glitch effect
                    FadeInSlide(
                      delay: 0.5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: const Color(0xFF00D9FF),
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInSlide(
                              delay: 0.3,
                              persistent: false,
                              child: Text(
                                'CREATIVE VIDEO EDITOR',
                                style: GoogleFonts.rajdhani(
                                  fontSize: _isMobile ? 24 : 36,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: _isMobile ? 2 : 4,
                                ),
                              ),
                            ),
                            FadeInSlide(
                              delay: 0.5,
                              persistent: false,
                              child: Text(
                                '& GRAPHIC DESIGNER',
                                style: GoogleFonts.rajdhani(
                                  fontSize: _isMobile ? 24 : 36,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF00D9FF),
                                  letterSpacing: _isMobile ? 2 : 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Description
                    FadeInSlide(
                      delay: 0.7,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Text(
                          '4+ Years of Experience in Video Editing, Post-Production & Visual Storytelling',
                          style: GoogleFonts.inter(
                            fontSize: _isMobile ? 16 : 18,
                            color: Colors.white70,
                            height: 1.6,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // CTA Buttons
                    FadeInSlide(
                      delay: 0.9,
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _buildCTAButton(
                            'VIEW MY WORK',
                            true,
                            onTap: () => _scrollToSection(4),
                          ),
                          _buildCTAButton(
                            'CONTACT ME',
                            false,
                            onTap: () => _scrollToSection(5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scroll indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _scrollOffset < 100 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Text(
                        'SCROLL',
                        style: GoogleFonts.spaceMono(
                          color: Colors.white38,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 2,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF00D9FF),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTAButton(String text, bool isPrimary, {VoidCallback? onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          decoration: BoxDecoration(
            color: isPrimary ? const Color(0xFF00D9FF) : Colors.transparent,
            border: Border.all(
              color: const Color(0xFF00D9FF),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(0),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D9FF).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: (_isSending && text == 'SEND MESSAGE')
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isPrimary ? Colors.black : const Color(0xFF00D9FF),
                    ),
                  ),
                )
              : Text(
                  text,
                  style: GoogleFonts.spaceMono(
                    color: isPrimary ? Colors.black : const Color(0xFF00D9FF),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildAboutSection() {
    return SliverToBoxAdapter(
      child: Container(
        key: _keys[1],
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Flex(
          direction: _isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Image placeholder
            Flexible(
              flex: _isMobile ? 0 : 2,
              child: FadeInSlide(
                delay: 0.2,
                persistent: false,
                child: HoverItem(
                  child: Container(
                    height: _isMobile ? 400 : 600,
                    width: _isMobile ? double.infinity : null,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(
                        color: const Color(0xFF00D9FF).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.person,
                            size: 200,
                            color: const Color(0xFF00D9FF).withOpacity(0.2),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            color: const Color(0xFF00D9FF),
                            child: Text(
                              'ABOUT',
                              style: GoogleFonts.spaceMono(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: _isMobile ? 0 : 60,
              height: _isMobile ? 40 : 0,
            ),
            // Right side - Content
            Flexible(
              flex: _isMobile ? 0 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ABOUT ME',
                    style: GoogleFonts.bebasNeue(
                      fontSize: _isMobile ? 60 : 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 100,
                    height: 4,
                    color: const Color(0xFF00D9FF),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Dynamic Video Editor & Graphic Designer with 4+ years of experience in video editing and 2+ years in graphic design at leading creative studios. A BCA graduate passionate about delivering high-quality edits that align with the director\'s vision.',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Skilled in Adobe Creative Cloud, DaVinci Resolve, and modern post-production workflows.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Highlights
                  ...[
                    'Strong sense of storytelling and continuity',
                    'Experience in studio and client-based projects',
                    'Detail-oriented with smooth pacing and clean transitions',
                  ].map((highlight) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00D9FF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                highlight,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSkillsSection() {
    final skills = {
      'VIDEO EDITING': [
        'Adobe Premiere Pro',
        'DaVinci Resolve',
        'Final Cut Pro',
        'Wondershare Filmora',
      ],
      'DESIGN & MOTION': [
        'Adobe After Effects',
        'Adobe Photoshop',
        'Adobe Illustrator',
        'Blender (Basic 3D)',
      ],
      'UI & CREATIVE': [
        'Figma',
        'Canva',
      ],
    };

    return SliverToBoxAdapter(
      child: Container(
        key: _keys[2],
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        color: const Color(0xFF0F0F0F),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SKILLS',
              style: GoogleFonts.bebasNeue(
                fontSize: _isMobile ? 60 : 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: _isMobile ? 4 : 8,
              ),
            ),
            const SizedBox(height: 60),

            // Skills grid
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
                
                final skillWidgets = skills.entries.map((category) {
                  return FadeInSlide(
                    delay: 0.2,
                    persistent: false,
                    child: HoverItem(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF00D9FF),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              category.key,
                              style: GoogleFonts.spaceMono(
                                color: const Color(0xFF00D9FF),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ...category.value.map((skill) => Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Text(
                                  skill,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                }).toList();

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: skillWidgets[0]),
                      const SizedBox(width: 40),
                      Expanded(child: skillWidgets[1]),
                      const SizedBox(width: 40),
                      Expanded(child: skillWidgets[2]),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: skillWidgets.map((widget) => Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: widget,
                    )).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildExperienceSection() {
    return SliverToBoxAdapter(
      child: Container(
        key: _keys[3],
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EXPERIENCE',
              style: GoogleFonts.bebasNeue(
                fontSize: _isMobile ? 60 : 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: _isMobile ? 4 : 8,
              ),
            ),
            const SizedBox(height: 80),

            // Experience items
            FadeInSlide(
              delay: 0.1,
              persistent: false,
              child: HoverItem(
                child: _buildExperienceItem(
                  'VIDEO EDITOR',
                  'Video & Photography Studios',
                  'May 2020 - Jan 2024',
                  [
                    'Edited raw footage into polished videos for broadcast and digital platforms',
                    'Collaborated with directors and production teams to meet creative requirements',
                    'Managed rough cuts and final cuts ensuring smooth sequencing and continuity',
                    'Integrated music, dialogues, graphics, and effects into cohesive stories',
                    'Continuously adopted new editing techniques and industry best practices',
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
            FadeInSlide(
              delay: 0.2,
              persistent: false,
              child: HoverItem(
                child: _buildExperienceItem(
                  'GRAPHIC DESIGNER',
                  'Trice Technologies',
                  '2024 - 2026',
                  [
                    'Designed creative visual assets for digital and print platforms',
                    'Worked on branding materials, social media creatives, posters, and marketing designs',
                    'Collaborated with marketing and development teams to maintain brand consistency',
                    'Used Adobe Photoshop, Illustrator, Figma, and Canva for high-quality designs',
                    'Managed multiple projects while meeting deadlines and client requirements',
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceItem(
    String title,
    String company,
    String period,
    List<String> responsibilities,
  ) {
    return Container(
      padding: EdgeInsets.all(_isMobile ? 20 : 40),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF00D9FF).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flex(
            direction: _isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.rajdhani(
                      fontSize: _isMobile ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00D9FF),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    company,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                color: const Color(0xFF1A1A1A),
                child: Text(
                  period,
                  style: GoogleFonts.spaceMono(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ...responsibilities.map((resp) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D9FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        resp,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.white70,
                          height: 1.6,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildGamingSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        color: const Color(0xFF0F0F0F),
        child: Flex(
          direction: _isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            Flexible(
              flex: _isMobile ? 0 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    color: const Color(0xFFFF6B6B),
                    child: Text(
                      'GAMING',
                      style: GoogleFonts.spaceMono(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'GAMING & STREAMING',
                    style: GoogleFonts.bebasNeue(
                      fontSize: _isMobile ? 60 : 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Beyond professional editing, I\'m passionate about gaming and creating engaging gaming content for YouTube. I stream and create gameplay videos featuring popular titles including GTA V, Harry Potter games, and other immersive story-driven experiences.',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white70,
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'My gaming content combines my professional video editing skills with my passion for storytelling, creating cinematic gaming experiences that engage and entertain viewers.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white60,
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Gaming highlights
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildGamingTag('GTA V Gameplay'),
                      _buildGamingTag('Harry Potter Series'),
                      _buildGamingTag('Story-Driven Games'),
                      _buildGamingTag('Content Creation'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: _isMobile ? 0 : 80,
              height: _isMobile ? 40 : 0,
            ),
            // Gaming illustration/image placeholder
            Flexible(
              flex: _isMobile ? 0 : 1,
              child: FadeInSlide(
                delay: 0.3,
                persistent: false,
                child: HoverItem(
                  child: Container(
                    height: _isMobile ? 300 : 500,
                    width: _isMobile ? double.infinity : null,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(
                        color: const Color(0xFFFF6B6B).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.sports_esports,
                        size: _isMobile ? 80 : 150,
                        color: const Color(0xFFFF6B6B).withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamingTag(String text) {
    return HoverItem(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFFF6B6B).withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPortfolioSection() {
    final List<Map<String, String>> portfolioAssets = [
      {'type': 'image', 'path': 'assets/banner_beauty.jpeg', 'label': 'BEAUTY CAMPAIGN'},
      {'type': 'image', 'path': 'assets/banner_bridal.jpeg', 'label': 'WEDDING HIGHLIGHT'},
      {'type': 'image', 'path': 'assets/banner_christmas.jpeg', 'label': 'CHRISTMAS SPECIAL'},
      {'type': 'image', 'path': 'assets/banner_eid.jpeg', 'label': 'EID CELEBRATION'},
      {'type': 'image', 'path': 'assets/banner_interiors.jpeg', 'label': 'INTERIOR DESIGN'},
      {'type': 'image', 'path': 'assets/banner_onam.jpeg', 'label': 'ONAM FESTIVAL'},
      {'type': 'video', 'path': 'assets/video_1.mp4', 'label': 'PROMOTIONAL VIDEO'},
      {'type': 'video', 'path': 'assets/video_2.mp4', 'label': 'SHORT FILM'},
      {'type': 'video', 'path': 'assets/video_3.mp4', 'label': 'SOCIAL MEDIA EDIT'},
    ];

    return SliverToBoxAdapter(
      child: Container(
        key: _keys[4],
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PORTFOLIO',
              style: GoogleFonts.bebasNeue(
                fontSize: _isMobile ? 60 : 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: _isMobile ? 4 : 8,
              ),
            ),
            const SizedBox(height: 60),

            // Portfolio grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _isMobile ? 1 : (_isTablet ? 2 : 3),
                crossAxisSpacing: _isMobile ? 20 : 30,
                mainAxisSpacing: _isMobile ? 20 : 30,
                childAspectRatio: 1.3,
              ),
              itemCount: portfolioAssets.length,
              itemBuilder: (context, index) {
                final asset = portfolioAssets[index];
                return FadeInSlide(
                  delay: (index % 3) * 0.1,
                  persistent: false,
                  child: HoverItem(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => PortfolioLightbox(asset: asset),
                        );
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            border: Border.all(
                              color: const Color(0xFF00D9FF).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Media Content
                              asset['type'] == 'video'
                                  ? PortfolioVideoPlayer(
                                      videoPath: asset['path']!)
                                  : Image.asset(
                                      asset['path']!,
                                      fit: BoxFit.contain,
                                    ),

                              // Overlay Graphic
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.9),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.4],
                                  ),
                                ),
                              ),

                              // Label
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    asset['label']!,
                                    style: GoogleFonts.spaceMono(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildEducationSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        color: const Color(0xFF0F0F0F),
        child: Flex(
          direction: _isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: _isMobile ? 0 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EDUCATION',
                    style: GoogleFonts.bebasNeue(
                      fontSize: _isMobile ? 60 : 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeInSlide(
                    delay: 0.1,
                    persistent: false,
                    child: HoverItem(
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF00D9FF).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bachelor of Computer Applications',
                              style: GoogleFonts.rajdhani(
                                fontSize: _isMobile ? 22 : 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00D9FF),
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Bharathmatha College, Calicut University',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.white70,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '2017 - 2020',
                              style: GoogleFonts.spaceMono(
                                fontSize: 14,
                                color: Colors.white60,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Kozhinjampara, Palakkad, Kerala',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white54,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: _isMobile ? 0 : 60,
              height: _isMobile ? 60 : 0,
            ),
            Flexible(
              flex: _isMobile ? 0 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LANGUAGES',
                    style: GoogleFonts.bebasNeue(
                      fontSize: _isMobile ? 60 : 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ...[
                    {'lang': 'Malayalam', 'level': 'Native'},
                    {'lang': 'English', 'level': 'Professional'},
                    {'lang': 'Tamil', 'level': 'Basic'},
                  ].map((lang) => Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                lang['lang']!,
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF00D9FF),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                lang['level']!,
                                style: GoogleFonts.spaceMono(
                                  fontSize: 12,
                                  color: const Color(0xFF00D9FF),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildContactSection() {
    return SliverToBoxAdapter(
      child: Container(
        key: _keys[5],
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LET\'S WORK',
              style: GoogleFonts.bebasNeue(
                fontSize: _isMobile ? 60 : 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: _isMobile ? 4 : 8,
              ),
            ),
            Text(
              'TOGETHER',
              style: GoogleFonts.bebasNeue(
                fontSize: _isMobile ? 60 : 100,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00D9FF),
                letterSpacing: _isMobile ? 4 : 8,
              ),
            ),
            const SizedBox(height: 80),
            Flex(
              direction: _isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact info
                Flexible(
                  flex: _isMobile ? 0 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactInfo(
                        'PHONE',
                        '+91 9061399383',
                        Icons.phone,
                      ),
                      SizedBox(height: _isMobile ? 20 : 40),
                      _buildContactInfo(
                        'EMAIL',
                        'akshaytheking101@gmail.com',
                        Icons.email,
                      ),
                      SizedBox(height: _isMobile ? 20 : 40),
                      _buildContactInfo(
                        'LOCATION',
                        'Kunnachi, Elappully\nPalakkad, Kerala\nIndia - 678622',
                        Icons.location_on,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: _isMobile ? 0 : 80,
                  height: _isMobile ? 60 : 0,
                ),

                // Contact form
                Flexible(
                  flex: _isMobile ? 0 : 2,
                  child: Column(
                    children: [
                      _buildTextField('Your Name', _nameController),
                      const SizedBox(height: 20),
                      _buildTextField('Your Email', _emailController),
                      const SizedBox(height: 20),
                      _buildTextField('Project Type', _projectController),
                      const SizedBox(height: 20),
                      _buildTextField('Message', _messageController, maxLines: 5),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildCTAButton('SEND MESSAGE', true,
                            onTap: _onSendMessage),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF00D9FF),
              size: 24,
            ),
            const SizedBox(width: 15),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: _isMobile ? 10 : 12,
                color: Colors.white60,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 39),
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.white,
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF00D9FF).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: Colors.white30,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildFooterSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _isMobile ? 40 : 60,
        ),
        color: const Color(0xFF0A0A0A),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: [
                {
                  'name': 'YouTube',
                  'url': 'https://www.youtube.com/@WolfgamerAK'
                },
                {
                  'name': 'Instagram',
                  'url':
                      'https://www.instagram.com/akshay_thewolf?utm_source=qr&igsh=MTI4Z2ttb3BoZmpvZw=='
                },
              ]
                  .map((social) => FadeInSlide(
                        delay: 0.1,
                        persistent: false,
                        child: HoverItem(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                final Uri _url = Uri.parse(social['url']!);
                                if (!await launchUrl(_url)) {
                                  throw 'Could not launch $_url';
                                }
                              },
                              child: Text(
                                social['name']!,
                                style: GoogleFonts.spaceMono(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 40),
            Container(
              height: 1,
              width: 200,
              color: const Color(0xFF00D9FF).withOpacity(0.3),
            ),
            const SizedBox(height: 40),
            Text(
              '© 2026 Akshay Kumar M | Video Editor & Multimedia Expert',
              style: GoogleFonts.spaceMono(
                color: Colors.white30,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for animated grid background
class GridPainter extends CustomPainter {
  final double scrollOffset;
  final double animationValue;

  GridPainter({
    required this.scrollOffset,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D9FF).withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;
    final offset = (scrollOffset * 0.1) % gridSize;

    // Draw vertical lines
    for (double x = -offset; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = -offset; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => true;
}

// Fade in slide animation widget
class FadeInSlide extends StatefulWidget {
  final Widget child;
  final double delay;
  final bool persistent; // If false, will fade out when leaving view

  const FadeInSlide({
    Key? key,
    required this.child,
    this.delay = 0,
    this.persistent = true,
  }) : super(key: key);

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _handleVisibility(double visibleFraction) {
    if (visibleFraction > 0.1 && !_isVisible) {
      _isVisible = true;
      Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
        if (mounted) _controller.forward();
      });
    } else if (visibleFraction == 0 && _isVisible && !widget.persistent) {
      _isVisible = false;
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('fade_in_${identityHashCode(this)}'),
      onVisibilityChanged: (info) => _handleVisibility(info.visibleFraction),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

// Interactive Hover Item Wrapper
class HoverItem extends StatefulWidget {
  final Widget child;
  const HoverItem({Key? key, required this.child}) : super(key: key);

  @override
  State<HoverItem> createState() => _HoverItemState();
}

class _HoverItemState extends State<HoverItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D9FF).withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class PortfolioVideoPlayer extends StatefulWidget {
  final String videoPath;

  const PortfolioVideoPlayer({Key? key, required this.videoPath}) : super(key: key);

  @override
  State<PortfolioVideoPlayer> createState() => _PortfolioVideoPlayerState();
}

class _PortfolioVideoPlayerState extends State<PortfolioVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..setLooping(true)
      ..setVolume(0.0)
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _controller.play(); // Auto-play looping video like a thumbnail
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00D9FF)),
      );
    }
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
          // if (_isHovering)
            // Center(
            //   // child: Icon(
            //   //   Icons.play_circle_outline,
            //   //   size: 80,
            //   //   color: const Color(0xFF00D9FF).withOpacity(0.8),
            //   // ),
            // ),
        ],
      ),
    );
  }
}

class PortfolioLightbox extends StatefulWidget {
  final Map<String, String> asset;

  const PortfolioLightbox({Key? key, required this.asset}) : super(key: key);

  @override
  State<PortfolioLightbox> createState() => _PortfolioLightboxState();
}

class _PortfolioLightboxState extends State<PortfolioLightbox> {
  final TransformationController _transformationController = TransformationController();

  void _zoomIn() {
    final matrix = _transformationController.value.clone();
    matrix.scale(1.2, 1.2, 1.0);
    _transformationController.value = matrix;
  }

  void _zoomOut() {
    final matrix = _transformationController.value.clone();
    matrix.scale(1 / 1.2, 1 / 1.2, 1.0);
    _transformationController.value = matrix;
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(color: Colors.transparent),
            ),
          ),
          
          // Image / Video content
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00D9FF), width: 2),
              color: const Color(0xFF0F0F0F),
            ),
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 4.0,
              child: widget.asset['type'] == 'video'
                  ? PortfolioVideoPlayer(videoPath: widget.asset['path']!)
                  : Image.asset(widget.asset['path']!, fit: BoxFit.contain),
            ),
          ),

          // Close Button
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 40),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Zoom Controls
          // Positioned(
          //   bottom: 20,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //     decoration: BoxDecoration(
          //       color: const Color(0xFF1A1A1A).withOpacity(0.9),
          //       borderRadius: BorderRadius.circular(30),
          //       border: Border.all(color: const Color(0xFF00D9FF).withOpacity(0.5)),
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         IconButton(
          //           icon: const Icon(Icons.zoom_out, color: Color(0xFF00D9FF)),
          //           onPressed: _zoomOut,
          //           tooltip: "Zoom Out",
          //         ),
          //         const SizedBox(width: 20),
          //         IconButton(
          //           icon: const Icon(Icons.zoom_in, color: Color(0xFF00D9FF)),
          //           onPressed: _zoomIn,
          //           tooltip: "Zoom In",
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
