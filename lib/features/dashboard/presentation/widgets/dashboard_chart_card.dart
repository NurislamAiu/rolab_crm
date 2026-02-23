import 'package:flutter/material.dart';
import 'dashboard_colors.dart';

class DashboardChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isLineChart;
  final List<int> data;

  const DashboardChartCard({super.key, required this.title, required this.subtitle, required this.isLineChart, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: textSecondary)),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              children: [
                // Y Axis
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: isLineChart 
                    ? const [
                        Text('\$140k', style: TextStyle(color: textSecondary, fontSize: 11)),
                        Text('\$105k', style: TextStyle(color: textSecondary, fontSize: 11)),
                        Text('\$70k', style: TextStyle(color: textSecondary, fontSize: 11)),
                        Text('\$35k', style: TextStyle(color: textSecondary, fontSize: 11)),
                        Text('\$0k', style: TextStyle(color: textSecondary, fontSize: 11)),
                      ]
                    : const [
                        Text('100%', style: TextStyle(color: textSecondary, fontSize: 11)),
                        Text('75%', style: TextStyle(color: textSecondary, fontSize: 11)),
                        Text('50%', style: TextStyle(color: textSecondary, fontSize: 11)),
                        Text('25%', style: TextStyle(color: textSecondary, fontSize: 11)),
                        Text('0%', style: TextStyle(color: textSecondary, fontSize: 11)),
                      ],
                ),
                const SizedBox(width: 16),
                // Chart Area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Horizontal grid lines
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(5, (_) => const Divider(height: 1, color: borderColor)),
                            ),
                            // Actual chart
                            Positioned.fill(
                              child: isLineChart 
                                  ? CustomPaint(painter: _LineChartPainter(data))
                                  : Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: data.map((val) {
                                        final double heightPercent = val / 100.0;
                                        return FractionallySizedBox(
                                          heightFactor: heightPercent,
                                          child: Container(
                                            width: 48, // approximate bar width
                                            decoration: const BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // X Axis
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: isLineChart
                          ? const [
                              Text('Jan', style: TextStyle(color: textSecondary, fontSize: 11)),
                              Text('Feb', style: TextStyle(color: textSecondary, fontSize: 11)),
                              Text('Mar', style: TextStyle(color: textSecondary, fontSize: 11)),
                              Text('Apr', style: TextStyle(color: textSecondary, fontSize: 11)),
                              Text('May', style: TextStyle(color: textSecondary, fontSize: 11)),
                              Text('Jun', style: TextStyle(color: textSecondary, fontSize: 11)),
                            ]
                          : const [
                              Text('Mon', style: TextStyle(color: textSecondary, fontSize: 11)),
                              Text('Tue', style: TextStyle(color: textSecondary, fontSize: 11)),
                              Text('Wed', style: TextStyle(color: textSecondary, fontSize: 11)),
                              Text('Thu', style: TextStyle(color: textSecondary, fontSize: 11)),
                              Text('Fri', style: TextStyle(color: textSecondary, fontSize: 11)),
                            ],
                      ),
                    ],
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

class _LineChartPainter extends CustomPainter {
  final List<int> data;
  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    
    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
      
    final maxVal = 140.0;
    final minVal = 0.0;
    final range = maxVal - minVal;
    
    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - (((data[i] - minVal) / range) * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
    
    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    final dotStrokePaint = Paint()
      ..color = cardColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - (((data[i] - minVal) / range) * size.height);
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
      canvas.drawCircle(Offset(x, y), 4, dotStrokePaint);
      canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}