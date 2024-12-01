import 'package:flutter/material.dart';
import 'package:depd_rajaongkir/data/response/api_response.dart';
import 'package:depd_rajaongkir/models/model.dart';
import 'package:depd_rajaongkir/repositories/home_repository.dart';

class HomeViewmodel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  // Province List State
  ApiResponse<List<Province>> provinceList = ApiResponse.loading();
  void setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  Future<void> getProvinceList() async {
    setProvinceList(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }

  // City List State
  ApiResponse<List<City>> cityList = ApiResponse.loading();
  void setCityList(ApiResponse<List<City>> response) {
    cityList = response;
    notifyListeners();
  }

  Future<void> getCityList(String provinceId) async {
    setCityList(ApiResponse.loading());
    _homeRepo.fetchCityList(provinceId).then((value) {
      setCityList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityList(ApiResponse.error(error.toString()));
    });
  }

  // Courier List State (if dynamic)
  ApiResponse<List<String>> courierList = ApiResponse.loading();
  void setCourierList(ApiResponse<List<String>> response) {
    courierList = response;
    notifyListeners();
  }

  Future<void> getCourierList() async {
    setCourierList(ApiResponse.loading());
    _homeRepo.fetchCourierList().then((value) {
      setCourierList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCourierList(ApiResponse.error(error.toString()));
    });
  }
}
