import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import 'task_form_screen.dart';
import 'task_list_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }

  void _skip(BuildContext context) async {
    await _completeOnboarding(context);
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TaskListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            children: [
              _Page1(),
              _Page2(),
              _Page3(),
              _Page4(onStart: () async {
                final navigator = Navigator.of(context);
                await _completeOnboarding(context);
                if (!context.mounted) return;
                navigator.pushReplacement(
                  MaterialPageRoute(builder: (_) => const TaskListScreen()),
                );
                navigator.push(
                  MaterialPageRoute(builder: (_) => const TaskFormScreen()),
                );
              }),
            ],
          ),
          // スキップボタン
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: TextButton(
              onPressed: () => _skip(context),
              child: Text(l.onboardingSkip, style: const TextStyle(color: Colors.grey)),
            ),
          ),
          // ドットインジケーター
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: _DotIndicator(currentPage: _currentPage, pageCount: 4),
          ),
        ],
      ),
    );
  }
}

// ─── ページ1: TGLメーター ────────────────────────────────────────

class _Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _PageLayout(
      visual: CustomPaint(
        size: const Size(180, 180),
        painter: _GaugePainter(progress: 0.7),
      ),
      headline: l.onboardingPage1Heading,
      body: l.onboardingPage1Body,
    );
  }
}

// ─── ページ2: 入力フォームモック ─────────────────────────────────

class _Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _PageLayout(
      visual: _FormMockVisual(),
      headline: l.onboardingPage2Heading,
      body: l.onboardingPage2Body,
    );
  }
}

// ─── ページ3: 5段階ステータス ─────────────────────────────────────

class _Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _PageLayout(
      visual: _StatusPillsVisual(),
      headline: l.onboardingPage3Heading,
      body: l.onboardingPage3Body,
    );
  }
}

// ─── ページ4: CTA ────────────────────────────────────────────────

class _Page4 extends StatelessWidget {
  const _Page4({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _PageLayout(
      visual: const SizedBox(height: 180),
      headline: l.onboardingPage4Heading,
      body: '',
      action: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(l.onboardingPage4StartButton),
          ),
        ),
      ),
    );
  }
}

// ─── 共通ページレイアウト ────────────────────────────────────────

class _PageLayout extends StatelessWidget {
  const _PageLayout({
    required this.visual,
    required this.headline,
    required this.body,
    this.action,
  });

  final Widget visual;
  final String headline;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.5,
          child: Center(child: visual),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  headline,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    body,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: 32),
                  action!,
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 80), // ドットインジケーター分の余白
      ],
    );
  }
}

// ─── ドットインジケーター ────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.currentPage, required this.pageCount});
  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (i) {
        final active = i == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─── ビジュアル: ゲージ（CustomPaint） ──────────────────────────

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.65);
    final radius = size.width * 0.42;

    // 背景アーク
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14 * 0.85,
      3.14 * 1.3,
      false,
      bgPaint,
    );

    // 進捗アーク
    final fgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFFFF5722)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14 * 0.85,
      3.14 * 1.3 * progress,
      false,
      fgPaint,
    );

    // 中央テキスト
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'TGL',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.progress != progress;
}

// ─── ビジュアル: 追加フォームモック ─────────────────────────────

class _FormMockVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MockField(label: l.onboardingMockTaskName, value: l.onboardingMockTaskValue),
          const SizedBox(height: 10),
          _MockField(label: l.onboardingMockDeadline, value: l.onboardingMockDeadlineValue),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _MockField(label: l.onboardingMockTime, value: l.onboardingMockTimeValue)),
              const SizedBox(width: 8),
              Expanded(child: _MockField(label: l.onboardingMockAvoidance, value: l.onboardingMockAvoidanceValue)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockField extends StatelessWidget {
  const _MockField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

// ─── ビジュアル: 5段階ステータスpill ────────────────────────────

class _StatusPillsVisual extends StatelessWidget {
  static const _colors = [
    (Color(0xFFD4EDDA), Color(0xFF155724)),
    (Color(0xFFFFF3CD), Color(0xFF856404)),
    (Color(0xFFFFE0B2), Color(0xFFE65100)),
    (Color(0xFFFFCDD2), Color(0xFFC62828)),
    (Color(0xFFB71C1C), Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final labels = [
      l.tglStatePeaceful,
      l.tglStateSomeday,
      l.tglStateReality,
      l.tglStateNoEscape,
      l.tglStateWar,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_colors.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: _colors[i].$1,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _colors[i].$2,
              ),
            ),
          ),
        );
      }),
    );
  }
}
