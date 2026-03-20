import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileUnauthenticatedWidget extends StatelessWidget {
  const ProfileUnauthenticatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 32, child: Icon(Icons.person_outline, size: 32)),
          SizedBox(height: 16),
          Text('Вітаємо в Local Happens!'),
          Center(
            child: Text(
              'Увійдіть, щоб додавати події, зберігати улюблене та керувати своїми подіями',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push('/login'),
            child: Text('Увійти / Зареєструватись'),
          ),
        ],
      ),
    );
  }
}
