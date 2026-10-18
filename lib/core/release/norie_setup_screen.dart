import 'package:flutter/material.dart';

/// Read-only release information: this screen cannot grant roles or entitlements.
class NorieSetupScreen extends StatelessWidget {
  const NorieSetupScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Preview configuration')),
        body: ListView(padding: const EdgeInsets.all(16), children: const [
          Text(
              'Learning works offline. Optional services have separate setup requirements.'),
          SizedBox(height: 12),
          _SetupCard(
              title: 'Offline Classroom',
              status: 'Available',
              detail:
                  'Build assignments and exchange files offline. Local Wi-Fi Classroom requires the installed Windows or Android app. Reports support practice; they are not secure exam certificates.'),
          _SetupCard(
              title: 'Cloud Classroom',
              status: 'Not configured',
              detail:
                  'Continue using file exchange or local Wi-Fi. Cloud classes require verified teacher roles, class access rules, invitation controls, guardian consent, deletion and retention policies, and tested account isolation. Existing account sync does not enable cloud classes. No classroom work is automatically uploaded.'),
          _SetupCard(
              title: 'Paid memberships',
              status: 'Billing unavailable',
              detail:
                  'Plan prices and benefits are proposals. Purchases and restore require platform billing, verified server receipts, approved renewal and refund terms, and guardian safeguards. No paid membership is activated by this preview.'),
          _SetupCard(
              title: 'Store release',
              status: 'Not certified — Preview downloads only',
              detail:
                  'Production Android and Windows signing, physical device tests, real classroom Wi-Fi tests, migration checks, published privacy policy, support contact, account deletion review, store graphics and content ratings remain pending. Automated tests do not replace these reviews.'),
          _SetupCard(
              title: 'Curriculum publication',
              status: 'Local drafts only',
              detail:
                  'Existing bundled lessons remain available. Imported packs and edits stay in the local workspace until genuine content review and an authorized publication process are complete. Drafts cannot award XP or replace your learning history.'),
        ]),
      );
}

class _SetupCard extends StatelessWidget {
  const _SetupCard(
      {required this.title, required this.status, required this.detail});
  final String title, status, detail;
  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(detail),
          ])));
}
