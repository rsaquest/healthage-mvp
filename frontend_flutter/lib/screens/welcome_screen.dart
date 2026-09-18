import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'medication_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _openAuth(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuthScreen(requiredRole: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF7F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to HealthAge',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Access your dashboard by selecting your role:',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _RoleButton(title: 'Patient', icon: Icons.favorite_outline, onTap: () => _openAuth(context, 'Patient')),
                  _RoleButton(title: 'Practitioner', icon: Icons.work_outline, onTap: () => _openAuth(context, 'Practitioner')),
                  _RoleButton(title: 'Caregiver', icon: Icons.person_outline, onTap: () => _openAuth(context, 'Caregiver')),
                  _RoleButton(title: 'Admin', icon: Icons.admin_panel_settings_outlined, onTap: () => _openAuth(context, 'Admin')),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDF6F0),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF6BD3B7), width: 1.2),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bubble_chart_rounded, size: 14, color: Color(0xFF0F766E)),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'PRIMARY RESEARCH & TRACTION',
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.2,
                              color: Color(0xFF0F766E),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF77D0B0), width: 1.5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield_outlined, color: Color(0xFF0F766E), size: 18),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'HealthAge',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Validation & Social Proof',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1F2937),
                  letterSpacing: -2.2,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1C2B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2DD4BF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.record_voice_over_rounded, size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        '"Extensive market surveys and practitioner interviews confirm overwhelming demand for structured home care."',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'FIELD SURVEY RESULTS (SOUTHWEST NIGERIA)',
                                        style: TextStyle(
                                          color: Color(0xFF475569),
                                          fontSize: 12,
                                          letterSpacing: 1.1,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6F9F5),
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(color: const Color(0xFF8BE2D2), width: 1),
                                      ),
                                      child: const Text(
                                        'Sample Size: 1,250+',
                                        style: TextStyle(
                                          color: Color(0xFF0F766E),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    Expanded(child: _MetricTile(value: '86%', label: 'Willing to Pay for Verified Home Care', color: const Color(0xFF22C55E))),
                                    const SizedBox(width: 12),
                                    Expanded(child: _MetricTile(value: '82%', label: 'Cited Unverified Caregivers as Top Concern', color: const Color(0xFFEF4444))),
                                    const SizedBox(width: 12),
                                    Expanded(child: _MetricTile(value: '78%', label: 'Diapora Sponsors Stress Visibility Need', color: const Color(0xFF7C3AED))),
                                  ],
                                ),
                                const SizedBox(height: 22),
                                const Text(
                                  'PREFERRED PAYMENT MODELS (SURVEYED BUYERS)',
                                  style: TextStyle(
                                    color: Color(0xFF475569),
                                    fontSize: 12,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _PaymentBar(label: 'Monthly Subscription (AI-Inclusive)', value: 58, color: const Color(0xFF0F766E)),
                                const SizedBox(height: 10),
                                _PaymentBar(label: 'Pay-As-You-Go (Per Visit)', value: 32, color: const Color(0xFF14B8A6)),
                                const SizedBox(height: 10),
                                _PaymentBar(label: 'Emergency-Only Coverage Fee', value: 10, color: const Color(0xFF8B5CF6)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F766E),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'KO',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Kemi O — Diaspora Sponsor',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                                          ),
                                          Text(
                                            'Software Engineer, London UK',
                                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  '"Living in the UK, I constantly worry about my aging mother’s visits in Lagos. Having a verified nurse and real-time app updates gives our family complete peace of mind."',
                                  style: TextStyle(
                                    color: Color(0xFF334155),
                                    fontSize: 16,
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                const Divider(color: Color(0xFFE2E8F0)),
                                const SizedBox(height: 8),
                                _ProofItem(icon: Icons.groups_2_outlined, text: '100+ Practitioner Interviews: 91% nurses & physios eager to join flexible, verified marketplace.'),
                                const SizedBox(height: 12),
                                _ProofItem(icon: Icons.local_hospital_outlined, text: 'Hospital Pilots: 3 top Lagos private hospitals aligned for post-discharge recovery integration.'),
                                const SizedBox(height: 12),
                                _ProofItem(icon: Icons.medication_liquid_outlined, text: 'Pharma Network Alignment: Partnered with verified pharmacy networks for drug authenticity.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'FIELD SURVEY RESULTS (SOUTHWEST NIGERIA)',
                                    style: TextStyle(
                                      color: Color(0xFF475569),
                                      fontSize: 12,
                                      letterSpacing: 1.1,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F9F5),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: const Color(0xFF8BE2D2), width: 1),
                                  ),
                                  child: const Text(
                                    'Sample Size: 1,250+',
                                    style: TextStyle(
                                      color: Color(0xFF0F766E),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const SizedBox(height: 12),
                            _MetricTile(value: '86%', label: 'Willing to Pay for Verified Home Care', color: const Color(0xFF22C55E)),
                            const SizedBox(height: 12),
                            _MetricTile(value: '82%', label: 'Cited Unverified Caregivers as Top Concern', color: const Color(0xFFEF4444)),
                            const SizedBox(height: 12),
                            _MetricTile(value: '78%', label: 'Diapora Sponsors Stress Visibility Need', color: const Color(0xFF7C3AED)),
                            const SizedBox(height: 22),
                            const Text(
                              'PREFERRED PAYMENT MODELS (SURVEYED BUYERS)',
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 12,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _PaymentBar(label: 'Monthly Subscription (AI-Inclusive)', value: 58, color: const Color(0xFF0F766E)),
                            const SizedBox(height: 10),
                            _PaymentBar(label: 'Pay-As-You-Go (Per Visit)', value: 32, color: const Color(0xFF14B8A6)),
                            const SizedBox(height: 10),
                            _PaymentBar(label: 'Emergency-Only Coverage Fee', value: 10, color: const Color(0xFF8B5CF6)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F766E),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'KO',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kemi O — Diaspora Sponsor',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                                      ),
                                      Text(
                                        'Software Engineer, London UK',
                                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '"Living in the UK, I constantly worry about my aging mother’s visits in Lagos. Having a verified nurse and real-time app updates gives our family complete peace of mind."',
                              style: TextStyle(
                                color: Color(0xFF334155),
                                fontSize: 16,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Divider(color: Color(0xFFE2E8F0)),
                            const SizedBox(height: 8),
                            _ProofItem(icon: Icons.groups_2_outlined, text: '100+ Practitioner Interviews: 91% nurses & physios eager to join flexible, verified marketplace.'),
                            const SizedBox(height: 12),
                            _ProofItem(icon: Icons.local_hospital_outlined, text: 'Hospital Pilots: 3 top Lagos private hospitals aligned for post-discharge recovery integration.'),
                            const SizedBox(height: 12),
                            _ProofItem(icon: Icons.medication_liquid_outlined, text: 'Pharma Network Alignment: Partnered with verified pharmacy networks for drug authenticity.'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user_rounded, color: Colors.white, size: 22),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Proven Demand & Validated Willingness to Pay',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'MARKET VALIDATED',
                        style: TextStyle(
                          color: Color(0xFF0F766E),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pie_chart_rounded, size: 18, color: Color(0xFF0F766E)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'LIVE PILOT TRACTION & FIELD DATA',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFB7E8D8), width: 1),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.eco_rounded, color: Color(0xFF0F766E), size: 16),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'HealthAge',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Pilot Results, User Reviews & Model Validation',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F2937),
                  letterSpacing: -2.2,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1C2B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flash_on_rounded, color: Color(0xFF2DD4BF), size: 18),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            '"1-Month Live Pilot (July-Aug 2026): 150 User Registrations, 100% Service Fulfillment & 85% Positive Experience."',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2DD4BF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'PILOT VERIFIED',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      _StoryCard(title: 'Pilot Metrics', badge: 'MID-JULY – AUG ’26', items: const [
                        _StatRow(label: 'Registrations', value: '150', accent: Color(0xFF0F766E)),
                        _StatRow(label: 'Paid Conversion', value: '10%', accent: Color(0xFF8B5CF6)),
                        _StatRow(label: 'Completed Visits', value: '15', accent: Color(0xFF0F766E)),
                        _StatRow(label: 'SLA Fulfillment', value: '100%', accent: Color(0xFF8B5CF6)),
                      ], bottom: _ProgressLine(value: 0.85, label: 'User Experience', percent: '85%')),
                      const SizedBox(height: 18),
                      _StoryCard(title: 'Action Plan', badge: 'FEEDBACK', items: const [
                        _ActionItem(icon: Icons.price_check_rounded, title: 'Flexible Pricing', desc: 'Evaluating pay-per-visit vs. bundled visits.'),
                        _ActionItem(icon: Icons.subscriptions_rounded, title: 'Subscriptions', desc: 'Introducing monthly recurring plans.'),
                        _ActionItem(icon: Icons.home_repair_service_rounded, title: 'Tiered Options', desc: 'Segmenting basic and premium tiers.'),
                      ]),
                      const SizedBox(height: 18),
                      const _ValidatedAssumptionsCard(),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _StoryCard(title: 'Pilot Metrics', badge: 'MID-JULY – AUG ’26', items: const [
                      _StatRow(label: 'Registrations', value: '150', accent: Color(0xFF0F766E)),
                      _StatRow(label: 'Paid Conversion', value: '10%', accent: Color(0xFF8B5CF6)),
                      _StatRow(label: 'Completed Visits', value: '15', accent: Color(0xFF0F766E)),
                      _StatRow(label: 'SLA Fulfillment', value: '100%', accent: Color(0xFF8B5CF6)),
                    ], bottom: _ProgressLine(value: 0.85, label: 'User Experience', percent: '85%'))),
                    const SizedBox(width: 18),
                    Expanded(child: _StoryCard(title: 'User Feedback & Pivot', badge: 'ACTION PLAN', items: const [
                      _ActionItem(icon: Icons.price_check_rounded, title: 'Flexible Pricing Models', desc: 'Evaluating pay-per-visit vs. bundled visits to lower barrier to initial booking.'),
                      _ActionItem(icon: Icons.subscriptions_rounded, title: 'Subscription Packages', desc: 'Introducing monthly recurring plans for chronic and elderly long-term management.'),
                      _ActionItem(icon: Icons.home_repair_service_rounded, title: 'Tiered Service Options', desc: 'Segmenting basic, standard, and premium tiers to serve varied household incomes.'),
                      _ActionItem(icon: Icons.chat_bubble_outline_rounded, title: 'Clear Value Messaging', desc: 'Enhancing transparency on practitioner verification, safety, and equipment inclusion.'),
                    ])),
                    const SizedBox(width: 18),
                    Expanded(child: _ValidatedAssumptionsCard()),
                  ],
                );
              }),
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    if (isWide) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.live_tv_rounded, color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Live Market Validation Drives Strategic Execution',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'MARKET VALIDATED',
                              style: TextStyle(
                                color: Color(0xFF0F766E),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.live_tv_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'Live Market Validation Drives Strategic Execution',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'MARKET VALIDATED',
                            style: TextStyle(
                              color: Color(0xFF0F766E),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Access your dashboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _RoleButton(title: 'Patient / Family', icon: Icons.favorite_outline, onTap: () => _openAuth(context, 'Patient')),
                  _RoleButton(title: 'Practitioner', icon: Icons.medical_services_outlined, onTap: () => _openAuth(context, 'Practitioner')),
                  _RoleButton(title: 'Caregiver', icon: Icons.person_outline, onTap: () => _openAuth(context, 'Caregiver')),
                  _RoleButton(title: 'Administrator', icon: Icons.admin_panel_settings_outlined, onTap: () => _openAuth(context, 'Admin')),
                ],
              ),
              const SizedBox(height: 16),
              _RoleButton(title: 'Browse Medications', icon: Icons.shopping_cart_outlined, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicationScreen()))),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _MetricTile({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _PaymentBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _PaymentBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w600))),
            Text('$value%', style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 12,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _ProofItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProofItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF0F766E), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.55),
          ),
        ),
      ],
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String title;
  final String badge;
  final List<Widget> items;
  final Widget? bottom;

  const _StoryCard({required this.title, required this.badge, required this.items, this.bottom});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F9F5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Color(0xFF0F766E), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items,
          if (bottom != null) ...[
            const SizedBox(height: 18),
            bottom!,
          ],
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _StatRow({required this.label, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: accent)),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _ActionItem({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0F766E), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final double value;
  final String label;
  final String percent;

  const _ProgressLine({required this.value, required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF334155), fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            Text(percent, style: const TextStyle(fontSize: 11, color: Color(0xFF0F766E), fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F766E)),
          ),
        ),
      ],
    );
  }
}

class _ValidatedAssumptionsCard extends StatelessWidget {
  const _ValidatedAssumptionsCard();

  @override
  Widget build(BuildContext context) {
    final assumptions = [
      'Real Access Gap: High underserved need for structured, home-based care.',
      'Practitioner Supply Demand: Clinicians actively seek flexible digital earning streams.',
      'Willingness to Pay: Patients & diaspora sponsors pay for verified convenience.',
      'Digital Practitioner Adoption: Nurses & doctors easily adopt app dispatch tools.',
      'Scalable Marketplace Model: Two-sided healthcare platform is commercially viable.',
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  '5 Core Validated Assumptions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F9F5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'VALIDATED',
                    style: TextStyle(color: Color(0xFF0F766E), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...assumptions.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF0F766E), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF334155), height: 1.5),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleButton({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDE7E4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF0F766E), size: 18),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          ],
        ),
      ),
    );
  }
}
