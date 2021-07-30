import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:telegram_app/cubits/search_cubit.dart';
import 'package:telegram_app/models/user.dart';
import 'package:telegram_app/repositories/user_repository.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final SearchCubit searchCubit;
  final UserRepository userRepository;
  final FirebaseAnalytics firebaseAnalytics;

  StreamSubscription<String?>? _searchStreamSubscription;
  StreamSubscription<bool>? _toggleStreamSubscription;

  Timer? _debounce;

  UsersBloc({
    required this.searchCubit,
    required this.userRepository,
    required this.firebaseAnalytics,
  }) : super(InitialUsersState()) {
    _searchStreamSubscription = searchCubit.searchBinding.stream
        .where((query) => query != null)
        .listen((query) {
      if (_debounce != null && _debounce!.isActive) _debounce?.cancel();
      _debounce =
          Timer(const Duration(milliseconds: 250), () => _searchUsers(query!));
    });

    _toggleStreamSubscription =
        searchCubit.stream.where((enabled) => !enabled).listen((_) => _reset());
  }

  @override
  Stream<UsersState> mapEventToState(
    UsersEvent event,
  ) async* {
    if (event is SearchUsersEvent) {
      firebaseAnalytics.logSearch(
        searchTerm: event.query,
        destination: "users",
      );

      yield SearchingUsersState();

      List<User>? users;
      try {
        users = await userRepository.search(event.query);
      } catch (exception) {
        yield ErrorUsersState();
      }

      if (users != null) {
        if (users.isEmpty) {
          yield NoUsersState();
        } else {
          yield FetchedUsersState(users);
          firebaseAnalytics.logViewSearchResults(searchTerm: event.query);
        }
      }
    } else if (event is ResetSearchEvent) {
      yield InitialUsersState();
    }
  }

  @override
  Future<void> close() async {
    await _searchStreamSubscription?.cancel();
    await _toggleStreamSubscription?.cancel();

    return super.close();
  }

  void _searchUsers(String query) => add(SearchUsersEvent(query));

  void _reset() => add(ResetSearchEvent());
}
