import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/service/user_service.dart';

class ChangeEdtitPersonalView extends StatefulWidget {
  final UserModel event;
  const ChangeEdtitPersonalView({super.key, required this.event});

  @override
  State<ChangeEdtitPersonalView> createState() =>
      _ChangeEdtitPersonalViewState();
}

class _ChangeEdtitPersonalViewState extends State<ChangeEdtitPersonalView> {
  final usernameController = TextEditingController();
  String? erorr;
  final eventService = UserService();
  @override
  void initState() {
    super.initState();
    usernameController.text = widget.event.username;
  }
void _resetEroor(){
  setState(() {
    erorr=null;
  });
}
  Future<void> editusername() async {
    List<UserModel> items = [];
    items = await eventService.getAllUser();
    if (items.any((e) => e.username == usernameController.text)) {
      setState(() {
        erorr = 'username already exists';
      });
      
    } else if (usernameController.text=='') {
      setState(() {
        erorr = 'Please fill in all information!';
      });
      
    }
    else if(widget.event.username == usernameController.text){
 setState(() {
        erorr = 'Please choose a newer username';
      });
    }else{
  widget.event.username = usernameController.text;
    await eventService.saveEvent(widget.event);
    if (!mounted) return;
    Navigator.of(context).pop(true);
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Stack(
            children: [
              AnimatedPositioned(
                top: 15,
                left: -6,
                duration: const Duration(seconds: 0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Icon(
                      Icons.chevron_left_outlined,
                      applyTextScaling: false,
                    )),
              )
            ],
          ),
          title: const Center(child: Text('Edit personal page')),
          actions: [
            GestureDetector(
              onTap: editusername,
              child: const Text(
                'Finished',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(0.8),
            child: Column(children: [
              Container(
                  decoration:  BoxDecoration(
                    border: Border(
                        top: const BorderSide(width: 1, color: Colors.grey),
                   bottom: erorr==null ?const BorderSide(width: 0): const BorderSide(width: 1, color: Colors.grey) ),
                  ),
                  child: TextField(
                    controller: usernameController,
                    decoration:  InputDecoration(
                      label:const Text('Enter Username'),
                      enabledBorder: InputBorder.none,
                      errorText:erorr
                    ),
                    onChanged: (text){_resetEroor();} ,
                  ))
            ])));
  }
}
