import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_list_app/features/venues/presentation/pages/venue_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const VenueScreen(),
      routes: [
        GoRoute(
          path: 'venue/:id',
          name: 'venueDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;

            return CustomTransitionPage(
              key: state.pageKey,
              child: _VenueDetailScreen(venueId: id),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: CurveTween(curve: Curves.easeInOut).animate(animation), child: child);
              },
            );
          },
        ),
      ],
    ),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Página não encontrada', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => context.go('/'), child: const Text('Voltar para a Home')),
            ],
          ),
        ),
      ),
);

// Placeholder para VenueDetailScreen até termos o arquivo real
class _VenueDetailScreen extends StatelessWidget {
  final String venueId;

  const _VenueDetailScreen({required this.venueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Local')),
      body: Center(child: Text('Detalhes do local ID: $venueId')),
    );
  }
}

// Extensão para navegação
extension GoRouterExtension on BuildContext {
  void pushVenueDetail(String venueId) {
    GoRouter.of(this).pushNamed('venueDetail', pathParameters: {'id': venueId});
  }
}
