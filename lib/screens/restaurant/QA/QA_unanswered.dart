import 'package:flutter/material.dart';
import 'package:jkmapp/services/QA/QA_service.dart';

class UnansweredQuestionsPage extends StatefulWidget {
  @override
  _UnansweredQuestionsPageState createState() => _UnansweredQuestionsPageState();
}

class _UnansweredQuestionsPageState extends State<UnansweredQuestionsPage> {
   List<Map<String,dynamic>> unansweredQuestions = [];
   @override
  void initState(){
      super.initState();
      loadUnansweredQuestions(); //初始化加載
   }
   //加載問題的表
   Future<void>loadUnansweredQuestions()async{
     try{
        final data =await QAService.fetchUnanswered();
        setState(() {
            unansweredQuestions=data;
        });
     }catch(e){
        print("加載失敗:$e");
        setState(() {
            unansweredQuestions=[];//清空列表
        });
     }
   }
   @override
   Widget build(BuildContext context){
      return Scaffold(
         appBar: AppBar(
            title:Text("未解答的問題"),
         ),
        body: unansweredQuestions.isEmpty
           ? Center(
             child:Text("目前沒有未解答的問題"),
           )
          :ListView.builder(
             itemCount: unansweredQuestions.length,
             itemBuilder: (context,index){
               final question =unansweredQuestions[index];
               return ListTile(
                 title:Text(question['question']),
                 subtitle: Text("出現次數:${question['count']}"),
               );
            }
        )
      );
   }
}