import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapy/features/map_view/presentation/viewModel/view_places/view_places_cubit.dart';
GlobalKey myKey = GlobalKey();
class SearchContainer extends StatefulWidget {

  final TextEditingController textEditingController;
  const SearchContainer({Key? key,required this.textEditingController}) : super(key: key);

  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 25,
      left: 25,
      child: AnimSearchBar(
        width: 340,
        closeSearchOnSuffixTap: true,
        color: Colors.deepPurpleAccent,
        textFieldIconColor: Colors.white,
        toogler: true,
        rtl: true,
        boxShadow: true,
        searchIconColor: Colors.white,
        textController: widget.textEditingController,
        onSuffixTap: () {
            widget.textEditingController.clear();
        }, onSubmitted: (ss){

      },
        onChanged: (text){
          if(text.isEmpty){
            setState(() {

            });
          }
          BlocProvider.of<ViewPlacesCubit>(context).searchLocationByName(text);
        },
      ),
    );
  }
}

