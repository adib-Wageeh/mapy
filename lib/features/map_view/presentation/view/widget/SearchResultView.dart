import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapy/features/map_view/presentation/viewModel/viewMap/view_map_cubit.dart';
import '../../viewModel/view_places/view_places_cubit.dart';

class SearchResultView extends StatelessWidget {

  final TextEditingController textEditingController;
  const SearchResultView({Key? key,required this.textEditingController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
    top: 70
    ,child: Center(
        child: BlocBuilder<ViewPlacesCubit, ViewPlacesState>(
        builder: (context,state){
          if(state is ViewPlacesLoaded){
            return SizedBox(
              height: 400,
              width: 380,
              child: ListView.separated(itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 12),
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
                  return const SizedBox(height: 5,);
                },
              ),
            );
          }else if(state is ViewPlacesLoading) {
            return const Center(child: CircularProgressIndicator());
          }else{
            return const SizedBox(height: 0, width: 0,);
          }
        }),
      ),
    );
  }
}