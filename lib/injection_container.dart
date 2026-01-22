import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/core/theme/theme_bloc.dart';
import 'package:eduera_student/features/auth/data/auth_data_source.dart';
import 'package:eduera_student/features/auth/domain/repositories/auth_repository.dart';
import 'package:eduera_student/features/auth/domain/usecases/sign_in.dart';
import 'package:eduera_student/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:eduera_student/features/auth/domain/usecases/sign_up.dart';
import 'package:eduera_student/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:eduera_student/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:eduera_student/features/bookmark/domain/usecases/add_bookmark.dart';
import 'package:eduera_student/features/bookmark/domain/usecases/is_bookmarked.dart';
import 'package:eduera_student/features/bookmark/domain/usecases/remove_bookmark.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:eduera_student/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:eduera_student/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:eduera_student/features/chat/domain/repositories/chat_repository.dart';
import 'package:eduera_student/features/chat/domain/usecases/delete_message_for_everyone.dart';
import 'package:eduera_student/features/chat/domain/usecases/delete_message_for_me.dart';
import 'package:eduera_student/features/chat/domain/usecases/ensure_chat_exists.dart';
import 'package:eduera_student/features/chat/domain/usecases/mark_messages_as_read.dart';
import 'package:eduera_student/features/chat/domain/usecases/set_typing.dart';
import 'package:eduera_student/features/chat/domain/usecases/watch_student_inbox.dart';
import 'package:eduera_student/features/chat/domain/usecases/send_message.dart';
import 'package:eduera_student/features/chat/domain/usecases/watch_messages.dart';
import 'package:eduera_student/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:eduera_student/features/chat/presentation/inbox/inbox_bloc.dart';
import 'package:eduera_student/features/home/data/datasources/firebase_course_datasource.dart';
import 'package:eduera_student/features/home/data/repositories/course_repository_impl.dart';
import 'package:eduera_student/features/home/data/repositories/home_repository.dart';
import 'package:eduera_student/features/home/domain/repositories/course_repository.dart';
import 'package:eduera_student/features/home/domain/usecases/get_all_courses.dart';
import 'package:eduera_student/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';

import 'package:eduera_student/features/payment/data/data_sources/enroll_remote_datasource.dart';
import 'package:eduera_student/features/payment/data/repositories/enroll_repository_impl.dart';
import 'package:eduera_student/features/payment/domain/repositories/enroll_repository.dart';
import 'package:eduera_student/features/payment/domain/usecases/enroll_course_usecase.dart';
import 'package:eduera_student/features/payment/domain/usecases/mark_course_completed_usecase.dart';
import 'package:eduera_student/features/payment/domain/usecases/mark_sublesson_completed_usecase.dart';
import 'package:eduera_student/features/payment/domain/usecases/watch_enroll_progress_usecase.dart';
import 'package:eduera_student/features/payment/presentation/bloc/course_progress_bloc/lesson_progress_bloc.dart';
import 'package:eduera_student/features/payment/presentation/bloc/enrollment/enrollment_bloc.dart';
import 'package:eduera_student/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:eduera_student/features/profile/data/repository/student_repository_impl.dart';
import 'package:eduera_student/features/profile/data/services/student_service.dart';
import 'package:eduera_student/features/profile/domain/repository/student_repository.dart';
import 'package:eduera_student/features/profile/presentation/bloc/profile_bloc.dart';

import 'package:eduera_student/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:eduera_student/features/reviews/domain/repositories/review_repository.dart';
import 'package:eduera_student/features/reviews/domain/usecases/delete_review.dart';
import 'package:eduera_student/features/reviews/domain/usecases/edit_review.dart';
import 'package:eduera_student/features/reviews/domain/usecases/fetch_reviews.dart';
import 'package:eduera_student/features/reviews/domain/usecases/add_review.dart';
import 'package:eduera_student/features/reviews/domain/usecases/toggle_like.dart';
import 'package:eduera_student/features/reviews/domain/usecases/toggle_dislike.dart';
import 'package:eduera_student/features/reviews/presentation/bloc/review_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Auth
  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));

  // Home Courses

  sl.registerLazySingleton<FirebaseCourseDataSource>(
    () => FirebaseCourseDataSource(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepository(sl<FirebaseCourseDataSource>()),
  );
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(
      sl<FirebaseCourseDataSource>(),
      sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton(() => GetAllCourses(sl<CourseRepository>()));
  sl.registerLazySingleton(() => GetCourseById(sl<CourseRepository>()));

  sl.registerFactory(
    () => CourseBloc(
      getAllCourses: sl<GetAllCourses>(),
      getCourseById: sl<GetCourseById>(),
      repository: sl<CourseRepository>(),
    ),
  );

  sl.registerFactory(() => CategoryBloc(sl<HomeRepository>()));
  sl.registerFactory(() => MentorBloc(sl<HomeRepository>()));

  // Payment

  sl.registerFactory(() => PaymentBloc());

  // Enrollment

  sl.registerLazySingleton<EnrollRemoteDataSource>(
    () => EnrollRemoteDataSourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<EnrollRepository>(
    () => EnrollRepositoryImpl(
      sl<EnrollRemoteDataSource>(),
      sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton(() => EnrollCourseUseCase(sl<EnrollRepository>()));

  sl.registerFactory(
    () => EnrollmentBloc(sl<EnrollRepository>(), sl<EnsureChatExists>()),
  );
  // --------------------------------------------------------- // USE CASES (Progress System) // ---------------------------------------------------------
  sl.registerLazySingleton(
    () => WatchEnrollmentProgressUseCase(sl<EnrollRepository>()),
  );
  sl.registerLazySingleton(
    () => MarkSublessonCompletedUseCase(sl<EnrollRepository>()),
  );
  sl.registerLazySingleton(
    () => MarkCourseCompletedUseCase(sl<EnrollRepository>()),
  );
  // --------------------------------------------------------- // BLOCS // ---------------------------------------------------------
  sl.registerFactory(
    () => LessonProgressBloc(
      watchUseCase: sl<WatchEnrollmentProgressUseCase>(),
      markUseCase: sl<MarkSublessonCompletedUseCase>(),
      markCourseCompletedUseCase: sl<MarkCourseCompletedUseCase>(),
    ),
  );

  // chat
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl()),
  );
  // --------------------------- // Repository // ---------------------------
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  // --------------------------- // Use Cases // ---------------------------
  sl.registerLazySingleton(() => WatchStudentInbox(sl()));
  sl.registerLazySingleton(() => WatchMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => EnsureChatExists(sl()));
  sl.registerLazySingleton(() => SetTyping(sl()));
  sl.registerLazySingleton(() => MarkMessagesAsRead(sl()));
sl.registerLazySingleton<DeleteMessageForEveryone>(
    () => DeleteMessageForEveryone(sl()),
  );

  sl.registerLazySingleton<DeleteMessageForMe>(() => DeleteMessageForMe(sl()));

  // --------------------------- // Blocs // ---------------------------
  sl.registerFactory(
    () => InboxBloc(
      enrollmentRepo: sl<EnrollRepository>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerFactory(
    () => ChatBloc(
      watchMessages: sl(),
      sendMessage: sl(),

      setTyping: sl(),
      markMessagesAsRead: sl(),
        deleteMessageForEveryone: sl(),
      deleteMessageForMe: sl(),
    ),
  );

  // Reviews

  sl.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(sl()));

  sl.registerLazySingleton(() => FetchReviews(sl()));
  sl.registerLazySingleton(() => AddReview(sl()));
  sl.registerLazySingleton(() => ToggleLike(sl()));
  sl.registerLazySingleton(() => ToggleDislike(sl()));
  sl.registerLazySingleton(() => EditReview(sl()));
  sl.registerLazySingleton(() => DeleteReview(sl()));

  sl.registerFactory(
    () => ReviewBloc(
      fetchReviews: sl(),
      addReview: sl(),
      editReview: sl(),
      deleteReview: sl(),
      toggleLike: sl(),
      toggleDislike: sl(),
    ),
  );

  //  Bookmark Repository
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(sl()),
  );

  //  Bookmark Use Cases
  sl.registerLazySingleton(() => AddBookmark(sl()));
  sl.registerLazySingleton(() => RemoveBookmark(sl()));
  sl.registerLazySingleton(() => IsBookmarked(sl()));

  //  Bookmark Bloc
  sl.registerFactory(
    () => BookmarkBloc(
      addBookmark: sl(),
      removeBookmark: sl(),
      isBookmarked: sl(),
      repository: sl<BookmarkRepository>(),
    ),
  );
  sl.registerLazySingleton<StudentService>(() => StudentService());

  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(sl<StudentService>()),
  );

  sl.registerFactory<ProfileBloc>(() => ProfileBloc(sl<StudentRepository>()));

  sl.registerLazySingleton<ThemeBloc>(() => ThemeBloc());
}
