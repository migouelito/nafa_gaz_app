import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import '../../../../servicesApp/urlBase.dart';
import '../../../../appColors/appColors.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        title: const Text("Confirmation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isProductLoading.value) {
          return SizedBox.shrink();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Détails de la commande"),
              _buildProductCard(),
              const SizedBox(height: 25),
              _buildSectionTitle("Quantité souhaitée"),
              _buildQuantitySelector(),
              const SizedBox(height: 25),
              _buildSectionTitle("Récapitulatif financier"),
              _buildPaymentDetails(),
              const SizedBox(height: 25),
              _buildSectionTitle("Adresse de livraison"),
              _buildAddressCard(),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() => 
        controller.isProductLoading.value ? const SizedBox() : _buildBottomAction()
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }

  Widget _buildProductCard() {
    final String fullImageUrl = (controller.product['image'] != null)
        ? "${ApiUrlPage.baseUrl}${controller.product['image']}"
        : "";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Row(children: [
        Container(
          height: 85, width: 85,
          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: fullImageUrl.isNotEmpty 
              ? Image.network(fullImageUrl, fit: BoxFit.contain)
              : const Icon(Icons.propane_tank, color: Color(0xFF003317), size: 40),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${controller.product['name']} ${controller.product['weight']}", 
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 6),
            // BADGE DE STOCK
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("Stock disponible: ${controller.product['stock']}", 
                style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Text("${controller.product['price']} F CFA / unité", 
              style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Nombre de bouteilles", style: TextStyle(fontWeight: FontWeight.w600)),
          Row(
            children: [
              _buildQtyBtn(Icons.remove, controller.removeQuantity),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => Text("${controller.quantity.value}", 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003317)))),
              ),
              _buildQtyBtn(Icons.add, controller.addQuantity),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFF003317).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFF003317), size: 20),
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Obx(() {
        int subtotal = (controller.product['price'] as int) * controller.quantity.value;
        return Column(children: [
          _buildPriceRow("Sous-total", "$subtotal F"),
          _buildPriceRow("Frais de livraison", "+ ${controller.deliveryFee} F"),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Montant Total", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              Text("${controller.total.value} F CFA", 
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF00A86B))),
            ],
          ),
        ]);
      }),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(children: const [
          Icon(Icons.location_on, color: Color(0xFFFF5722), size: 28),
          SizedBox(width: 12),
          Expanded(child: Text("Maison (Patte d'oie), Rue 14.55", style: TextStyle(fontWeight: FontWeight.w600))),
      ]),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity, height: 58,
        child: ElevatedButton(
          onPressed: () => controller.validerCommande(), 
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003317), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text("CONFIRMER LA COMMANDE", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}