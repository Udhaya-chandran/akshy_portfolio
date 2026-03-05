import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

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
      });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _navItems.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSection = entry.key;
                        });
                      },
                      child: Text(
                        entry.value,
                        style: GoogleFonts.spaceMono(
                          color: _selectedSection == entry.key
                              ? const Color(0xFF00D9FF)
                              : Colors.white70,
                          fontSize: 14,
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
    );
  }

  SliverToBoxAdapter _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 40),
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
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                          letterSpacing: 8,
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
                            Text(
                              'CREATIVE VIDEO EDITOR',
                              style: GoogleFonts.rajdhani(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 4,
                              ),
                            ),
                            Text(
                              '& GRAPHIC DESIGNER',
                              style: GoogleFonts.rajdhani(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00D9FF),
                                letterSpacing: 4,
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
                      child: SizedBox(
                        width: 600,
                        child: Text(
                          '4+ Years of Experience in Video Editing, Post-Production & Visual Storytelling',
                          style: GoogleFonts.inter(
                            fontSize: 18,
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
                      child: Row(
                        children: [
                          _buildCTAButton(
                            'VIEW MY WORK',
                            true,
                          ),
                          const SizedBox(width: 20),
                          _buildCTAButton(
                            'CONTACT ME',
                            false,
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

  Widget _buildCTAButton(String text, bool isPrimary) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
        child: Text(
          text,
          style: GoogleFonts.spaceMono(
            color: isPrimary ? Colors.black : const Color(0xFF00D9FF),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildAboutSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 120),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Image placeholder
            Expanded(
              flex: 2,
              child: Container(
                height: 600,
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
            const SizedBox(width: 60),

            // Right side - Content
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ABOUT ME',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 80,
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
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 120),
        color: const Color(0xFF0F0F0F),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SKILLS',
              style: GoogleFonts.bebasNeue(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 60),

            // Skills grid
            Wrap(
              spacing: 40,
              runSpacing: 60,
              children: skills.entries.map((category) {
                return Container(
                  width: (MediaQuery.of(context).size.width - 200) / 3,
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
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildExperienceSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EXPERIENCE',
              style: GoogleFonts.bebasNeue(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 80),

            // Experience items
            _buildExperienceItem(
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
            const SizedBox(height: 80),
            _buildExperienceItem(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.rajdhani(
                      fontSize: 32,
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
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 120),
        color: const Color(0xFF0F0F0F),
        child: Row(
          children: [
            Expanded(
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
                      fontSize: 80,
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
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      'GTA V Gameplay',
                      'Harry Potter Series',
                      'Story-Driven Games',
                      'Cinematic Edits',
                    ]
                        .map((game) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      const Color(0xFFFF6B6B).withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                game,
                                style: GoogleFonts.spaceMono(
                                  color: const Color(0xFFFF6B6B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            Expanded(
              child: Container(
                height: 500,
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
                    size: 150,
                    color: const Color(0xFFFF6B6B).withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPortfolioSection() {
    final categories = [
      'PROMOTIONAL VIDEOS',
      'SHORT FILMS',
      'WEDDING HIGHLIGHTS',
      'GAMING CONTENT',
      'SOCIAL MEDIA EDITS',
      'REELS & TRAILERS',
    ];

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PORTFOLIO',
              style: GoogleFonts.bebasNeue(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 60),

            // Portfolio grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 1.3,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return MouseRegion(
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
                      children: [
                        Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 80,
                            color: const Color(0xFF00D9FF).withOpacity(0.3),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.black.withOpacity(0.8),
                            child: Text(
                              categories[index],
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
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 120),
        color: const Color(0xFF0F0F0F),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EDUCATION',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
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
                            fontSize: 28,
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
                ],
              ),
            ),
            const SizedBox(width: 60),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LANGUAGES',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 80,
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
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LET\'S WORK',
              style: GoogleFonts.bebasNeue(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 8,
              ),
            ),
            Text(
              'TOGETHER',
              style: GoogleFonts.bebasNeue(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00D9FF),
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 80),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactInfo(
                        'PHONE',
                        '+91 9061399383',
                        Icons.phone,
                      ),
                      const SizedBox(height: 40),
                      _buildContactInfo(
                        'EMAIL',
                        'Akshaytheking101@gmail.com',
                        Icons.email,
                      ),
                      const SizedBox(height: 40),
                      _buildContactInfo(
                        'LOCATION',
                        'Kunnachi, Elappully\nPalakkad, Kerala\nIndia - 678622',
                        Icons.location_on,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 80),

                // Contact form
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildTextField('Your Name'),
                      const SizedBox(height: 20),
                      _buildTextField('Your Email'),
                      const SizedBox(height: 20),
                      _buildTextField('Project Type'),
                      const SizedBox(height: 20),
                      _buildTextField('Message', maxLines: 5),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildCTAButton('SEND MESSAGE', true),
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
                fontSize: 12,
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

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF00D9FF).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: TextField(
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
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
        color: const Color(0xFF0A0A0A),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                'YouTube',
                'Instagram',
                'Vimeo',
                'LinkedIn',
              ]
                  .map((social) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            social,
                            style: GoogleFonts.spaceMono(
                              color: Colors.white70,
                              fontSize: 14,
                              letterSpacing: 1,
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

  const FadeInSlide({
    Key? key,
    required this.child,
    this.delay = 0,
  }) : super(key: key);

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
