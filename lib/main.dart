import 'package:flutter/material.dart';
import 'package:sristi_bill_checker/user.dart';
import 'package:sristi_bill_checker/user_sheets_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSheetsApi.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sristi Bill Checker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: const TextTheme().copyWith(
            bodyMedium: const TextStyle().copyWith(
                fontFamily: 'Harry', fontSize: 20, color: Colors.amber)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _name = '',
      _billNo = '',
      _contact = '',
      _tshirt = '',
      _year = '',
      _dept = '';
  int? _paidAmount;
  bool _tshirtRecieved = false, _idRecieved = false;
  bool loading = false;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future<void> _fetchData() async {
    loading = true;
    setState(() {});
    User? user = await UserSheetsApi.getByBill(int.tryParse(_billNo));
    if (user == null) return;
    _name = user.name;
    _tshirt = user.tshirt;
    _contact = user.contact;
    _year = user.year;
    _dept = user.department;
    _paidAmount = user.amountPaid;
    _tshirtRecieved = user.tshirtRecieved;
    _idRecieved = user.idRecieved;
    loading = false;
    setState(() {});
  }

  Future<void> _saveData() async {
    loading = true;
    setState(() {});
    UserSheetsApi.updateTshirt(int.tryParse(_billNo), _tshirtRecieved);
    UserSheetsApi.updateID(int.tryParse(_billNo), _idRecieved);
    loading = false;
    setState(() {});
  }

  void _reset() {
    _name = '';
    _billNo = '';
    _tshirt = '';
    _year = '';
    _dept = '';
    _paidAmount = null;
    _tshirtRecieved = false;
    _idRecieved = false;
    loading = false;
    _controller.text = '';
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset(
          'assets/images/background2.jpg',
          fit: BoxFit.fitWidth,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text(
          'Sristi Bill Checker',
          style: TextStyle(
            fontFamily: 'Harry',
            color: Colors.red,
            shadows: [
              Shadow(blurRadius: 50, color: Colors.blue),
              Shadow(
                blurRadius: 20,
                color: Colors.blue,
                offset: Offset(5, 5),
              ),
              Shadow(
                blurRadius: 20,
                color: Colors.blue,
                offset: Offset(-5, 5),
              ),
              Shadow(
                blurRadius: 20,
                color: Colors.blue,
                offset: Offset(5, -5),
              ),
              Shadow(
                blurRadius: 20,
                color: Colors.blue,
                offset: Offset(-5, -5),
              ),
            ],
          ),
        ),
        elevation: 50,
      ),
      body: Stack(children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.5,
            child: Container(
              color: const Color(0xFF000000),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: SizedBox(
              width: (500 < MediaQuery.sizeOf(context).width - 100)
                  ? 500
                  : MediaQuery.sizeOf(context).width - 100,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Form(
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              label: Text('Bill No.',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              int? val = int.tryParse(value ?? '0');
                              if (val == null || val <= 0 || val > 400) {
                                return 'Enter a valid value';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FilledButton(
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  setState(() {
                                    _billNo = _controller.text;
                                  });
                                  _fetchData();
                                }
                              },
                              child: (loading)
                                  ? const SizedBox.square(
                                      dimension: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.amber,
                                      ))
                                  : const Text('Search'))
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text('Name : '),
                      Text(
                        _name,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Bill No : '),
                      Text(_billNo, style: const TextStyle(color: Colors.white))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Contact : '),
                      Text(_contact, style: const TextStyle(color: Colors.white))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Year : '),
                      Text(_year, style: const TextStyle(color: Colors.white))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Department : '),
                      Text(_dept, style: const TextStyle(color: Colors.white))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('T-shirt Size : '),
                      Text(_tshirt, style: const TextStyle(color: Colors.white))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Paid :'),
                      Text(
                        (_paidAmount != null)
                            ? ((_paidAmount! >= 900)
                                ? '✅ Paid'
                                : '❌ Rs.$_paidAmount ❌')
                            : '',
                        style: const TextStyle().copyWith(
                            color: (_paidAmount == null || _paidAmount! >= 900)
                                ? Colors.green
                                : Colors.red),
                      )
                    ],
                  ),
                  SwitchListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      UserFields.tshirtRecieved,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    value: _tshirtRecieved,
                    onChanged: (value) {
                      setState(() {
                        _tshirtRecieved = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      UserFields.idRecieved,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    value: _idRecieved,
                    onChanged: (value) {
                      setState(() {
                        _idRecieved = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FilledButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          _saveData();
                        }
                      },
                      child: const Text('Save')),
                ],
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _reset,
        tooltip: 'Clear',
        child: const Icon(Icons.clear),
      ),
    );
  }
}
