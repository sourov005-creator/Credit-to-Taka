import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const CreditToTakaApp());
}

class CreditToTakaApp extends StatelessWidget {
  const CreditToTakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit to Taka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07090E),
        textTheme: GoogleFonts.orbitronTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const UltraGameScreen(),
    );
  }
}

class PlayerCard {
  final String name;
  final String title;
  final String rating;
  final String club;
  final List<Color> gradient;
  final Color neonGlow;
  final IconData badgeIcon;

  PlayerCard({
    required this.name,
    required this.title,
    required this.rating,
    required this.club,
    required this.gradient,
    required this.neonGlow,
    required this.badgeIcon,
  });
}

class UltraGameScreen extends StatefulWidget {
  const UltraGameScreen({super.key});

  @override
  State<UltraGameScreen> createState() => _UltraGameScreenState();
}

class _UltraGameScreenState extends State<UltraGameScreen>
    with TickerProviderStateMixin {
  int _tapCount = 0;
  double _takaBalance = 0.0;
  int _selectedCardIndex = 0;
  int _multiplier = 1;

  late AnimationController _tapScaleController;

  final Set<int> _claimedMilestones = {};

  final List<PlayerCard> _playerCards = [
    PlayerCard(
      name: "L. MESSI",
      title: "BALLON D'OR KING",
      rating: "99",
      club: "INTER MIAMI",
      gradient: [
        const Color(0xFF00F2FE),
        const Color(0xFF4FACFE),
        const Color(0xFF0F172A),
      ],
      neonGlow: const Color(0xFF00F2FE),
      badgeIcon: Icons.auto_awesome,
    ),
    PlayerCard(
      name: "C. RONALDO",
      title: "EL COMANDANTE",
      rating: "99",
      club: "AL NASSR",
      gradient: [
        const Color(0xFFFF0844),
        const Color(0xFFFFB199),
        const Color(0xFF1E1014),
      ],
      neonGlow: const Color(0xFFFF0844),
      badgeIcon: Icons.bolt,
    ),
    PlayerCard(
      name: "K. MBAPPÉ",
      title: "TURBO BEAST",
      rating: "97",
      club: "REAL MADRID",
      gradient: [
        const Color(0xFFB92B27),
        const Color(0xFF1565C0),
        const Color(0xFF0B1021),
      ],
      neonGlow: const Color(0xFF1565C0),
      badgeIcon: Icons.electric_bolt_rounded,
    ),
    PlayerCard(
      name: "NEYMAR JR",
      title: "MAGIC SAMBA",
      rating: "95",
      club: "AL HILAL",
      gradient: [
        const Color(0xFFF7971E),
        const Color(0xFFFFD200),
        const Color(0xFF1A1500),
      ],
      neonGlow: const Color(0xFFFFD200),
      badgeIcon: Icons.flare_rounded,
    ),
    PlayerCard(
      name: "E. HAALAND",
      title: "CYBORG STRIKER",
      rating: "96",
      club: "MAN CITY",
      gradient: [
        const Color(0xFF00F5D4),
        const Color(0xFF7B2CBF),
        const Color(0xFF0C1919),
      ],
      neonGlow: const Color(0xFF00F5D4),
      badgeIcon: Icons.offline_bolt_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _tapScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.92,
      upperBound: 1.0,
    );

    _tapScaleController.value = 1.0;
  }

  @override
  void dispose() {
    _tapScaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_tapCount > 0 && _tapCount % 50 == 0) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    _tapScaleController.reverse().then((_) {
      if (mounted) {
        _tapScaleController.forward();
      }
    });

    setState(() {
      _tapCount++;
      _takaBalance += 0.10 * _multiplier;

      if (_tapCount >= 500) {
        _multiplier = 5;
      } else if (_tapCount >= 100) {
        _multiplier = 3;
      } else if (_tapCount >= 50) {
        _multiplier = 2;
      }
    });

    const milestones = [10, 50, 100, 500, 1000];

    if (milestones.contains(_tapCount) &&
        !_claimedMilestones.contains(_tapCount)) {
      _showMilestoneDialog(_tapCount);
    }
  }
    void _showMilestoneDialog(int milestone) {
    _claimedMilestones.add(milestone);

    HapticFeedback.vibrate();
    SystemSound.play(SystemSoundType.click);

    final activeCard = _playerCards[_selectedCardIndex];
    final bonus = milestone * 0.25;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Milestone",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0E131F),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: activeCard.neonGlow,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: activeCard.neonGlow.withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    size: 70,
                    color: activeCard.neonGlow,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "মাইলস্টোন অর্জিত!",
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "$milestone TAPS!",
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "বোনাস: +৳${bonus.toStringAsFixed(1)} এবং x$_multiplier বুস্ট!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeCard.neonGlow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _takaBalance += bonus;
                      });

                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      "পুরস্কার গ্রহণ করুন",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCard = _playerCards[_selectedCardIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CREDIT TO TAKA",
                        style: GoogleFonts.orbitron(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "SEASON 1 • FUT ED.",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.4),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111726),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: activeCard.neonGlow.withOpacity(0.2),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.currency_exchange_rounded,
                          color: activeCard.neonGlow,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "৳ ${_takaBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _playerCards.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCardIndex == index;
                  final card = _playerCards[index];

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();

                      setState(() {
                        _selectedCardIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? card.neonGlow.withOpacity(0.18)
                            : const Color(0xFF111622),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? card.neonGlow
                              : Colors.white.withOpacity(0.08),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            card.badgeIcon,
                            size: 16,
                            color: isSelected
                                ? card.neonGlow
                                : Colors.white54,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            card.name.split(" ").last,
                            style: GoogleFonts.orbitron(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            Column(
              children: [
                Text(
                  "$_tapCount",
                  style: GoogleFonts.orbitron(
                    fontSize: 75,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: activeCard.neonGlow.withOpacity(0.8),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: activeCard.neonGlow.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: activeCard.neonGlow.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    "BOOST SPEED: x$_multiplier",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: activeCard.neonGlow,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
                        GestureDetector(
              onTap: _handleTap,
              child: ScaleTransition(
                scale: _tapScaleController,
                child: Container(
                  width: 270,
                  height: 390,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: activeCard.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: activeCard.neonGlow.withOpacity(0.45),
                        blurRadius: 45,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Icon(
                          activeCard.badgeIcon,
                          size: 190,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activeCard.rating,
                                      style: GoogleFonts.orbitron(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.0,
                                      ),
                                    ),
                                    Text(
                                      "OVR",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white12,
                                    ),
                                  ),
                                  child: Text(
                                    activeCard.club,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            Center(
                              child: Container(
                                width: 95,
                                height: 95,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.35),
                                  border: Border.all(
                                    color: activeCard.neonGlow
                                        .withOpacity(0.6),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: activeCard.neonGlow
                                          .withOpacity(0.4),
                                      blurRadius: 25,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  activeCard.badgeIcon,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const Spacer(),

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeCard.title,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.6),
                                    letterSpacing: 2,
                                  ),
                                ),

                                Text(
                                  activeCard.name,
                                  style: GoogleFonts.orbitron(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.45),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "TOUCH TO STRIKE",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white70,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "TAP THE CARD TO EARN TAKA",
              style: TextStyle(
                fontSize: 9,
                color: Colors.white.withOpacity(0.35),
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
            
