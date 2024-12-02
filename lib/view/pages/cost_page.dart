part of 'pages.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});
  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  final HomeViewmodel homeViewmodel = HomeViewmodel();
  final TextEditingController _weightController = TextEditingController();

  dynamic selectedProvinceId;
  dynamic selectedCityId;
  dynamic selectedProvinceToId;
  dynamic selectedCityToId;
  String? selectedCourier;

  final List<String> courierList = ['pos', 'tiki', 'jne'];

  @override
  void initState() {
    homeViewmodel.getProvinceList();
    super.initState();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Calculate Cost"),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeViewmodel>(
        create: (_) => homeViewmodel,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Courier Dropdown
                const Text(
                  "Kurir Pilihan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedCourier,
                  icon: const Icon(Icons.arrow_drop_down),
                  hint: const Text('Pilih kurir'),
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
                const SizedBox(height: 16),

                // Weight Input
                const Text(
                  "Berat barang dalam gram",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter weight (grams)",
                    border: OutlineInputBorder(),
                    suffixText: "grams",
                  ),
                ),
                const SizedBox(height: 16),

                // Province Dropdown
                const Text(
                  "Provinsi Asal",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
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
                          child: Text(value.provinceList.message.toString()),
                        );
                      case Status.completed:
                        return _buildDropdown<Province>(
                          dataList: value.provinceList.data,
                          selectedItem: selectedProvinceId,
                          onChanged: (newValue) {
                            setState(() {
                              selectedProvinceId = newValue;
                              selectedCityId = null;
                            });
                            if (newValue?.provinceId != null) {
                              homeViewmodel.getCityList(newValue!.provinceId!);
                            }
                          },
                          hint: 'Pilih provinsi',
                        );
                      default:
                        return Container();
                    }
                  },
                ),
                const SizedBox(height: 16),

                // City Dropdown
                const Text(
                  "Kota Asal",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
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
                          child: Text(value.cityList.message.toString()),
                        );
                      case Status.completed:
                        return _buildDropdown<City>(
                          dataList: value.cityList.data,
                          selectedItem: selectedCityId,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCityId = newValue;
                            });
                          },
                          hint: 'Pilih kota',
                        );
                      default:
                        return Container();
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Destination Province and City
                const Text(
                  "Provinsi Tujuan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
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
                          child: Text(value.provinceList.message.toString()),
                        );
                      case Status.completed:
                        return _buildDropdown<Province>(
                          dataList: value.provinceList.data,
                          selectedItem: selectedProvinceToId,
                          onChanged: (newValue) {
                            setState(() {
                              selectedProvinceToId = newValue;
                              selectedCityToId = null;
                            });
                            if (newValue?.provinceId != null) {
                              homeViewmodel
                                  .getCityToList(newValue!.provinceId!);
                            }
                          },
                          hint: 'Pilih provinsi tujuan',
                        );
                      default:
                        return Container();
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Kota Tujuan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<HomeViewmodel>(
                  builder: (context, value, _) {
                    switch (value.cityToList.status) {
                      case Status.loading:
                        return Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      case Status.error:
                        return Align(
                          alignment: Alignment.center,
                          child: Text(value.cityToList.message.toString()),
                        );
                      case Status.completed:
                        return _buildDropdown<City>(
                          dataList: value.cityToList.data,
                          selectedItem: selectedCityToId,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCityToId = newValue;
                            });
                          },
                          hint: 'Pilih kota tujuan',
                        );
                      default:
                        return Container();
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Check Cost Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedCourier != null &&
                          selectedProvinceId != null &&
                          selectedCityId != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Memulai pengecekan harga...'),
                        ));
                        homeViewmodel.getCost(
                          selectedCityId.cityId,
                          selectedCityToId.cityId,
                          int.tryParse(_weightController.text.trim()) ?? 0,
                          selectedCourier!,
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Mohon lengkapi semua pilihan terlebih dahulu!'),
                        ));
                      }
                    },
                    child: const Text('Cek Harga'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required List<T>? dataList,
    required T? selectedItem,
    required Function(T?) onChanged,
    required String hint,
  }) {
    if (dataList == null) {
      return const CircularProgressIndicator();
    }
    return DropdownButton<T>(
      isExpanded: true,
      value: selectedItem,
      icon: const Icon(Icons.arrow_drop_down),
      hint: Text(hint),
      items: dataList.map<DropdownMenuItem<T>>((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
