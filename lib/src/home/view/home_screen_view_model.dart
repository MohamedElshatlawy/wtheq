import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../../../core/components/app_alert_dialog/app_alert_dialog.dart';
import '../../../core/util/firebase_remote_config_service/firebase_remote_config_keys.dart';
import '../../../core/util/firebase_remote_config_service/firebase_remote_config_service.dart';
import '../../../core/util/network/network_info.dart';
import '../../../core/util/sql_service/sql_service.dart';
import '../data/models/Product_model.dart';
import '../domain/usecases/home_usecase.dart';

class HomeScreenViewModel {
  final HomeUseCase homeUseCase;
  final NetworkInfo networkInfo;

  HomeScreenViewModel({required this.homeUseCase, required this.networkInfo});

  SqlService? dbInstance;

  final CarouselController carouselController = CarouselController();
  final GenericCubit<int> carouselIndex = GenericCubit(0);
  GenericCubit<List<ProductModel>> allProductsList = GenericCubit([]);
  GenericCubit<List<ProductModel>> favProductsList = GenericCubit([]);
  GenericCubit<List<ProductModel>> cartList = GenericCubit([]);
  GenericCubit<List<String>> adsList = GenericCubit([]);
  GenericCubit<bool> enableAdsValue = GenericCubit(false);

  void updateCarouselIndex(int index, CarouselPageChangedReason reason) {
    carouselIndex.onUpdateData(index);
  }

  init() async {
    await setupDb();
    await getFavProduct();
    await getProductsList();
  }

  Future<void> setupDb() async {
    dbInstance = await SqlService.getInstance();
  }

  getProductsList() async {
    List<ProductModel> allProducts = [];
    List<String> title = [];
    if (await networkInfo.isConnected) {
      allProductsList.onLoadingState();
      try {
        final response = await homeUseCase.call(
          pageNumber: 0,
          pageSize: 500,
        );
        for (var element in response) {
          if (!title.contains(element.title)) {
            title.add(element.title ?? '');
            allProducts.add(element);
          }
        }
        if (favProductsList.state.data.isNotEmpty) {
          title = [];
          for (var element in favProductsList.state.data) {
            title.add(element.title ?? '');
          }
          for (var e in allProducts) {
            if (title.contains(e.title)) {
              e.isFav = 1;
            }
          }
        }
        allProductsList.onUpdateData(allProducts);
      } on Failure catch (e) {
        allProductsList.onErrorState(e);
      }
    } else {
      allProductsList.onConnectionError();
    }
  }

  changeProductFav({required String title}) async {
    List<ProductModel> favProducts = [];
    allProductsList.onChangeState();
    favProductsList.onChangeState();
    if (allProductsList.state.data.isNotEmpty) {
      for (var element in allProductsList.state.data) {
        if (element.title == title) {
          if (element.isFav == 0) {
            element.isFav = 1;
            File imageFile = await getFileFromNetworkImage(element.thumb ?? '');
            dbInstance!.insertProduct(
              productModel: ProductModel(
                internalName: element.internalName,
                title: element.title,
                salePrice: element.salePrice,
                normalPrice: element.normalPrice,
                steamRatingCount: element.steamRatingCount,
                thumb: imageFile.path,
                isFav: 1,
                qty: element.qty,
              ),
            );
          } else {
            element.isFav = 0;
            dbInstance!.deleteProduct(element.title ?? '');
          }
        }
      }
      allProductsList.onUpdateData(allProductsList.state.data);
      favProducts = await dbInstance!.loadSavedProduct();
      favProductsList.onUpdateData(favProducts);
    }
  }

  Future<File> getFileFromNetworkImage(String imageUrl) async {
    Uint8List bytes =
        (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
            .buffer
            .asUint8List();

    final documentDirectory = await getApplicationDocumentsDirectory();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    File file = File(path.join(documentDirectory.path, '$fileName.png'));
    file.writeAsBytes(bytes);
    return file;
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

  connectionChecker({required BuildContext context}) async {
    if (!await networkInfo.isConnected) {
      if (context.mounted) {
        await AppAlertDialog().showInternetConnectionDialog(
          context: context,
          title: 'No Internet Connection Available\nPlease Retry Again',
        );
      }
    }
  }

  getFavProduct() async {
    List<ProductModel> favProducts = [];
    favProductsList.onChangeState();
    await dbInstance!.loadSavedProduct().then((value) {
      for (final element in value) {
        final ProductModel product = ProductModel(
          internalName: element.internalName,
          title: element.title,
          salePrice: element.salePrice,
          normalPrice: element.normalPrice,
          steamRatingCount: element.steamRatingCount,
          thumb: element.thumb,
          isFav: 1,
          qty: element.qty,
        );
        favProducts.add(product);
      }
    });
    favProductsList.onUpdateData(favProducts);
  }
}
