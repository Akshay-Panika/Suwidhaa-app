import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homework_controller.dart';
import '../screen/teacher_home_work_screen.dart';

class TeacherHomeWork extends StatelessWidget {
  const TeacherHomeWork({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeworkController>();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TeacherHomeworkScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blue.shade100,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade700],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Homework Management',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Obx(() {
                        final pending = controller.homeworkList
                            .where((hw) => hw.getStatus() == 'Pending')
                            .length;
                        final total = controller.homeworkList.length;
                        return Text(
                          total > 0
                              ? '$pending Pending Out Of $total'
                              : 'No assignments yet',
                          style: TextStyle(
                            fontSize: 13,
                            color: pending > 0 ? Colors.red : Colors.grey.shade600,
                            fontWeight: pending > 0 ? FontWeight.w600 : FontWeight.normal,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}