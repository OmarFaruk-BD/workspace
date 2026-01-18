import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:workspace/core/api/api_client.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/features/thesis/dashboard/model/my_leave_request.dart';
import 'package:workspace/features/thesis/dashboard/model/leave_detail_model.dart';
import 'package:workspace/features/thesis/dashboard/model/leave_request_model.dart';

class LeaveService {
  Future<LeaveListModel?> getLeaveList({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Map<String, dynamic> params = {
        'start_date': startDate?.toDateString('yyyy-MM-dd'),
        'end_date': endDate?.toDateString('yyyy-MM-dd'),
      };
      final response = await ApiClient().get(
        path: 'Endpoints.leaveListByDate',
        params: params,
      );
      Logger().e(params);
      response.print();
      LeaveListModel? dataModel =
          LeaveListResModel.fromMap(response.response?.data).data;
      return dataModel;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<MyLeaveRequestModel?> getMyLeaveRequest() async {
    try {
      Map<String, dynamic> params = {'page': 1, 'per_page': 9999};
      final response = await ApiClient().get(
        path: 'Endpoints.myLeaveRequest',
        params: params,
      );
      Logger().e(params);
      response.print();
      MyLeaveRequestModel? dataModel =
          MyLeaveRequestResModel.fromMap(response.response?.data).data;
      return dataModel;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<LeaveDetailModel?> getLeaveDetails(String id) async {
    try {
      Map<String, dynamic> params = {'leave_id': id};
      final response = await ApiClient().get(
        path: 'Endpoints.leaveDetails',
        params: params,
      );
      response.print();
      LeaveDetailModel? dataModel =
          LeaveDetailResModel.fromMap(response.response?.data).data;
      return dataModel;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<Either<String, String>> leaveRequest(
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await ApiClient().post(
        path: 'Endpoints.leaveRequest',
        data: data,
      );
      Logger().e(data);
      response.print();
      return response.fold((f) => left(f.message()), (s) => right(s.message()));
    } catch (e) {
      Logger().e(e);
      return left('Something went wrong.');
    }
  }

  Future<Either<String, String>> cancelLeaveRequest(String? id) async {
    try {
      Map<String, dynamic> params = {'leave_id': id};
      final response = await ApiClient().get(
        path: 'Endpoints.cancelLeaveRequest',
        params: params,
      );
      Logger().e(params);
      response.print();
      return response.fold((f) => left(f.message()), (s) => right(s.message()));
    } catch (e) {
      Logger().e(e);
      return left('Something went wrong.');
    }
  }
}
