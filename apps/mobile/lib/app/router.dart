import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/pharmacy/presentation/screens/pharmacy_screen.dart';
import '../features/meds/presentation/screens/meds_screen.dart';
import '../features/chat/presentation/screens/chat_screen.dart';
import 'shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/pharmacy',
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/pharmacy',
            name: 'pharmacy',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PharmacyScreen(),
            ),
          ),
          GoRoute(
            path: '/meds',
            name: 'meds',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MedsScreen(),
            ),
          ),
          GoRoute(
            path: '/chat',
            name: 'chat',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
