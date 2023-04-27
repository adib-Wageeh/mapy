import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapy/features/map_view/presentation/viewModel/view_places/view_places_cubit.dart';

class SearchContainer extends StatelessWidget {

  final TextEditingController textEditingController;

  const SearchContainer({Key? key, required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height*0.06,
      left: size.width*0.06,
      child: Align(
        alignment: Alignment.center,
        child: AnimSearchBar(
          width: size.width-((size.width*0.06)*2),
          closeSearchOnSuffixTap: true,
          color: Colors.deepPurpleAccent,
          textFieldIconColor: Colors.white,
          toogler: true,
          rtl: true,
          boxShadow: true,
          searchIconColor: Colors.white,
          textController: textEditingController,
          onSuffixTap: () {
            textEditingController.clear();
          },
          onSubmitted: (ss) {
          },
          onChanged: (text) async{
              await BlocProvider.of<ViewPlacesCubit>(context)
                  .searchLocationByName(text);
          },
        ),
      ),
    );
  }
}