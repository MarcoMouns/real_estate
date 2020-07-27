import 'package:dio/dio.dart';
import 'package:realestate/models/facade.dart';

class GetFacade {
  final String url = "http://api.naffeth.com/";
  final String facade = "facade/";

  Future<List<FacadeModel>> getFacade() async {
    List<FacadeModel> facadeModelList = List<FacadeModel>();
    Response response;
    try {
      response = await Dio().get('$url$facade');
      List data = response.data;
      data.forEach((element) {
        facadeModelList.add(FacadeModel.fromApi(element));
      });
    } on DioError catch (e) {
      print('error in getFacade => ${e.response.data}');
      facadeModelList.add(FacadeModel(id: 0, name: "unTitled"));
    }
    return facadeModelList;
  }
}
