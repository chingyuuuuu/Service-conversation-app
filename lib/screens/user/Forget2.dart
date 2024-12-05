import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forget3.dart';
import 'package:jkmapp/providers/user/Forget_provider.dart';

class Forget2 extends StatefulWidget {
  const Forget2({Key? key}) : super(key: key);

  @override
  _Forget2State createState() => _Forget2State();
}

class _Forget2State extends State<Forget2> {
  late ForgetProvider forgetProvider;

  @override
  void initState() {
    super.initState();
    // 加载 email
    final forgetProvider = Provider.of<ForgetProvider>(context,listen:false);
    forgetProvider.loadEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer<ForgetProvider>(
        builder: (context, forgetProvider, child) {
          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Service',
                    style: TextStyle(
                      fontSize: 120,
                      fontFamily: 'Kapakana',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF223888),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      '驗證',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: forgetProvider.verifyController,
                      decoration: const InputDecoration(
                        labelText: '驗證碼',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (forgetProvider.message.isNotEmpty)
                      Text(
                        forgetProvider.message,
                        style: TextStyle(
                          color: forgetProvider.message.startsWith('驗證成功') ? Colors.green : Colors.red,
                        ),
                      ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '已經傳送驗證碼',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: forgetProvider.isSubmitting
                            ? null
                            : () async {
                          await forgetProvider.verifyCode(
                            context,
                                () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Forget3()),
                            ),
                          );
                        },
                        child: forgetProvider.isSubmitting
                            ? const CircularProgressIndicator()
                            : const Text('確認'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF36FDE6),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(80, 50),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
