import 'package:get/get.dart';
import 'package:myprojectshop/core/env.dart';
import 'package:myprojectshop/data/repositories/api_repository.dart';
import 'package:myprojectshop/data/repositories/firebase_repository.dart';
import 'package:myprojectshop/data/repositories/i_base_repository.dart';

enum DataSource { Firebase, FakeStore, Laravel }

class AppConfig extends GetxService {
  static AppConfig get to => Get.find();

  // Observable to trigger UI updates if needed
  final Rx<DataSource> currentDataSource = DataSource.Firebase.obs;

  late IBaseRepository _repository;

  IBaseRepository get repository => _repository;

  @override
  void onInit() {
    super.onInit();
    _initRepository();
  }

  void _initRepository() {
    // Default to Laravel (changed from Firebase)
    _repository = ApiRepository(
      baseUrl: Env.laravelBaseUrl,
      type: DataSource.Laravel,
    );
    currentDataSource.value = DataSource.Laravel;
    currentDataSource.value = DataSource.FakeStore;

  }

  void switchDataSource(DataSource source) {
    // Update repository FIRST
    switch (source) {
      case DataSource.Firebase:
        _repository = FirebaseRepository();
        break;
      case DataSource.FakeStore:
        _repository = ApiRepository(
          baseUrl: Env.fakeStoreBaseUrl,
          type: DataSource.FakeStore,
        );
        break;
      case DataSource.Laravel:
        _repository = ApiRepository(
          baseUrl: Env.laravelBaseUrl,
          type: DataSource.Laravel,
        );
        break;
    }

    // Then notify listeners
    currentDataSource.value = source;

    print("Switched Data Source to: $source");
  }

  bool get isApiMode =>
      currentDataSource.value == DataSource.FakeStore ||
      currentDataSource.value == DataSource.Laravel;
}
