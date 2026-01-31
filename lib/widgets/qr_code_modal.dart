import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeModal extends StatelessWidget {
  const QrCodeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(width: 50, height: 5, color: Colors.grey.shade300),
          const SizedBox(height: 30),
          const Text("Code de Réception", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("À montrer au livreur uniquement", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          QrImageView(
            data: 'NAFA-GAZ-LIVRAISON-SECURE-123',
            version: QrVersions.auto,
            size: 200.0,
            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF00A86B)),
          ),
          const SizedBox(height: 20),
          const Text("Code secours: 88 42", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 5)),
        ],
      ),
    );
  }
}
