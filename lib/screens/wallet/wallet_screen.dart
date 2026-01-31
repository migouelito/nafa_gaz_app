import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour le presse-papier (Copier)
import 'package:share_plus/share_plus.dart'; // Pour le partage (WhatsApp, SMS)

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // --- LOGIQUE FONCTIONNELLE ---

  // 1. Fonction pour copier le code
  void _copyCode() {
    Clipboard.setData(const ClipboardData(text: "NAFA-MOUSSA-88"));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Code copié dans le presse-papier !"), backgroundColor: Colors.green),
    );
  }

  // 2. Fonction pour partager
  void _shareCode() {
    Share.share('Salut ! Utilise mon code NAFA-MOUSSA-88 sur Nafa Gaz et gagne une livraison gratuite ! https://nafagaz.bf');
  }

  // 3. Fonction pour recharger (Modale Paiement)
  void _showRechargeModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recharger mon compte", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text("Choisissez un moyen de paiement :", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildPaymentOption("Orange Money", Colors.orange, Icons.money)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildPaymentOption("Moov Money", Colors.blue, Icons.mobile_friendly)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(String name, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Redirection vers $name...")));
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(name, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Portefeuille & Parrainage"),
        backgroundColor: const Color(0xFF00A86B),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Mon Solde"),
            Tab(text: "Parrainage"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBalanceTab(),
          _buildReferralTab(),
        ],
      ),
    );
  }

  // --- VUE SOLDE ---
  Widget _buildBalanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF00A86B), Color(0xFF004D40)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: const Color(0xFF00A86B).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 10))],
            ),
            child: Column(
              children: [
                const Text("Solde Disponible", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 10),
                const Text("12 500 F", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showRechargeModal, // Action Recharger connectée
                    icon: const Icon(Icons.add_card),
                    label: const Text("RECHARGER LE COMPTE"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF00A86B), padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("Historique des transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildTransactionItem("Recharge Orange Money", "+ 5000 F", "14 Janv 2026", true),
              _buildTransactionItem("Achat Gaz (Sodigaz 12kg)", "- 7500 F", "10 Janv 2026", false),
              _buildTransactionItem("Bonus Parrainage", "+ 1500 F", "05 Janv 2026", true),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, String date, bool isCredit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCredit ? Colors.green.shade50 : Colors.red.shade50,
          child: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? Colors.green : Colors.red),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(amount, style: TextStyle(color: isCredit ? Colors.green : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  // --- VUE PARRAINAGE ---
  Widget _buildReferralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.orange.shade200)),
            child: Column(
              children: [
                const Icon(Icons.card_giftcard, color: Colors.orange, size: 40),
                const SizedBox(height: 10),
                const Text("Gagnez 1500 F par ami !", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
                const SizedBox(height: 5),
                const Text("Offrez la livraison gratuite à vos amis. Dès leur première commande livrée, vous recevez 1500 F.", textAlign: TextAlign.center),
                const SizedBox(height: 20),
                
                // ZONE CODE COPIABLE
                InkWell(
                  onTap: _copyCode, // Action Copier connectée
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.orange.shade100)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("NAFA-MOUSSA-88", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5)),
                        Icon(Icons.copy, color: Colors.orange.shade300),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _shareCode, // Action Partager connectée
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                    child: const Text("PARTAGER MON CODE"),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Align(alignment: Alignment.centerLeft, child: Text("Suivi des Filleuls", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          const SizedBox(height: 10),
          _buildReferralItem("Awa Sanogo", "Inscrit", Colors.grey),
          _buildReferralItem("Jean Kabore", "Commande Livrée (+1500F)", Colors.green),
          _buildReferralItem("Paul Ouoba", "En attente", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildReferralItem(String name, String status, Color color) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.grey.shade200, child: Text(name[0])),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}
