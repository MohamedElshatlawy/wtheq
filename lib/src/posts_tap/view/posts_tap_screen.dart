import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wteq_demo/src/posts_tap/view/posts_tap_view_model.dart';
import 'package:wteq_demo/src/posts_tap/view/widget/post_widget.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../domain/entities/posts_entity.dart';

class PostsTapScreen extends StatefulWidget {
  final PostsTapViewModel viewModel;

  const PostsTapScreen({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<PostsTapScreen> createState() => _PostsTapScreenState();
}

class _PostsTapScreenState extends State<PostsTapScreen> {
  @override
  void initState() {
    widget.viewModel.networkConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            'Posts',
            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                .headingMedium2
                .copyWith(
                  color: AppColors.black,
                ),
          ),
        ),
        body: BlocBuilder<GenericCubit<List<PostEntity>>,
                GenericCubitState<List<PostEntity>>>(
            bloc: widget.viewModel.allPostsList,
            builder: (context, states) {
              if (states is GenericLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              } else if (states is GenericErrorState) {
                return Center(
                  child: Text(
                    'Error',
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .bodyMedium1
                            .copyWith(
                              color: AppColors.red,
                            ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: SmartRefresher(
                      controller: widget.viewModel.scrollController,
                      enablePullUp: true,
                      enablePullDown: true,
                      onRefresh: () {
                        widget.viewModel.onRefresh();
                      },
                      onLoading: () {
                        widget.viewModel.getPostsList();
                      },
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        itemBuilder: (context, index) {
                          return PostWidget(
                            postData: states.data[index],
                            networkConnection:
                                widget.viewModel.networkConnected,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10.h,
                          );
                        },
                        itemCount: states.data.length,
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
