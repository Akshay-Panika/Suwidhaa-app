import 'package:flutter/material.dart';

// 1. Data Model to hold raw numbers for calculation
class PlanData {
  final String durationText;
  final int months;
  final double sellingPrice;
  final double basePricePerMonth;
  final bool isMostPopular;
  final bool isBestValue;

  PlanData({
    required this.durationText,
    required this.months,
    required this.sellingPrice,
    this.basePricePerMonth = 182.0,
    this.isMostPopular = false,
    this.isBestValue = false,
  });

  // Calculations
  int get totalDays => months * 30;
  double get originalPrice => basePricePerMonth * months;
  int get discountPercent => (((originalPrice - sellingPrice) / originalPrice) * 100).round();
  double get perDayCost => sellingPrice / totalDays;
}

class OttPlainScreen extends StatefulWidget {
  const OttPlainScreen({super.key});

  @override
  State<OttPlainScreen> createState() => _OttPlainScreenState();
}

class _OttPlainScreenState extends State<OttPlainScreen> {
  int selectedPlanIndex = 1; // Default to "3 Months"

  final List<PlanData> plans = [
    PlanData(durationText: "1 Month", months: 1, sellingPrice: 109),
    PlanData(durationText: "3 Months", months: 3, sellingPrice: 299, isMostPopular: true),
    PlanData(durationText: "6 Months", months: 6, sellingPrice: 519),
    PlanData(durationText: "12 Months", months: 12, sellingPrice: 919, isBestValue: true),
  ];

  // Top Offer Variables
  final double topOfferPrice = 69.0;
  final double topOfferBasePrice = 182.0;
  int get topOfferDiscount => (((topOfferBasePrice - topOfferPrice) / topOfferBasePrice) * 100).round();
  double get topOfferPerDay => topOfferPrice / 30;

  // Selected Plan Helper
  PlanData get selectedPlan => plans[selectedPlanIndex];

  // --- MOCK PAYMENT FLOW ---
  void _handlePayNow() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF23252B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            bool isProcessing = false;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Order Summary",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Plan", style: TextStyle(color: Colors.grey[400])),
                      Text(selectedPlan.durationText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount", style: TextStyle(color: Colors.grey[400])),
                      Text("₹${selectedPlan.sellingPrice.toInt()}", style: const TextStyle(color: Color(0xFFFBE04B), fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8B040),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: isProcessing
                          ? null
                          : () async {
                        setModalState(() => isProcessing = true);
                        // Simulate network delay
                        await Future.delayed(const Duration(seconds: 2));

                        if (context.mounted) {
                          Navigator.pop(context); // Close bottom sheet
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentSuccessScreen(plan: selectedPlan),
                            ),
                          );
                        }
                      },
                      child: isProcessing
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                      )
                          : const Text(
                        "Proceed to Payment",
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF13151A),
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
      ),
      backgroundColor: const Color(0xFF13151A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // --- REMOVED TOP FEATURES ROW HERE ---

              // --- Limited Time Offer Title ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.blueAccent[400], size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      "Limited Time Offer",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- Main Highlight Box ---
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF23252B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 1.5),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("₹", style: TextStyle(color: Color(0xFFFBE04B), fontSize: 36, fontWeight: FontWeight.bold)),
                          Text(topOfferPrice.toInt().toString(), style: const TextStyle(color: Color(0xFFFBE04B), fontSize: 48, fontWeight: FontWeight.bold, height: 1.0)),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8, left: 4),
                            child: Text("/month", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -12,
                      right: -1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF25C05),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                        ),
                        child: Text("Limited Time $topOfferDiscount% Off", style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Text(
                        "₹${topOfferBasePrice.toInt()}   Approx. ₹${topOfferPerDay.toStringAsFixed(1)} per day",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Countdown Timer ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("End in ", style: TextStyle(color: Colors.white, fontSize: 16)),
                  _buildTimeBox("00"),
                  const Text(" : ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildTimeBox("52"),
                  const Text(" : ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildTimeBox("12"),
                ],
              ),
              const SizedBox(height: 20),

              // --- Subscription Grid ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: SelectablePlanCard(plan: plans[0], isSelected: selectedPlanIndex == 0, onTap: () => setState(() => selectedPlanIndex = 0))),
                        const SizedBox(width: 12),
                        Expanded(child: SelectablePlanCard(plan: plans[1], isSelected: selectedPlanIndex == 1, onTap: () => setState(() => selectedPlanIndex = 1))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: SelectablePlanCard(plan: plans[2], isSelected: selectedPlanIndex == 2, onTap: () => setState(() => selectedPlanIndex = 2))),
                        const SizedBox(width: 12),
                        Expanded(child: SelectablePlanCard(plan: plans[3], isSelected: selectedPlanIndex == 3, onTap: () => setState(() => selectedPlanIndex = 3))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Bottom Section (Validity & Button) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: const Color(0xFF2A2C31),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dynamic display of selected plan
                    Text("₹${selectedPlan.sellingPrice.toInt()}/${selectedPlan.durationText}", style: const TextStyle(color: Color(0xFFE8B040), fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    const Text("Valid until 20 Oct 2026", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),

              // Pay Now Button area
              Container(
                color: const Color(0xFF13151A),
                padding: const EdgeInsets.all(16),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: _handlePayNow, // Trigger Payment Flow
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFCE083), Color(0xFFF2A930)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text("PAY NOW", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -10,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF25C05),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        ),
                        child: Text("Approx ₹${selectedPlan.perDayCost.toStringAsFixed(2)} per day", style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF23252B), borderRadius: BorderRadius.circular(4)),
      child: Text(time, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

// --- Reusable Selectable Plan Card Widget ---
class SelectablePlanCard extends StatelessWidget {
  final PlanData plan;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectablePlanCard({Key? key, required this.plan, required this.isSelected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2C3038) : const Color(0xFF23252B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Colors.grey : Colors.transparent, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.durationText, style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₹${plan.sellingPrice.toInt()}", style: const TextStyle(color: Color(0xFFFBE04B), fontSize: 24, fontWeight: FontWeight.bold, height: 1.0)),
                    const SizedBox(width: 6),
                    Text("₹${plan.originalPrice.toInt()}", style: const TextStyle(color: Colors.grey, fontSize: 14, decoration: TextDecoration.lineThrough)),
                  ],
                ),
                const SizedBox(height: 6),
                Text("Approx.₹${plan.perDayCost.toStringAsFixed(2)} per day", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Positioned(
            top: -1,
            right: -1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: plan.isBestValue ? const Color(0xFF1B5E20) : Colors.white,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(8)),
              ),
              child: Text(
                "${plan.discountPercent}% Off",
                style: TextStyle(color: plan.isBestValue ? Colors.white : Colors.black87, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (plan.isMostPopular)
            Positioned(
              top: -10, left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFE65100), borderRadius: BorderRadius.circular(10)),
                  child: const Text("Most popular", style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ),
          if (plan.isBestValue)
            Positioned(
              top: -10, left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFF2E7D32), borderRadius: BorderRadius.circular(10)),
                  child: const Text("Best Value", style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// --- SUCCESS SCREEN ---
class PaymentSuccessScreen extends StatelessWidget {
  final PlanData plan;

  const PaymentSuccessScreen({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 80),
              ),
              const SizedBox(height: 30),
              const Text(
                "Payment Successful!",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Your ${plan.durationText} subscription is now active.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF23252B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow("Plan", plan.durationText),
                    const Divider(color: Colors.grey, height: 20),
                    _buildSummaryRow("Amount Paid", "₹${plan.sellingPrice.toInt()}"),
                    const Divider(color: Colors.grey, height: 20),
                    _buildSummaryRow("Valid Till", "20 Oct 2026"),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8B040),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // Pop back to the main screen
                    Navigator.pop(context);
                  },
                  child: const Text("Go to Home", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}