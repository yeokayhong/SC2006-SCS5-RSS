import 'package:scheduler_app/entities/address.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class AddressSearchWidget extends StatefulWidget {
  final Function(Address) onOriginChanged;
  final Function(Address) onDestinationChanged;

  const AddressSearchWidget({
    Key key = const Key('address_search'),
    required this.onOriginChanged,
    required this.onDestinationChanged,
  }) : super(key: key);

  @override
  _AddressSearchWidgetState createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _originFocus = FocusNode();
  final FocusNode _destinationFocus = FocusNode();
  List<Address> _addresses = [];
  String _token = "";
  Timer? debounce;

  void _debouncedSearchAddress(String query) async {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.length < 3) {
        return setState(() {
          _addresses = [];
        });
      }
      _searchAddress(query);
    });
  }

  void _searchAddress(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://developers.onemap.sg/commonapi/search?searchVal=$query&returnGeom=Y&getAddrDetails=Y&pageNum=1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        },
      );

      final Map<String, dynamic> decoded_json = jsonDecode(response.body);
      final List<dynamic> data = decoded_json['results'];
      List<Address> query_results = data
          .map((item) => Address(
              full_address: item['ADDRESS'],
              building_name: item['BUILDING'],
              postal_code: item['POSTAL'],
              latitude: double.parse(item['LATITUDE']),
              longitude: double.parse(item['LONGITUDE'])))
          .toList();

      setState(() {
        _addresses = query_results;
      });
    } catch (error) {
      // notify user of error? bubble to parent?
    }
  }

  void fetchToken() async {
    final Map<String, dynamic> payload = {
      "email": "do_not_commit",
      "password": "do_not_commit"
    };

    final response = await http.post(
      Uri.parse('https://www.onemap.gov.sg/api/auth/post/getToken'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      return print(response.statusCode);
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    setState(() {
      _token = data["access_token"];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _originFocus.dispose();
    _destinationFocus.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_originFocus, _destinationFocus]),
      builder: (context, child) => Stack(children: [
        Visibility(
            visible: _originFocus.hasFocus || _destinationFocus.hasFocus,
            child: Container(
              color: Colors.white,
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Visibility(
                visible: _originFocus.hasFocus || !_destinationFocus.hasFocus,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _originController,
                    focusNode: _originFocus,
                    onTap: () =>
                        _debouncedSearchAddress(_originController.text),
                    onChanged: (value) => _debouncedSearchAddress(value),
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      labelText: 'Origin',
                      labelStyle: const TextStyle(color: Colors.lightBlue),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(
                            color: Colors.lightBlue, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(
                            color: Colors.lightBlue, width: 1.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.95),
                    ),
                  ),
                )),
            Visibility(
              visible: !_originFocus.hasFocus || _destinationFocus.hasFocus,
              child: Padding(
                padding: !_originFocus.hasFocus && _destinationFocus.hasFocus
                    ? const EdgeInsets.all(10)
                    : const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: TextField(
                  controller: _destinationController,
                  focusNode: _destinationFocus,
                  onTap: () =>
                      _debouncedSearchAddress(_destinationController.text),
                  onChanged: (value) => _debouncedSearchAddress(value),
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    labelStyle: const TextStyle(color: Colors.lightBlue),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 1.0),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.95),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: (_originFocus.hasFocus || _destinationFocus.hasFocus),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(_addresses[index].building_name),
                    subtitle: Text(
                        "0.0km | ${_addresses[index].street_address()} | ${_addresses[index].postal_code}"),
                    onTap: () {
                      // update the active text field with the selected address
                      if (_originFocus.hasFocus) {
                        _originController.text =
                            _addresses[index].street_address();
                        widget.onOriginChanged(_addresses[index]);
                        _debouncedSearchAddress(_destinationController.text);
                        _originFocus.unfocus();
                        _destinationFocus.requestFocus();
                      } else if (_destinationFocus.hasFocus) {
                        _destinationController.text =
                            _addresses[index].street_address();
                        widget.onDestinationChanged(_addresses[index]);
                        _destinationFocus.unfocus();
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
