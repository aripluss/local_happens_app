import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_happens/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:local_happens/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:local_happens/features/auth/domain/repositories/auth_repository.dart';
import 'package:local_happens/features/auth/domain/usecases/get_current_user.dart';
import 'package:local_happens/features/auth/domain/usecases/login_user.dart';
import 'package:local_happens/features/auth/domain/usecases/register_user.dart';
import 'package:local_happens/features/auth/domain/usecases/sign_in_with_google_user.dart';
import 'package:local_happens/features/auth/domain/usecases/sign_out_user.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:local_happens/features/events/data/datasources/event_remote_datasource.dart';
import 'package:local_happens/features/events/data/repositories/event_repository_impl.dart';
import 'package:local_happens/features/events/domain/repositories/event_repository.dart';
import 'package:local_happens/features/events/domain/usecases/create_event.dart';
import 'package:local_happens/features/events/domain/usecases/delete_event.dart';
import 'package:local_happens/features/events/domain/usecases/filter_events.dart';
import 'package:local_happens/features/events/domain/usecases/get_event_by_id.dart';
import 'package:local_happens/features/events/domain/usecases/get_events.dart';
import 'package:local_happens/features/events/domain/usecases/update_event.dart';
import 'package:local_happens/features/events/presentation/cubit/events_cubit.dart';
import 'package:local_happens/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:local_happens/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:local_happens/features/favorites/domain/usecases/add_favorite.dart';
import 'package:local_happens/features/favorites/presentation/cubit/favorites_cubit.dart';

final sl = GetIt.instance; // sl is Service Locator

Future<void> init() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);

  // Features - Auth
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      loginUser: sl(),
      registerUser: sl(),
      signInWithGoogleUser: sl(),
      signOutUser: sl(),
      getCurrentUser: sl(),
    ),
  );
  // UseCases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUser(sl()));
  sl.registerLazySingleton(() => SignOutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDatasource: sl()),
  );
  // DataSource
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(firebaseAuth: sl(), googleSignIn: sl()),
  );

  // Features - Events
  sl.registerFactory(
    () => EventsCubit(
      getEvents: sl(),
      createEventUseCase: sl(),
      updateEventUseCase: sl(),
      deleteEventUseCase: sl(),
      filterEventsUseCase: sl(),
      getEventByIdUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetEvents(sl()));
  sl.registerLazySingleton(() => CreateEvent(sl()));
  sl.registerLazySingleton(() => UpdateEvent(sl()));
  sl.registerLazySingleton(() => DeleteEvent(sl()));
  sl.registerLazySingleton(() => FilterEvents(sl()));
  sl.registerLazySingleton(() => GetEventById(sl()));
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<EventRemoteDatasource>(
    () => EventRemoteDatasourceImpl(firestore: sl()),
  );

  // Features - Favorites
  sl.registerFactory(() => FavoritesCubit(addFavoriteUseCase: sl()));
  sl.registerLazySingleton(() => AddFavorite(sl()));
  sl.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl());
}
