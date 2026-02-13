import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alerte {
  static Future<void> show({
    required String title,
    required String message,
    IconData? icon,
    String? imagePath,
    Color color = const Color(0xFF6366F1), // Indigo moderne par défaut
    VoidCallback? onClose,
  }) async {
    final context = Get.context!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await Get.generalDialog(
      barrierDismissible: true,
      barrierLabel: "Alerte",
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.elasticOut);
        
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Effet de flou arrière
          child: ScaleTransition(
            scale: curved,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    
                    /// CORPS DE L'ALERTE
                    Container(
                      width: 280,
                      margin: const EdgeInsets.only(top: 40), // Espace pour l'icône flottante
                      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2A2D3E) : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 30),
                          
                          /// BOUTON STYLISÉ AVEC GRADIENT
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              if (onClose != null) onClose();
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [color, color.withOpacity(0.7)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "CONTINUER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ÉLÉMENT FLOTTANT (ICON OU IMAGE)
                    Positioned(
                      top: 0,
                      child: Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2A2D3E) : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color, color.withOpacity(0.8)],
                              ),
                            ),
                            child: ClipOval(
                              child: imagePath != null
                                  ? Image.asset(imagePath, fit: BoxFit.cover)
                                  : Icon(icon ?? Icons.notifications_none, 
                                         color: Colors.white, size: 40),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}