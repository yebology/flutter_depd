part of 'pages.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  HomeViewmodel homeViewmodel = HomeViewmodel();

  @override
  void initState() {
    homeViewmodel.getProvinceList();
    super.initState();
  }

  dynamic selectedDataProvince;
  dynamic selectedProvinceId;
  dynamic selectedDataCity;
  dynamic selectedCityId;
  String? selectedCourier;

  // Daftar kurir
  final List<String> courierList = ['pos', 'tiki', 'sicepat', 'jne', 'lion'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Calculate Cost"),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeViewmodel>(
        create: (BuildContext context) => homeViewmodel,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label untuk Kurir
                        Text(
                          "Kurir Pilihan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Dropdown list for Courier
                        DropdownButton<String>(
                          isExpanded: true,
                          value: selectedCourier,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 2,
                          hint: Text('Pilih kurir'),
                          style: TextStyle(color: Colors.black),
                          items: courierList
                              .map<DropdownMenuItem<String>>((String courier) {
                            return DropdownMenuItem<String>(
                              value: courier,
                              child: Text(courier.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCourier = newValue;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        // Label untuk Provinsi
                        Text(
                          "Provinsi Pilihan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Dropdown list for Province
                        Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.provinceList.status) {
                              case Status.loading:
                                return Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                );
                              case Status.error:
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      value.provinceList.message.toString()),
                                );
                              case Status.completed:
                                return DropdownButton<Province>(
                                  isExpanded: true,
                                  value: selectedProvinceId,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 30,
                                  elevation: 2,
                                  hint: Text('Pilih provinsi'),
                                  style: TextStyle(color: Colors.black),
                                  items: value.provinceList.data!
                                      .map<DropdownMenuItem<Province>>(
                                          (Province province) {
                                    return DropdownMenuItem<Province>(
                                      value: province,
                                      child: Text(province.province.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedProvinceId = newValue;
                                      selectedCityId =
                                          null; // Reset selected city
                                    });
                                    // Pastikan provinceId tidak null sebelum memanggil getCityList
                                    if (newValue?.provinceId != null) {
                                      homeViewmodel.getCityList(newValue!
                                          .provinceId!); // Gunakan '!' untuk memastikan tidak null
                                    }
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        // Label untuk Kota
                        Text(
                          "Kota Pilihan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Dropdown list for City
                        Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.cityList.status) {
                              case Status.loading:
                                return Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                );
                              case Status.error:
                                return Align(
                                  alignment: Alignment.center,
                                  child:
                                      Text(value.cityList.message.toString()),
                                );
                              case Status.completed:
                                return DropdownButton<City>(
                                  isExpanded: true,
                                  value: selectedCityId,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 30,
                                  elevation: 2,
                                  hint: Text('Pilih kota'),
                                  style: TextStyle(color: Colors.black),
                                  items: value.cityList.data!
                                      .map<DropdownMenuItem<City>>((City city) {
                                    return DropdownMenuItem<City>(
                                      value: city,
                                      child: Text(city.cityName.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedCityId = newValue;
                                    });
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        // Button Cek Harga
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Implementasikan logika untuk cek harga di sini
                              if (selectedCourier != null &&
                                  selectedProvinceId != null &&
                                  selectedCityId != null) {
                                // Lakukan tindakan (misalnya panggil API)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Memulai pengecekan harga...'),
                                  ),
                                );
                              } else {
                                // Tampilkan peringatan jika input belum lengkap
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Mohon lengkapi semua pilihan terlebih dahulu!'),
                                  ),
                                );
                              }
                            },
                            child: Text('Cek Harga'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
