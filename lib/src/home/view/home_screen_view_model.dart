import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../../../core/util/network/network_info.dart';
import '../../../core/util/sql_service/sql_service.dart';
import '../data/models/Product_model.dart';
import '../domain/usecases/home_usecase.dart';

class HomeScreenViewModel {
  final HomeUseCase homeUseCase;
  final NetworkInfo networkInfo;

  HomeScreenViewModel({required this.homeUseCase, required this.networkInfo});

  SqlService? dbInstance;

  GenericCubit<List<ProductModel>> allProductsList = GenericCubit([]);
  GenericCubit<List<ProductModel>> favProductsList = GenericCubit([]);

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
