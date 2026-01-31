import 'package:flutter/material.dart';
import 'dart:async';

class InAppCallScreen extends StatefulWidget {
  final String driverName;
  const InAppCallScreen({super.key, required this.driverName});

  @override
  State<InAppCallScreen> createState() => _InAppCallScreenState();
}

class _InAppCallScreenState extends State<InAppCallScreen> {
  Duration _duration = const Duration();
  Timer? _timer;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  String _status = "Connexion...";

  @override
  void initState() {
    super.initState();
    // Simulation : Connexion établie après 2 secondes
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _status = "En ligne");
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = Duration(seconds: _duration.inSeconds + 1);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004D40), // Fond sombre
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // HEADER (Nom + Statut)
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 80, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.driverName,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _status == "En ligne" ? _formatDuration(_duration) : _status,
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18),
                  ),
                ],
              ),
            ),

            // CONTROLES (Bas de page)
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // BOUTON MUTE
                  _buildControlBtn(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: "Muet",
                    isActive: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  
                  // BOUTON RACCROCHER (Gros bouton rouge)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)]
                      ),
                      child: const Icon(Icons.call_end, color: Colors.white, size: 35),
                    ),
                  ),

                  // BOUTON HAUT-PARLEUR
                  _buildControlBtn(
                    icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                    label: "Haut-parleur",
                    isActive: _isSpeakerOn,
                    onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildControlBtn({required IconData icon, required String label, required bool isActive, required VoidCallback onTap}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isActive ? Colors.black : Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))
      ],
    );
  }
}
