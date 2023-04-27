import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapy/features/map_view/presentation/viewModel/viewMap/view_map_cubit.dart';
import 'package:nil/nil.dart';
import '../../viewModel/view_places/view_places_cubit.dart';

class SearchResultView extends StatelessWidget {

  final TextEditingController textEditingController;
  const SearchResultView({Key? key,required this.textEditingController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
    top: size.height*0.11
    ,child: BlocBuilder<ViewPlacesCubit, ViewPlacesState>(
    builder: (context,state){
      if(state is ViewPlacesLoaded){
        return SizedBox(
          height: size.height*0.35,
          width: 380,
          child: ListView.separated(itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.only(right: 16.0,left: 16.0),
              child: InkWell(
                onTap: ()async{
                  textEditingController.clear();
                  await BlocProvider.of<ViewPlacesCubit>(context).searchLocationByName("");
                  await BlocProvider.of<ViewMapCubit>(context).getLocationByPlaceId(state.predictions[index]);
                },
                child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 40,
                    decoration: BoxDecoration(color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Text(state.predictions[index].description.toString(),style: const TextStyle(color: Colors.white),)),
              ),
            );
          },itemCount: state.predictions.length,
            separatorBuilder: (context,index){
              return const SizedBox(height: 12,);
            },
          ),
        );
      }else{
        return const SizedBox(height: 0,width: 0,);
      }
    }),
    );
  }
}