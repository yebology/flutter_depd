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
  dynamic selectedCourier;

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
                      children: [
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
                                    });
                                    // Ensure provinceId is not null before calling getCityList
                                    if (newValue?.provinceId != null) {
                                      homeViewmodel.getCityList(newValue!
                                          .provinceId!); // Use '!' to assert it's not null
                                    }
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
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
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
