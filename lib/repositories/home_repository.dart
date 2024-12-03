import 'package:depd_rajaongkir/data/network/network_api_services.dart';
import 'package:depd_rajaongkir/models/model.dart';

class HomeRepository {
  final _apiServices = NetworkApiServices();

  // Fetch list of provinces
  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/province');
      List<Province> result = [];
      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      }
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> fetchCost(
      {required String origin,
      required String destination,
      required int weight,
      required String courier}) async {
    try {
      // Mengirimkan request POST dengan body
      dynamic response = await _apiServices.postApiResponse('/starter/cost', {
        'origin': origin,
        'destination': destination,
        'weight': weight,
        'courier': courier,
      });

      if (response['rajaongkir']['status']['code'] == 200) {
        List<dynamic> results = response['rajaongkir']['results'];
        List<Costs> costs = results
            .expand((result) => (result['costs'] as List)
                .map((cost) => Costs.fromJson(cost as Map<String, dynamic>)))
            .toList();
        return costs;
        // return response['rajaongkir']['results'];
      } else {
        throw Exception(
            "Invalid status code: ${response['rajaongkir']['status']['code']}");
      }
    } catch (e) {
      print("Error fetching cost: $e");
      throw e;
    }
  }

  Future<List<City>> fetchCityList(var provId) async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/city');
      List<City> result = [];
      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => City.fromJson(e))
            .toList();
      }
      List<City> selectedCities = [];
      for (var c in result) {
        if (c.provinceId == provId) {
          selectedCities.add(c);
        }
      }
      return selectedCities;
    } catch (e) {
      throw e;
    }
  }

  // Fetch list of couriers (optional)
  Future<List<String>> fetchCourierList() async {
    try {
      // Replace with actual API endpoint if couriers are fetched dynamically
      dynamic response = await _apiServices.getApiResponse('/starter/couriers');
      List<String> result = [];
      if (response['statusCode'] == 200) {
        result = (response['data'] as List).map((e) => e.toString()).toList();
      }
      return result;
    } catch (e) {
      throw e;
    }
  }
}
