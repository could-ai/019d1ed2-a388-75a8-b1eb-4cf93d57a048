import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const TradingSignalApp());
}

class TradingSignalApp extends StatelessWidget {
  const TradingSignalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMC/ICT Market Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0E14),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF151A22),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        cardColor: const Color(0xFF151A22),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2962FF),
          secondary: Color(0xFF00E676),
          surface: Color(0xFF151A22),
          error: Color(0xFFFF1744),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

// --- MODELS ---

enum SignalType { buy, sell, neutral }

class MarketAnalysis {
  final String smcStructure;
  final String smcOrderBlock;
  final String smcLiquidity;
  final String ictKillzone;
  final String ictSetup;
  final String priceActionTrend;
  final String priceActionKeyLevel;

  MarketAnalysis({
    required this.smcStructure,
    required this.smcOrderBlock,
    required this.smcLiquidity,
    required this.ictKillzone,
    required this.ictSetup,
    required this.priceActionTrend,
    required this.priceActionKeyLevel,
  });
}

class MarketPair {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final SignalType signal;
  final String timeframe;
  final MarketAnalysis analysis;

  MarketPair({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.signal,
    required this.timeframe,
    required this.analysis,
  });
}

// --- MOCK DATA ---

final List<MarketPair> mockPairs = [
  MarketPair(
    symbol: 'XAUUSD',
    name: 'Gold / US Dollar',
    price: 2345.60,
    change: 1.24,
    signal: SignalType.buy,
    timeframe: '15m / 1H',
    analysis: MarketAnalysis(
      smcStructure: 'Bullish CHoCH on 15m, mitigating 1H demand.',
      smcOrderBlock: 'Tapped into unmitigated bullish OB at 2338.50.',
      smcLiquidity: 'Sell-side liquidity swept below Asian session lows.',
      ictKillzone: 'London Open Killzone',
      ictSetup: 'Silver Bullet setup forming, FVG filled at 2342.00.',
      priceActionTrend: 'Strong uptrend on higher timeframes.',
      priceActionKeyLevel: 'Bounced off major support at 2340.00.',
    ),
  ),
  MarketPair(
    symbol: 'EURUSD',
    name: 'Euro / US Dollar',
    price: 1.0845,
    change: -0.45,
    signal: SignalType.sell,
    timeframe: '5m / 15m',
    analysis: MarketAnalysis(
      smcStructure: 'Bearish BOS on 5m after sweeping buy-side liquidity.',
      smcOrderBlock: 'Rejected from 15m bearish OB at 1.0870.',
      smcLiquidity: 'Equal highs (EQH) swept during Frankfurt open.',
      ictKillzone: 'NY AM Session',
      ictSetup: 'Judas Swing completed, targeting sell-side liquidity.',
      priceActionTrend: 'Bearish continuation pattern.',
      priceActionKeyLevel: 'Broke below minor support at 1.0850.',
    ),
  ),
  MarketPair(
    symbol: 'GBPJPY',
    name: 'British Pound / Japanese Yen',
    price: 192.30,
    change: 0.85,
    signal: SignalType.buy,
    timeframe: '1H / 4H',
    analysis: MarketAnalysis(
      smcStructure: 'Bullish order flow maintained. Higher highs forming.',
      smcOrderBlock: 'Reacting to 4H demand zone.',
      smcLiquidity: 'Internal liquidity swept before expansion.',
      ictKillzone: 'Asian Session',
      ictSetup: 'Consolidation profile, preparing for London expansion.',
      priceActionTrend: 'Aggressive bullish momentum.',
      priceActionKeyLevel: 'Testing resistance at 192.50, likely to break.',
    ),
  ),
  MarketPair(
    symbol: 'BTCUSD',
    name: 'Bitcoin / US Dollar',
    price: 64230.00,
    change: -2.10,
    signal: SignalType.neutral,
    timeframe: '4H / Daily',
    analysis: MarketAnalysis(
      smcStructure: 'Ranging between 4H supply and demand.',
      smcOrderBlock: 'Currently in premium array, waiting for displacement.',
      smcLiquidity: 'Building liquidity on both sides (EQH/EQL).',
      ictKillzone: 'Out of Killzone',
      ictSetup: 'No clear setup. Waiting for NY PM session.',
      priceActionTrend: 'Consolidation / Choppy.',
      priceActionKeyLevel: 'Stuck between 63k support and 65k resistance.',
    ),
  ),
];

// --- SCREENS ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QUANTUM SIGNALS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMarketOverview(context),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Active Signals (SMC & ICT)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: mockPairs.length,
              itemBuilder: (context, index) {
                final pair = mockPairs[index];
                return _buildPairCard(context, pair);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF151A22),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2A2E39), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOverviewStat('Win Rate', '84%', Colors.greenAccent),
          _buildOverviewStat('Active Setups', '3', Colors.blueAccent),
          _buildOverviewStat('Market Bias', 'Bullish', Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  Widget _buildPairCard(BuildContext context, MarketPair pair) {
    Color signalColor;
    String signalText;
    IconData signalIcon;

    switch (pair.signal) {
      case SignalType.buy:
        signalColor = const Color(0xFF00E676);
        signalText = 'BUY';
        signalIcon = Icons.arrow_upward_rounded;
        break;
      case SignalType.sell:
        signalColor = const Color(0xFFFF1744);
        signalText = 'SELL';
        signalIcon = Icons.arrow_downward_rounded;
        break;
      case SignalType.neutral:
        signalColor = Colors.grey;
        signalText = 'HOLD';
        signalIcon = Icons.remove_rounded;
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignalDetailScreen(pair: pair),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF151A22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2E39)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Symbol and Name
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pair.symbol,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pair.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            // Price and Change
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pair.price.toStringAsFixed(pair.symbol.contains('JPY') ? 2 : 4),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pair.change > 0 ? '+' : ''}${pair.change}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: pair.change > 0 ? const Color(0xFF00E676) : const Color(0xFFFF1744),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Signal Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: signalColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: signalColor.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(signalIcon, color: signalColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    signalText,
                    style: TextStyle(
                      color: signalColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignalDetailScreen extends StatelessWidget {
  final MarketPair pair;

  const SignalDetailScreen({super.key, required this.pair});

  @override
  Widget build(BuildContext context) {
    Color signalColor;
    switch (pair.signal) {
      case SignalType.buy:
        signalColor = const Color(0xFF00E676);
        break;
      case SignalType.sell:
        signalColor = const Color(0xFFFF1744);
        break;
      case SignalType.neutral:
        signalColor = Colors.grey;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${pair.symbol} Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(signalColor),
            _buildMockChart(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Smart Money Concepts (SMC)'),
                  _buildAnalysisCard(
                    icon: Icons.account_tree_outlined,
                    title: 'Market Structure',
                    content: pair.analysis.smcStructure,
                    color: Colors.blueAccent,
                  ),
                  _buildAnalysisCard(
                    icon: Icons.view_in_ar_outlined,
                    title: 'Order Blocks & FVG',
                    content: pair.analysis.smcOrderBlock,
                    color: Colors.purpleAccent,
                  ),
                  _buildAnalysisCard(
                    icon: Icons.water_drop_outlined,
                    title: 'Liquidity',
                    content: pair.analysis.smcLiquidity,
                    color: Colors.cyanAccent,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Inner Circle Trader (ICT)'),
                  _buildAnalysisCard(
                    icon: Icons.access_time,
                    title: 'Killzones & Time',
                    content: pair.analysis.ictKillzone,
                    color: Colors.orangeAccent,
                  ),
                  _buildAnalysisCard(
                    icon: Icons.track_changes_outlined,
                    title: 'ICT Setup',
                    content: pair.analysis.ictSetup,
                    color: Colors.deepOrangeAccent,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Price Action'),
                  _buildAnalysisCard(
                    icon: Icons.trending_up,
                    title: 'Overall Trend',
                    content: pair.analysis.priceActionTrend,
                    color: Colors.greenAccent,
                  ),
                  _buildAnalysisCard(
                    icon: Icons.horizontal_rule,
                    title: 'Key Levels',
                    content: pair.analysis.priceActionKeyLevel,
                    color: Colors.yellowAccent,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color signalColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF151A22),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF2A2E39), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pair.symbol,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Timeframe: ${pair.timeframe}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pair.price.toStringAsFixed(pair.symbol.contains('JPY') ? 2 : 4),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: signalColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pair.signal.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMockChart() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2E39)),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, 200),
            painter: MockChartPainter(
              isBullish: pair.signal == SignalType.buy || pair.signal == SignalType.neutral,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Live Chart (Mock)',
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAnalysisCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151A22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2E39)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// A simple custom painter to draw a mock candlestick/line chart
class MockChartPainter extends CustomPainter {
  final bool isBullish;

  MockChartPainter({required this.isBullish});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final random = Random(42); // Fixed seed for consistent mock look

    double currentY = isBullish ? size.height * 0.8 : size.height * 0.2;
    double stepX = size.width / 30;

    path.moveTo(0, currentY);

    for (int i = 1; i <= 30; i++) {
      double change = (random.nextDouble() - 0.5) * 30;
      
      // Add trend bias
      if (isBullish) {
        change -= 2; // Trend up (lower Y)
      } else {
        change += 2; // Trend down (higher Y)
      }

      currentY += change;
      
      // Keep within bounds
      currentY = currentY.clamp(20.0, size.height - 20.0);

      path.lineTo(i * stepX, currentY);
    }

    // Draw gradient under line
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        (isBullish ? const Color(0xFF00E676) : const Color(0xFFFF1744)).withOpacity(0.3),
        Colors.transparent,
      ],
    );

    canvas.drawPath(
      fillPath,
      Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Draw line
    paint.color = isBullish ? const Color(0xFF00E676) : const Color(0xFFFF1744);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
