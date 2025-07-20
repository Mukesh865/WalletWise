import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyChart extends StatefulWidget {
  const MyChart({super.key});

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(mainBarChart());
  }

  BarChartData mainBarChart() {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTile,
            reservedSize: 38,
          ),
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
    );
  }

  Future<Widget>getTile(double value, TitleMeta meta) async {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('01', style: style);
        break;
      case 1:
        text = const Text('02', style: style);
        break;
        case 2:
        text = const Text('03', style: style);
        break;
        case 3:
        text = const Text('04', style: style);
        break;
        case 4:
        text = const Text('05', style: style);
        break;
        case 5:
        text = const Text('06', style: style);
        break;
        case 6:
        text = const Text('07', style: style);
        break;
        case 7:
        text = const Text('08', style: style);
        break;
        default:
          text = const Text('', style: style);
          break;
  }
}
