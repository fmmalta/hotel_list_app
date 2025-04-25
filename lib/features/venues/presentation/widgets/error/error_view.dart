import 'package:flutter/material.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';

class ErrorView extends StatelessWidget {
  final VenuesError state;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.state, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: 'Error loading venues',
        value: state.message,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Semantics(
              button: true,
              label: 'Retry loading venues',
              excludeSemantics: true,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
