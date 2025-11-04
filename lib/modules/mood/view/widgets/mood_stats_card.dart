import 'package:flutter/material.dart';

class MoodStatsCard extends StatelessWidget {
  final int Function(String) getMoodCount;

  const MoodStatsCard({Key? key, required this.getMoodCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.1),
              Colors.blue.withOpacity(0.1),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMoodStat('😊', 'Happy', getMoodCount('happy')),
            _buildMoodStat('😐', 'Neutral', getMoodCount('neutral')),
            _buildMoodStat('😢', 'Sad', getMoodCount('sad')),
            _buildMoodStat('🤩', 'Excited', getMoodCount('excited')),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodStat(String emoji, String label, int count) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 28)),
        SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
