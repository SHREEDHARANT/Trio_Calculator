import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MultiToolApp());
}

class MultiToolApp extends StatelessWidget {
  const MultiToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Student Suite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📘 Smart Student Suite"),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: DottedBackgroundPainter(0),
            child: Container(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select an Option",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 40),
                  _buildButton(
                    color: Colors.deepPurple,
                    icon: Icons.cake,
                    label: "🎂 Age Calculator",
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AgeCalculatorPage())),
                  ),
                  const SizedBox(height: 20),
                  _buildButton(
                    color: Colors.green,
                    icon: Icons.calculate,
                    label: "📚 Marks Calculator",
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MarksCalculatorPage())),
                  ),
                  const SizedBox(height: 20),
                  _buildButton(
                    color: Colors.orange,
                    icon: Icons.school,
                    label: "🎓 CGPA Calculator",
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CgpaCalculatorPage())),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}

class AgeCalculatorPage extends StatefulWidget {
  const AgeCalculatorPage({super.key});

  @override
  State<AgeCalculatorPage> createState() => _AgeCalculatorPageState();
}

class _AgeCalculatorPageState extends State<AgeCalculatorPage>
    with SingleTickerProviderStateMixin {
  DateTime? dob;
  int? years, months, days;

  void _selectDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dob = picked;
        _calculateAgeDetails(picked);
      });
    }
  }

  void _calculateAgeDetails(DateTime birthDate) {
    final now = DateTime.now();
    int year = now.year - birthDate.year;
    int month = now.month - birthDate.month;
    int day = now.day - birthDate.day;
    if (day < 0) {
      final prevMonth = DateTime(now.year, now.month, 0);
      day += prevMonth.day;
      month--;
    }
    if (month < 0) {
      month += 12;
      year--;
    }
    years = year;
    months = month;
    days = day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎂 Age Calculator"),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          elevation: 12,
          margin: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Your Date of Birth",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _selectDOB,
                  child: Text(dob == null
                      ? "Choose DOB"
                      : DateFormat('dd-MM-yyyy').format(dob!)),
                ),
                const SizedBox(height: 25),
                if (years != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "🎉 You are $years years, $months months, and $days days old!",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MarksCalculatorPage extends StatefulWidget {
  const MarksCalculatorPage({super.key});

  @override
  State<MarksCalculatorPage> createState() => _MarksCalculatorPageState();
}

class _MarksCalculatorPageState extends State<MarksCalculatorPage> {
  int subjectCount = 0;
  List<TextEditingController> controllers = [];
  double? total, average, percentage;

  void _generateFields() {
    controllers = List.generate(subjectCount, (_) => TextEditingController());
  }

  void _calculateMarks() {
    double sum = 0;
    for (var c in controllers) {
      sum += double.tryParse(c.text) ?? 0;
    }
    setState(() {
      total = sum;
      average = sum / subjectCount;
      percentage = (sum / (subjectCount * 100)) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📚 Marks Calculator"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Enter Subject Marks",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Enter number of subjects",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final count = int.tryParse(value) ?? 0;
                    setState(() {
                      subjectCount = count;
                      _generateFields();
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (subjectCount > 0)
                  Column(
                    children: List.generate(subjectCount, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: TextField(
                          controller: controllers[index],
                          decoration: InputDecoration(
                            labelText: "Subject ${index + 1} Marks",
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      );
                    }),
                  ),
                if (subjectCount > 0) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    onPressed: _calculateMarks,
                    child: const Text("Calculate"),
                  ),
                  const SizedBox(height: 20),
                ],
                if (total != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Text("Total Marks: ${total!.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Average Marks: ${average!.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16)),
                        Text("Percentage: ${percentage!.toStringAsFixed(2)}%",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CgpaCalculatorPage extends StatefulWidget {
  const CgpaCalculatorPage({super.key});

  @override
  State<CgpaCalculatorPage> createState() => _CgpaCalculatorPageState();
}

class _CgpaCalculatorPageState extends State<CgpaCalculatorPage> {
  int subjectCount = 0;
  List<TextEditingController> creditControllers = [];
  List<TextEditingController> gradeControllers = [];
  double? cgpa;

  void _generateFields() {
    creditControllers =
        List.generate(subjectCount, (_) => TextEditingController());
    gradeControllers =
        List.generate(subjectCount, (_) => TextEditingController());
  }

  void _calculateCgpa() {
    double totalCredits = 0;
    double weightedSum = 0;
    for (int i = 0; i < subjectCount; i++) {
      double credit = double.tryParse(creditControllers[i].text) ?? 0;
      double grade = double.tryParse(gradeControllers[i].text) ?? 0;
      weightedSum += credit * grade;
      totalCredits += credit;
    }
    setState(() {
      cgpa = totalCredits > 0 ? weightedSum / totalCredits : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎓 CGPA Calculator"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Enter Credits & Grades",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Enter number of subjects",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final count = int.tryParse(value) ?? 0;
                    setState(() {
                      subjectCount = count;
                      _generateFields();
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (subjectCount > 0)
                  Column(
                    children: List.generate(subjectCount, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: creditControllers[index],
                                decoration: InputDecoration(
                                  labelText: "Subject ${index + 1} Credits",
                                  border: const OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: gradeControllers[index],
                                decoration: const InputDecoration(
                                  labelText: "Grade Point (0–10)",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                if (subjectCount > 0) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    onPressed: _calculateCgpa,
                    child: const Text("Calculate CGPA"),
                  ),
                  const SizedBox(height: 20),
                ],
                if (cgpa != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "🎯 Your CGPA is: ${cgpa!.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DottedBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Random random = Random();
  DottedBackgroundPainter(this.animationValue);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.25);
    for (int i = 0; i < 90; i++) {
      final dx =
          (size.width * (i / 90) + sin(animationValue * 2 * pi + i) * 40) %
              size.width;
      final dy = (size.height * (i / 90) +
              cos(animationValue * 2 * pi + i) * 40 +
              i * 5) %
          size.height;
      canvas.drawCircle(Offset(dx, dy), random.nextDouble() * 3 + 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DottedBackgroundPainter oldDelegate) => true;
}
