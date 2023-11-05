import 'package:scheduler_app/constants.dart';
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
  TextEditingController _origin_controller = TextEditingController();
  TextEditingController _destination_controller = TextEditingController();
  FocusNode _origin_focus = FocusNode();
  FocusNode _destination_focus = FocusNode();
  List<Address> _addresses = [];
  String _token = "";
  Timer? debounce;

  void _debounced_search_address(String query) async {
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
      "email": Constants.oneMapEmail,
      "password": Constants.oneMapPassword
    };

    final response = await http.post(
      Uri.parse(Constants.oneMapAPIUrl),
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
    _origin_controller.dispose();
    _destination_controller.dispose();
    _origin_focus.dispose();
    _destination_focus.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _origin_controller,
              focusNode: _origin_focus,
              onTap: () => _debounced_search_address(_origin_controller.text),
              onChanged: (value) => _debounced_search_address(value),
              decoration: InputDecoration(
                labelText: 'Origin',
                labelStyle: TextStyle(color: Colors.lightBlue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _destination_controller,
              focusNode: _destination_focus,
              onTap: () =>
                  _debounced_search_address(_destination_controller.text),
              onChanged: (value) => _debounced_search_address(value),
              decoration: InputDecoration(
                labelText: 'Destination',
                labelStyle: TextStyle(color: Colors.lightBlue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Offstage(
            offstage: !(_origin_focus.hasFocus || _destination_focus.hasFocus),
            child: BottomSheet(
              enableDrag: false,
              onClosing: () => {},
              builder: (context) => ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                shrinkWrap: true,
                itemCount: _addresses.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_addresses[index].building_name),
                  subtitle: Text(
                      "0.0km | ${_addresses[index].street_address()} | ${_addresses[index].postal_code}"),
                  onTap: () {
                    // update the active text field with the selected address
                    if (_origin_focus.hasFocus) {
                      _origin_controller.text =
                          _addresses[index].street_address();
                      widget.onOriginChanged(_addresses[index]);
                      _debounced_search_address(_destination_controller.text);
                      _origin_focus.unfocus();
                      _destination_focus.requestFocus();
                    } else if (_destination_focus.hasFocus) {
                      _destination_controller.text =
                          _addresses[index].street_address();
                      widget.onDestinationChanged(_addresses[index]);
                      _destination_focus.unfocus();
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
