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
                        return DropdownButton(
                            isExpanded: true,
                            value: selectedProvinceId,
                            icon: const Icon(Icons.arrow_drop_down),
                            hint: Text('Pilih Provinsi'),
                            items: value.provinceList.data!
                                .map<DropdownMenuItem<Province>>(
                                    (Province value) {
                              return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.province.toString()));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedProvinceId = newValue;
                                selectedCityId = null;
                              });
                              if (newValue != null) {
                                homeViewmodel
                                    .getCityList(selectedProvinceId.provinceId);
                              }
                            });
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
                        return DropdownButton(
                            isExpanded: true,
                            value: selectedCityId,
                            icon: const Icon(Icons.arrow_drop_down),
                            hint: Text('Pilih Kota'),
                            items: value.cityList.data!
                                .map<DropdownMenuItem<City>>((City value) {
                              return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.cityName.toString()));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCityId = newValue;
                              });
                            });
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
                        return DropdownButton(
                            isExpanded: true,
                            value: selectedProvinceToId,
                            icon: const Icon(Icons.arrow_drop_down),
                            hint: Text('Pilih Provinsi'),
                            items: value.provinceList.data!
                                .map<DropdownMenuItem<Province>>(
                                    (Province value) {
                              return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.province.toString()));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedProvinceToId = newValue;
                                selectedCityToId = null;
                              });
                              if (newValue != null) {
                                homeViewmodel.getCityToList(
                                    selectedProvinceToId.provinceId);
                              }
                            });
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
                        return DropdownButton(
                            isExpanded: true,
                            value: selectedCityToId,
                            icon: const Icon(Icons.arrow_drop_down),
                            hint: Text('Pilih Kota'),
                            items: value.cityToList.data!
                                .map<DropdownMenuItem<City>>((City value) {
                              return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.cityName.toString()));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCityToId = newValue;
                              });
                            });
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
                          selectedCityId != null &&
                          selectedProvinceToId != null &&
                          selectedCityToId != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Memulai pengecekan harga...'),
                        ));
                        homeViewmodel.getCost(
                          selectedCityId.cityId.toString(),
                          selectedCityToId.cityId.toString(),
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

                const SizedBox(height: 16),

                Consumer<HomeViewmodel>(
                  builder: (context, value, _) {
                    if (value.costList.status == Status.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (value.costList.status == Status.error) {
                      return Center(
                          child: Text('Error: ${value.costList.message}'));
                    } else if (value.costList.status == Status.completed) {
                      final costData =
                          value.costList.data; // Get the List<Costs>

                      if (costData != null && costData.isNotEmpty) {
                        return Column(
                          children: costData.map((costs) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(costs.service.toString() ?? "Invalid"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Supaya teks rata kiri
                                  children: [
                                    Text(
                                        'Description: ${costs.description ?? '-'}'),
                                    Text('Cost: ${costs.cost![0].value ?? 0}'),
                                    Text(
                                        'Estimated day: ${costs.cost![0].etd ?? ''}'),
                                    Text('Note: ${costs.cost![0].note ?? '-'}'),
                                    // Tambahkan subtitle lainnya sesuai kebutuhan
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text("No costs available.");
                      }
                    } else {
                      return Container(); // This handles any other unknown state
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
