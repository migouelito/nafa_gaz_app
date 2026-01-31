import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/qr_code_modal.dart';
import 'chat_screen.dart';
import 'in_app_call_screen.dart'; // Import de l'écran d'appel

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  LatLng driverPos = const LatLng(12.3582, -1.5200); 
  final LatLng clientPos = const LatLng(12.3650, -1.5250); 
  
  // True = Commande validée et non livrée
  bool isInDelivery = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. LA CARTE
          FlutterMap(
            options: MapOptions(initialCenter: driverPos, initialZoom: 14.5),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.nafagaz.app'),
              MarkerLayer(markers: [
                Marker(point: driverPos, width: 50, height: 50, child: const Icon(Icons.delivery_dining, color: Color(0xFF00A86B), size: 40)),
                Marker(point: clientPos, width: 50, height: 50, child: const Icon(Icons.location_pin, color: Color(0xFFFF5722), size: 50)),
              ]),
            ],
          ),

          // 2. HEADER
          Positioned(
            top: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
                if (isInDelivery)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                    child: const Text("LIVRAISON EN COURS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                  )
              ],
            ),
          ),

          // 3. PANNEAU DE CONTRÔLE
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Livreur : Karim O.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),
                  
                  // BOUTONS D'ACTION (Appel interne & Chat)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // BOUTON CHAT
                      _buildCommButton(
                        icon: Icons.chat_bubble,
                        color: Colors.blue,
                        label: "Chat",
                        isActive: isInDelivery,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ChatScreen(driverName: "Karim O."))),
                      ),
                      
                      // BOUTON APPEL INTERNE (VoIP)
                      _buildCommButton(
                        icon: Icons.call, // Icône Appel
                        color: Colors.green,
                        label: "Appel Gratuit",
                        isActive: isInDelivery,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const InAppCallScreen(driverName: "Karim O."))),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  const Divider(),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white),
                      icon: const Icon(Icons.qr_code),
                      label: const Text("MON QR CODE"),
                      onPressed: () => showModalBottomSheet(context: context, builder: (c) => const QrCodeModal()),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCommButton({required IconData icon, required Color color, required String label, required bool isActive, required VoidCallback onTap}) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: Column(
        children: [
          InkWell(
            onTap: isActive ? onTap : null,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: isActive ? color.withOpacity(0.1) : Colors.grey.shade200, shape: BoxShape.circle),
              child: Icon(icon, color: isActive ? color : Colors.grey, size: 28),
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
