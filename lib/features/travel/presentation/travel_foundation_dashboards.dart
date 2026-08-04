import 'package:flutter/material.dart';
import '../../../app/widgets/knight_page_scaffold.dart';

class TravelImportDashboard extends StatelessWidget {
  const TravelImportDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Import Tracker',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildStatCard(context, 'Emails Scanned', '1,240', Icons.email_outlined),
              _buildStatCard(context, 'Travel Emails', '42', Icons.flight_takeoff),
              _buildStatCard(context, 'Photos Scanned', '8,400', Icons.photo_library),
              _buildStatCard(context, 'GPS Photos', '156', Icons.location_on),
              _buildStatCard(context, 'Evidence Created', '248', Icons.description_outlined),
              _buildStatCard(context, 'Trips Reconstructed', '12', Icons.rebase_edit),
              _buildStatCard(context, 'Sync Queue', 'Idle', Icons.sync),
              _buildStatCard(context, 'Last Sync', '10m ago', Icons.history),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

class TravelQualityDashboard extends StatelessWidget {
  const TravelQualityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Import Quality',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildQualityRow(context, 'Import Success %', '98.5%'),
            _buildQualityRow(context, 'Avg Confidence', '0.84'),
            _buildQualityRow(context, 'Duplicate Rate', '2.1%'),
            _buildQualityRow(context, 'Repair Success', '100%'),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class TravelMissionControl extends StatelessWidget {
  const TravelMissionControl({super.key});

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Mission Control',
      body: ListView(
        children: const [
          ListTile(title: Text('Connector Health'), trailing: Icon(Icons.check_circle, color: Colors.green)),
          ListTile(title: Text('Sync Health'), trailing: Icon(Icons.check_circle, color: Colors.green)),
          ListTile(title: Text('Graph Health'), trailing: Icon(Icons.warning, color: Colors.orange)),
          ListTile(title: Text('Storage Health'), trailing: Icon(Icons.check_circle, color: Colors.green)),
        ],
      ),
    );
  }
}

class TravelDeveloperMode extends StatelessWidget {
  const TravelDeveloperMode({super.key});

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Travel Dev Mode',
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: const [
            TabBar(
              tabs: [
                Tab(text: 'Logs'),
                Tab(text: 'Queues'),
                Tab(text: 'Graph'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Raw logs stream...')),
                  Center(child: Text('Sync & Repair Queues...')),
                  Center(child: Text('Knowledge Graph Viewer...')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
