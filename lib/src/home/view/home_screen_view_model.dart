import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../../../core/util/firebase_remote_config_service/firebase_remote_config_keys.dart';
import '../../../core/util/firebase_remote_config_service/firebase_remote_config_service.dart';
import '../data/models/Product_model.dart';
import '../domain/usecases/home_usecase.dart';

class HomeScreenViewModel {
  final HomeUseCase homeUseCase;

  HomeScreenViewModel({required this.homeUseCase});
  final CarouselController carouselController = CarouselController();
  final GenericCubit<int> carouselIndex = GenericCubit(0);
  GenericCubit<List<ProductModel>> allProductsList = GenericCubit([]);
  GenericCubit<List<ProductModel>> favProductsList = GenericCubit([]);
  GenericCubit<List<ProductModel>> cartList = GenericCubit([]);
  GenericCubit<List<String>> adsList = GenericCubit([]);
  final GenericCubit<bool> enableAdsValue = GenericCubit(false);

  void updateCarouselIndex(int index, CarouselPageChangedReason reason) {
    carouselIndex.onUpdateData(index);
  }

  getProductsList() async {
    allProductsList.onLoadingState();
    try {
      final response = await homeUseCase.call(
        pageNumber: 0,
        pageSize: 18,
      );
      allProductsList.onUpdateData(response);
    } on Failure catch (e) {
      allProductsList.onErrorState(e);
    }
  }

  changeProductFav({required String title}) {
    List<ProductModel> favProducts = [];
    allProductsList.onChangeState();
    favProductsList.onChangeState();
    if (allProductsList.state.data.isNotEmpty) {
      for (var element in allProductsList.state.data) {
        if (element.title == title) {
          element.isFav = !(element.isFav!);
        }
      }
      allProductsList.onUpdateData(allProductsList.state.data);
      for (var element in allProductsList.state.data) {
        if (element.isFav == true) {
          favProducts.add(element);
        }
      }
      favProductsList.onUpdateData(favProducts);
    }
  }

  addProductToCart({required String title}) {
    List<ProductModel> cart = [];
    allProductsList.onChangeState();
    if (allProductsList.state.data.isNotEmpty) {
      for (var element in allProductsList.state.data) {
        if (element.title == title) {
          element.qty = element.qty! + 1;
        }
      }
      allProductsList.onUpdateData(allProductsList.state.data);
      for (var element in allProductsList.state.data) {
        if (element.qty! > 0) {
          cart.add(element);
        }
      }
      cartList.onUpdateData(cart);
    }
  }

  decrementProduct({required String title}) {
    List<ProductModel> cart = [];
    allProductsList.onChangeState();
    if (allProductsList.state.data.isNotEmpty) {
      for (var element in allProductsList.state.data) {
        if (element.title == title) {
          if (element.qty! > 1) {
            element.qty = element.qty! - 1;
          }
        }
      }
      allProductsList.onUpdateData(allProductsList.state.data);
      for (var element in allProductsList.state.data) {
        if (element.qty! > 0) {
          cart.add(element);
        }
      }
      cartList.onUpdateData(cart);
    }
  }

  removeProductFromCart({required String title}) {
    allProductsList.onChangeState();
    for (var element in allProductsList.state.data) {
      if (element.title == title) {
        element.qty = 0;
      }
    }
    allProductsList.onUpdateData(allProductsList.state.data);
    cartList.state.data.removeWhere((element) => element.title == title);
    cartList.onChangeState();
  }

  getAdsList() async {
    adsList.onLoadingState();
    List<String> ads = [];
    try {
      await FirebaseFirestore.instance.collection('ads').get().then((value) {
        for (var element in value.docs) {
          element.data()['adsList'].forEach((e) {
            ads.add(e);
          });
        }
      });
      adsList.onUpdateData(ads);
    } catch (e, s) {
      if (kDebugMode) {
        print(s);
        print('error: ${e.toString()}');
      }
    }
  }

  getEnableAdsValue() {
    enableAdsValue.onLoadingState();
    final showAds =
        FirebaseRemoteConfigService().getBool(FirebaseRemoteConfigKeys.showAds);
    print('hhhhhhhh:$showAds');
    enableAdsValue.onUpdateData(showAds);
  }
}
