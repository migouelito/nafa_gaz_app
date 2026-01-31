import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notifications_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00A86B);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: controller.markAllAsRead,
            child: const Text("Tout marquer comme lu", style: TextStyle(color: primaryColor))
          )
        ],
      ),
      body: Obx(() => ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: controller.notifications.length,
        itemBuilder: (context, index) {
          final item = controller.notifications[index];
          return _buildNotifItem(item, primaryColor);
        },
      )),
    );
  }

  Widget _buildNotifItem(Map<String, dynamic> item, Color primaryColor) {
    final bool isRead = item['isRead'];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isRead ? Colors.grey.shade200 : primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: (item['color'] as Color).withOpacity(0.1),
            child: Icon(item['icon'], color: item['color'], size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isRead ? Colors.black : primaryColor)),
                    Text(item['time'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(item['body'], style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          )
        ],
      ),
    );
  }
}