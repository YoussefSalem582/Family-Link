import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/mood_viewmodel.dart';

class MoodView extends GetView<MoodViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Family Moods')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: Colors.orange.shade100,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade900),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Demo Mode - Showing sample mood data',
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    ),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text(
                    'How is everyone feeling?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),

                  // Family Moods
                  if (controller.todaysMoods.isNotEmpty) ...[
                    ...controller.todaysMoods.map(
                      (mood) => Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Text(
                            mood.emoji,
                            style: TextStyle(fontSize: 32),
                          ),
                          title: Text(mood.userName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mood.mood.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (mood.note != null && mood.note!.isNotEmpty)
                                Text(
                                  mood.note!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                          trailing: Text(
                            '${mood.date.hour}:${mood.date.minute.toString().padLeft(2, '0')}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No moods shared today'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
