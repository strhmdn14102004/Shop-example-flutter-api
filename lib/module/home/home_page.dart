import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/helper/dimension.dart';
import 'package:shop/module/account/account_page.dart';
import 'package:shop/module/home/home_bloc.dart';
import 'package:shop/module/home/home_event.dart';
import 'package:shop/module/home/home_state.dart';
import 'package:shop/widget/product_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => HomeBloc()..add(HomeLoadButton()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lottie/loading_clock.json",
                      frameRate: const FrameRate(60),
                      width: Dimensions.size100 * 2,
                      repeat: true,
                    ),
                    Text(
                      "Memuat...",
                      style: TextStyle(
                        fontSize: Dimensions.text20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is HomeLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Cari Produk...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          IconButton(
                            icon: const Icon(
                              Icons.filter_list,
                              size: 30,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 2 / 3,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ProductItemWidget(
                                    product: state.products[index]);
                              },
                              childCount: state.products.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is HomeError) {
              return const Center(child: Text('Failed to load products.'));
            } else {
              return const Center(
                  child: Text('Press button to load products.'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountPage()),
          );
        },
        child: const Icon(Icons.person),
      ),
    );
  }
}
