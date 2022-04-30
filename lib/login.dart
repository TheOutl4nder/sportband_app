import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sportband_app/sessionPage.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email']
);

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? _account;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) { 
      setState(() {
        _account = account;
      });
    });
    //_googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _buildWidget(),
    );
  }

  Widget _buildWidget(){
    GoogleSignInAccount? user = _account;
    Future.delayed(Duration.zero,(){
      if(user!=null){
        transitionToSession();
        return Container();
      }
    });
    return ListView(children: [
          Row(children: [Icon(Icons.sports_baseball,size: 128,color: Theme.of(context).primaryColor,)], mainAxisAlignment: MainAxisAlignment.center, ),
          Row(children: [Text("Sport Band App",style: TextStyle(color: Color(0xFFD2D7DB),fontSize: 20,),)], mainAxisAlignment: MainAxisAlignment.center,),
          Row(children: [Container(height: 36,)],),
          Row(children: [Text("Sign In:",style: TextStyle(color: Colors.black,fontSize: 24,))],),
          Row(children: [Container(height: 18,)],),
          Row(children: [Text("Hi there! Nice to see you again.",style: TextStyle(color: Color(0xFFD2D7DB),fontSize: 20,),)],),
          Row(children: [Container(height: 36,)],),
          Row(children: [MaterialButton(onPressed: signIn,child: Text("Sign In with Google",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18),),)],mainAxisAlignment: MainAxisAlignment.center,)
        ],padding: EdgeInsets.all(40.0),);
  }

  transitionToSession(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SessionPage()));
  }

  void SignOut(){
    _googleSignIn.disconnect();
  }

  Future<void> signIn() async {
    try{
      await _googleSignIn.signIn();
    }
    catch (e){
      print(e);
    }
  }
}

