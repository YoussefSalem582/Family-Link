void main() {
  final nov1 = DateTime(2025, 11, 1);
  final nov2 = DateTime(2025, 11, 2);
  final nov8 = DateTime(2025, 11, 8);

  print('Nov 1, 2025: weekday=${nov1.weekday} (1=Mon, 6=Sat, 7=Sun)');
  print('Nov 2, 2025: weekday=${nov2.weekday}');
  print('Nov 8, 2025: weekday=${nov8.weekday}');
}
