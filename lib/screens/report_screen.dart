// it will be add later, this is just to demonstrate the report section

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ReportSection extends StatefulWidget {
  const ReportSection({super.key});

  @override
  State createState() => _ReportSectionState();
}


class _ReportSectionState extends State<ReportSection> {

  String selectedPeriod = 'Monthly';


  final String doctorName = "Dr. Helin";
  final String specialty = "Dermatologist";


  final Map<String, int> patientsByMonth = {
    'Jan': 42,
    'Feb': 51,
    'Mar': 63,
    'Apr': 58,
    'May': 72,
    'Jun': 68,
    'Jul': 75,
    'Aug': 82,
    'Sep': 65,
    'Oct': 70,
    'Nov': 45,
    'Dec': 52,
  };

  final Map<String, int> treatmentTypes = {
    'Skin Exam': 187,
    'Acne Treatment': 94,
    'Psoriasis Treatment': 58,
    'Mole Removal': 42,
    'Botox': 73,
    'Eczema Treatment': 112,
  };

  final Map<String, double> revenueByMonth = {
    'Jan': 15200,
    'Feb': 18500,
    'Mar': 22400,
    'Apr': 20100,
    'May': 26300,
    'Jun': 24800,
    'Jul': 27500,
    'Aug': 30100,
    'Sep': 23800,
    'Oct': 25500,
    'Nov': 16400,
    'Dec': 19000,
  };

  @override
  Widget build(BuildContext context) {
  
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 1200;

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isSmallScreen),
            const SizedBox(height: 24),
            _buildDoctorInfo(isSmallScreen),
            const SizedBox(height: 24),
            _buildPeriodSelector(isSmallScreen),
            const SizedBox(height: 24),
            _buildSummaryCards(isSmallScreen, isMediumScreen),
            const SizedBox(height: 24),
            _buildPatientTrends(),
            const SizedBox(height: 24),
            if (isSmallScreen)
              Column(
                children: [
                  _buildTreatmentDistribution(),
                  const SizedBox(height: 16),
                  _buildRevenueChart(),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTreatmentDistribution()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRevenueChart()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return isSmallScreen
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dermatology Practice Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dermatology Practice Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
  }

  Widget _buildDoctorInfo(bool isSmallScreen) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isSmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Practice Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              specialty,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  const Text(
                    'Practice Information:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 24),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    doctorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '($specialty)',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
      ),
    );
  }

  Widget _buildPeriodSelector(bool isSmallScreen) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isSmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filter by period:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedPeriod,
                    items: ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedPeriod = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Date range:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Jan 1, 2025 - Dec 31, 2025'),
                  ),
                ],
              )
            : Row(
                children: [
                  const Text('Filter by period:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: selectedPeriod,
                    items: ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedPeriod = newValue!;
                      });
                    },
                  ),
                  const SizedBox(width: 24),
                  const Text('Date range:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Jan 1, 2025 - Dec 31, 2025'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSummaryCards(bool isSmallScreen, bool isMediumScreen) {
    final totalPatients = patientsByMonth.values.reduce((a, b) => a + b);
    final totalRevenue = revenueByMonth.values.reduce((a, b) => a + b);
    final avgPatientsPerMonth = totalPatients / patientsByMonth.length;

   
    final cards = [
      _buildSummaryCard(
        title: 'Total Patients',
        value: totalPatients.toString(),
        icon: Icons.people,
        color: Colors.blue,
        change: '+12.5%',
      ),
      _buildSummaryCard(
        title: 'New Patients',
        value: patientsByMonth['Oct'].toString(),
        icon: Icons.person_add,
        color: Colors.green,
        change: '+5.2%',
      ),
      _buildSummaryCard(
        title: 'Total Revenue',
        value: '\$${NumberFormat("#,###").format(totalRevenue.toInt())}',
        icon: Icons.attach_money,
        color: Colors.amber,
        change: '+8.7%',
      ),
      _buildSummaryCard(
        title: 'Avg. Patients/Month',
        value: avgPatientsPerMonth.toStringAsFixed(1),
        icon: Icons.insert_chart,
        color: Colors.purple,
        change: '+3.1%',
      ),
    ];

    
    if (isSmallScreen) {
      return Column(
        children: cards
            .map((card) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: card,
                ))
            .toList(),
      );
    } else if (isMediumScreen) {
      return Column(
        children: [
          Row(children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 8),
            Expanded(child: cards[1])
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: cards[2]),
            const SizedBox(width: 8),
            Expanded(child: cards[3])
          ]),
        ],
      );
    } else {
      return Row(
        children: cards
            .map((card) => Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: card,
                )))
            .toList(),
      );
    }
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String change,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                Icon(
                  icon,
                  color: color,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.arrow_upward,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(' from last period'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientTrends() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 1,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final months = patientsByMonth.keys.toList();
                          if (value.toInt() >= 0 &&
                              value.toInt() < months.length) {
                            return SideTitleWidget(
                              meta: meta,
                              space: 8.0,
                              child: Text(months[value.toInt()]),
                            );
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(''),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8.0,
                            child: Text(value.toInt().toString()),
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  minX: 0,
                  maxX: patientsByMonth.length - 1.0,
                  minY: 0,
                  maxY:
                      (patientsByMonth.values.reduce((a, b) => a > b ? a : b) *
                              1.2)
                          .roundToDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: patientsByMonth.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(entry.key.toDouble(),
                              entry.value.value.toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentDistribution() {
    final totalTreatments = treatmentTypes.values.reduce((a, b) => a + b);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Treatment Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: treatmentTypes.entries.map((entry) {
                    final index =
                        treatmentTypes.keys.toList().indexOf(entry.key);
                    final color =
                        Colors.primaries[index % Colors.primaries.length];
                    final percent = entry.value / totalTreatments;

                    return PieChartSectionData(
                      color: color,
                      value: entry.value.toDouble(),
                      title: '${(percent * 100).toStringAsFixed(1)}%',
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: treatmentTypes.entries.map((entry) {
                final percent =
                    (entry.value / totalTreatments * 100).toStringAsFixed(1);
                final index = treatmentTypes.keys.toList().indexOf(entry.key);
                final color = Colors.primaries[index % Colors.primaries.length];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.key,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('${entry.value} ($percent%)'),
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

  Widget _buildRevenueChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (revenueByMonth.values.reduce((a, b) => a > b ? a : b) *
                          1.2)
                      .roundToDouble(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final month = revenueByMonth.keys.toList()[groupIndex];
                        final value =
                            revenueByMonth.values.toList()[groupIndex];
                        return BarTooltipItem(
                          '$month: \$${NumberFormat("#,###").format(value.toInt())}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final months = revenueByMonth.keys.toList();
                          if (value.toInt() >= 0 &&
                              value.toInt() < months.length) {
                            return SideTitleWidget(
                              meta: meta,
                              space: 8.0,
                              child: Text(
                                months[value.toInt()],
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(''),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: 5000,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8.0,
                            child: Text(
                              '\$${NumberFormat("#,###").format(value.toInt())}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5000,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  barGroups: revenueByMonth.entries.map((entry) {
                    final index =
                        revenueByMonth.keys.toList().indexOf(entry.key);
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: Colors.blue,
                          width: 16,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'Actual'),
                const SizedBox(width: 24),
                _buildLegendItem(Colors.grey.shade300, 'Projected'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _buildPatientTable() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Patients',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All Patients'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Patient ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Visit Date')),
                  DataColumn(label: Text('Treatment')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [
                  _buildPatientRow('P-1001', 'John Smith', 'Mar 15, 2025',
                      'Skin Exam', 'Completed'),
                  _buildPatientRow('P-1002', 'Maria Garcia', 'Mar 14, 2025',
                      'Acne Treatment', 'In Progress'),
                  _buildPatientRow('P-1003', 'Robert Johnson', 'Mar 12, 2025',
                      'Botox', 'Completed'),
                  _buildPatientRow('P-1004', 'Emily Wilson', 'Mar 10, 2025',
                      'Psoriasis Treatment', 'Scheduled'),
                  _buildPatientRow('P-1005', 'David Brown', 'Mar 8, 2025',
                      'Mole Removal', 'Completed'),
                ],
              ),
            ),
            
            MediaQuery.of(context).size.width < 600
                ? const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        'Swipe horizontally to view complete patient data',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  DataRow _buildPatientRow(
      String id, String name, String date, String treatment, String status) {
    Color statusColor;
    if (status == 'Completed') {
      statusColor = Colors.green;
    } else if (status == 'In Progress') {
      statusColor = Colors.blue;
    } else {
      statusColor = Colors.orange;
    }

    return DataRow(
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(date)),
        DataCell(Text(treatment)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, color: Colors.blue),
                onPressed: () {},
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.amber),
                onPressed: () {},
                tooltip: 'Edit Patient',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
