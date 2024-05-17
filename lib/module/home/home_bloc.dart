import 'package:bloc/bloc.dart';
import 'package:shop/api/api_manager.dart';
import 'package:shop/module/home/home_event.dart';
import 'package:shop/module/home/home_state.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiManager apiManager;

  HomeBloc({required this.apiManager}) : super(HomeInitial()) {
    on<LoadPrayerTimes>(_onLoadPrayerTimes);
  }

  Future<void> _onLoadPrayerTimes(
      LoadPrayerTimes event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final response = await apiManager.getPrayerTimes();

      if (response != null && response.isNotEmpty) {
        emit(HomeLoaded(prayerTimes: response));
      } else {
        emit(HomeError(message: "Failed to load prayer times: Empty response"));
      }
    } catch (e, stackTrace) {
      print("Error: $e\nStack trace:\n$stackTrace");
      emit(HomeError(message: "Something went wrong. Please try again later."));
    }
  }
}
