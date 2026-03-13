import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/firebase_options.dart';
import 'injection_container.dart' as di;
import 'router/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/events/presentation/cubit/events_cubit.dart';
import 'features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // TODO: move EventsCubit, FavoritesCubit creation to app_router
        BlocProvider(create: (_) => di.sl<AuthCubit>()..checkAuth()),
        BlocProvider(create: (_) => di.sl<EventsCubit>()..loadEvents()),
        BlocProvider(create: (_) => di.sl<FavoritesCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Local Happens',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
