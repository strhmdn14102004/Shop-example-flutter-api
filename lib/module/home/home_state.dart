import 'package:shop/api/endpoint/all_product/produk_item.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ProductItem> products;

  HomeLoaded(this.products);
}

class HomeError extends HomeState {}

class HomeFinished extends HomeState {}
