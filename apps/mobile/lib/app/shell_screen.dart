import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/pharmacy')) return 0;
    if (location.startsWith('/meds')) return 1;
    if (location.startsWith('/chat')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getCurrentIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/pharmacy');
              break;
            case 1:
              context.go('/meds');
              break;
            case 2:
              context.go('/chat');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_pharmacy_outlined),
            selectedIcon: Icon(Icons.local_pharmacy),
            label: 'Nöbetçi',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication),
            label: 'İlaçlarım',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'Sohbet',
          ),
        ],
      ),
    );
  }
}
