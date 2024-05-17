  import 'package:bloc/bloc.dart';
  import 'package:dio/dio.dart';
  import 'package:shop/api/api_manager.dart';
  import 'package:shop/constant.dart';
  import 'package:shop/module/home/home_event.dart';
  import 'package:shop/module/home/home_state.dart';
  import 'package:shop/overlay/overlays.dart';
  import 'package:shop/api/endpoint/all_product/produk_item.dart';

  class HomeBloc extends Bloc<HomeEvent, HomeState> {
    HomeBloc() : super(HomeInitial()) {
      on<HomeLoadButton>((event, emit) async {
        emit(HomeLoading());
        try {
          Response response = await ApiManager().getproduck(ApiUrl.produk);
          if (response.statusCode == 200) {
            List<ProductItem> products = (response.data as List)
                .map((item) => ProductItem.fromJson(item))
                .toList();
            emit(HomeLoaded(products));
          } else {
            Overlays.error(
              message: "API call failed with status code ${response.statusCode}",
            );
            emit(HomeError());
          }
        } catch (e, stackTrace) {
          print("Error: $e\nStack trace:\n$stackTrace");
          Overlays.error(
            message: "Ada sesuatu yang salah. Silahkan coba kembali beberapa saat kemudian",
          );
          emit(HomeError());
        }
      });
    }
  }
