import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/data_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedMonth = DateTime.now();
  Map<DateTime, int> _monthData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMonthData();
  }

  Future<void> _loadMonthData() async {
    setState(() => _isLoading = true);
    final dataService = context.read<DataService>();
    final data = await dataService.getMonthlyData(_selectedMonth.year, _selectedMonth.month);
    setState(() {
      _monthData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildMonthSelector(),
                Expanded(
                  child: _buildCalendarGrid(_monthData),
                ),
              ],
            ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
              });
              _loadMonthData();
            },
          ),
          Text(
            DateFormat('MMMM yyyy', 'es').format(_selectedMonth),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
              });
              _loadMonthData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(Map<DateTime, int> monthData) {
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: daysInMonth + startWeekday - 1,
          itemBuilder: (context, index) {
            if (index < startWeekday - 1) {
              return const SizedBox();
            }
            
            final day = index - startWeekday + 2;
            final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
            final points = monthData[date] ?? 0;
            
            return _buildDayCell(day, points);
          },
        ),
      ),
    );
  }

  Widget _buildDayCell(int day, int points) {
    Color color = Colors.grey.shade200;
    if (points >= 70) {
      color = Colors.green.shade100;
    } else if (points >= 35) {
      color = Colors.yellow.shade100;
    } else if (points > 0) {
      color = Colors.orange.shade100;
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$day',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (points > 0)
            Text(
              '$points pts',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
