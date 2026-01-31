import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String driverName;
  const ChatScreen({super.key, required this.driverName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isRecording = false;

  // Types de messages : text ou audio
  final List<Map<String, dynamic>> _messages = [
    {"type": "text", "content": "J'arrive dans 5 min", "isMe": false, "time": "14:30"},
    {"type": "audio", "content": "0:15", "isMe": true, "time": "14:31"}, // Message vocal simulé
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driverName),
        backgroundColor: const Color(0xFF00A86B),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // LISTE DES MESSAGES
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'];
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF00A86B).withOpacity(0.2) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (msg['type'] == 'text')
                          Text(msg['content'], style: const TextStyle(fontSize: 16))
                        else
                          // UI MESSAGE VOCAL
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow, color: isMe ? const Color(0xFF00A86B) : Colors.grey),
                              const SizedBox(width: 5),
                              // Visualisation de l'onde sonore (fake)
                              SizedBox(
                                width: 100,
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(10, (i) => Container(
                                    width: 3,
                                    height: (i % 2 == 0) ? 15 : 8,
                                    color: isMe ? const Color(0xFF00A86B) : Colors.grey,
                                  )),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(msg['content'], style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        const SizedBox(height: 5),
                        Text(msg['time'], style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // ZONE DE SAISIE AVEC MICRO
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (val) => setState(() {}), // Pour changer l'icône micro/send
                    decoration: InputDecoration(
                      hintText: _isRecording ? "Enregistrement..." : "Message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: _isRecording ? Colors.red.shade50 : Colors.grey.shade100,
                      prefixIcon: _isRecording ? const Icon(Icons.mic, color: Colors.red) : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                
                // BOUTON DYNAMIQUE (ENVOI ou MICRO)
                GestureDetector(
                  onLongPress: () {
                    // Simulation début enregistrement
                    if (_controller.text.isEmpty) setState(() => _isRecording = true);
                  },
                  onLongPressEnd: (details) {
                    // Simulation fin enregistrement et envoi
                    if (_isRecording) {
                      setState(() {
                        _isRecording = false;
                        _messages.add({
                          "type": "audio",
                          "content": "0:08", // Durée simulée
                          "isMe": true,
                          "time": "${DateTime.now().hour}:${DateTime.now().minute}"
                        });
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: _isRecording ? Colors.red : const Color(0xFF00A86B),
                    radius: 25,
                    child: IconButton(
                      icon: Icon(
                        _controller.text.isEmpty && !_isRecording ? Icons.mic : Icons.send, 
                        color: Colors.white
                      ),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          setState(() {
                            _messages.add({"type": "text", "content": _controller.text, "isMe": true, "time": "Now"});
                            _controller.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Maintenez pour enregistrer un vocal")));
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
