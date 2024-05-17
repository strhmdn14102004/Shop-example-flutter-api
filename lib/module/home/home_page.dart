import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:shop/helper/app_colors.dart";
import "package:shop/helper/dimension.dart";
import "package:shop/module/home/home_bloc.dart";
import "package:shop/module/home/home_state.dart";

class HomePage extends StatefulWidget {
  HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    refresh();
  }

  void refresh() {}

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoading) {
          setState(() {});
        }
      },
      child: Scaffold(
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        appBar: AppBar(
          centerTitle: true,
          title: const Column(
            children: [
              Text("Shop"),
            ],
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            child: Container(),
          ),
        ),
      ),
    );
  }

  Widget listItemShimmer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(Dimensions.size20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Dimensions.size100,
                      height: Dimensions.size10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.size10,
                    ),
                    Container(
                      width: Dimensions.size100 * 2,
                      height: Dimensions.size20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Dimensions.size20,
              ),
              Container(
                width: Dimensions.size80,
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: Dimensions.size100,
                      height: Dimensions.size10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.size10,
                    ),
                    Container(
                      width: Dimensions.size100 * 2,
                      height: Dimensions.size20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Dimensions.size20,
              ),
              Container(
                width: Dimensions.size80,
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: Dimensions.size100,
                      height: Dimensions.size10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.size10,
                    ),
                    Container(
                      width: Dimensions.size100 * 2,
                      height: Dimensions.size20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: Dimensions.size20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Dimensions.size100,
                      height: Dimensions.size10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.size10,
                    ),
                    Container(
                      width: Dimensions.size100 * 2,
                      height: Dimensions.size20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Dimensions.size20,
              ),
              Container(
                width: Dimensions.size80,
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: Dimensions.size100,
                      height: Dimensions.size10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.size10,
                    ),
                    Container(
                      width: Dimensions.size100 * 2,
                      height: Dimensions.size20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.size5),
                        color: AppColors.background(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
