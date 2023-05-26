import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_complaint_image_upload_request.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_complaint_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_complaint_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_emp_follower_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/fetch_accurabath_complaint_image_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/accurabath_complaint/accurabath_complaint_no_to_delete_image_request.dart';
import 'package:for_practice_the_app/models/api_requests/accurabath_complaint/accurabath_complaint_no_to_delete_video_request.dart';
import 'package:for_practice_the_app/models/api_requests/accurabath_complaint/accurabath_complaint_no_to_upload_video_request.dart';
import 'package:for_practice_the_app/models/api_requests/accurabath_complaint/accurabath_complaint_videoList_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_search_by_Id_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_search_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_label_value_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/toDo_request/transection_mode_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/Accurabath_complaint/accurabath_complaint_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/Accurabath_complaint/accurabath_complaint_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/Accurabath_complaint/accurabth_complaint_upload_image_response.dart';
import 'package:for_practice_the_app/models/api_responses/Accurabath_complaint/complaint_image_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/accurabath_complaint/accurabath_complaint_no_to_delete_image_response.dart';
import 'package:for_practice_the_app/models/api_responses/accurabath_complaint/accurabath_complaint_videoList_Response.dart';
import 'package:for_practice_the_app/models/api_responses/accurabath_complaint/accurabath_emp_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/accurabath_complaint/acurabath_complaint_no_to_delete_video_response.dart';
import 'package:for_practice_the_app/models/api_responses/accurabath_complaint/acurabath_complaint_no_to_upload_video_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_source_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintScreenBloc
    extends Bloc<ComplaintScreenEvents, ComplaintScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ComplaintScreenBloc(this.baseBloc) : super(ComplaintScreenInitialState());

  @override
  Stream<ComplaintScreenStates> mapEventToState(
      ComplaintScreenEvents event) async* {
    if (event is ComplaintListCallEvent) {
      yield* _mapComplaintListCallEventToState(event);
    }
    if (event is ComplaintSearchByNameCallEvent) {
      yield* _mapSearchByNameCallEventToState(event);
    }
    if (event is ComplaintSearchByIDCallEvent) {
      yield* _mapSearchByIDCallEventToState(event);
    }
    if (event is ComplaintDeleteCallEvent) {
      yield* _mapDeleteCallEventToState(event);
    }

    if (event is SearchFollowupCustomerListByNameCallEvent) {
      yield* _mapFollowupCustomerListByNameCallEventToState(event);
    }
    if (event is CustomerSourceCallEvent) {
      yield* _mapCustomerSourceCallEventToState(event);
    }
    if (event is ComplaintSaveCallEvent) {
      yield* _mapSaveCallEventToState(event);
    }

    if (event is AccuraBathComplaintListRequestEvent) {
      yield* _mapAccurabathComplaintListCallEventToState(event);
    }
    if (event is FetchAccuraBathComplaintImageListRequestEvent) {
      yield* _mapAccuraBathFetchComplaintImageListCallEventToState(event);
    }

    if (event is AccuraBathComplaintEmpFollowerListRequestEvent) {
      yield* _mapAccuraBathComplaintEmpFollowerListEventState(event);
    }

    if (event is AccuraBathComplaintSaveRequestEvent) {
      yield* _mapAccuraBathSaveCallEventToState(event);
    }

    if (event is AccurabathComplaintImageDeleteRequestEvent) {
      yield* _mapAccurabathComplaintImageDeleteRequestEventState(event);
    }

    if (event is AccurabathComplaintVideoDeleteRequestEvent) {
      yield* _nmapAccurabathComplaintVideoDeleteRequestEventState(event);
    }

    if (event is AccuraBathComplaintUploadImageAPIRequestEvent) {
      yield* _mapAccuraBathComplaintUploadImageCallEventToState(event);
    }

    if (event is AccuraBathComplaintUploadVideoAPIRequestEvent) {
      yield* _mapAccuraBathComplaintUploadVideoCallEventToState(event);
    }

    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }
    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }
    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }
  }

  Stream<ComplaintScreenStates> _mapComplaintListCallEventToState(
      ComplaintListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintListResponse response = await userRepository.getComplaintList(
          event.pageNo, event.complaintListRequest);
      yield ComplaintListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapSearchByNameCallEventToState(
      ComplaintSearchByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintSearchResponse response = await userRepository
          .getComplaintSearchByName(event.complaintSearchRequest);
      yield ComplaintSearchByNameResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapSearchByIDCallEventToState(
      ComplaintSearchByIDCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintListResponse response = await userRepository
          .getComplaintSearchByID(event.pkID, event.complaintSearchByIDRequest);
      yield ComplaintSearchByIDResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapDeleteCallEventToState(
      ComplaintDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintDeleteResponse response =
          await userRepository.DeleteComplaintBypkID(
              event.pkID, event.complaintDeleteRequest);
      yield ComplaintDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapFollowupCustomerListByNameCallEventToState(
      SearchFollowupCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield FollowupCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapCustomerSourceCallEventToState(
      CustomerSourceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerSourceResponse respo =
          await userRepository.customer_Source_List_call(event.request1);
      yield CustomerSourceCallEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapSaveCallEventToState(
      ComplaintSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintSaveResponse response = await userRepository.getComplaintSave(
          event.pkID, event.complaintSaveRequest);
      yield ComplaintSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapAccurabathComplaintListCallEventToState(
      AccuraBathComplaintListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AccuraBathComplaintListResponse response =
          await userRepository.getAccurabathComplaintList(
              event.pageNo, event.accuraBathComplaintListRequest);
      yield AccuraBathComplaintListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates>
      _mapAccuraBathFetchComplaintImageListCallEventToState(
          FetchAccuraBathComplaintImageListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      FetchAccuraBathComplaintImageListResponse respo =
          await userRepository.AccuraBathComplaintImage_list_details(
              event.fetchAccuraBathComplaintImageListRequest);

      AccurabathComplaintVideoListResponse videoListrespo =
          await userRepository.AccuraBathComplaint_Video_list_details(
              event.accuraBathComplaintVideoListRequest);

      List<File> ImageFileList = [];
      for (int i = 0; i < respo.details.length; i++) {
        File file = await userRepository.AccurabathImageFileListAPI(
            event.ImageBaseURL + "", respo.details[i].docName);
        ImageFileList.add(file);
      }

      List<File> VideoFileList = [];
      for (int i = 0; i < videoListrespo.details.length; i++) {
        File file = await userRepository.AccurabathImageFileListAPI(
            event.VideoFileURL, videoListrespo.details[i].fileName);
        VideoFileList.add(file);
      }

      yield FetchAccuraBathComplaintImageListResponseState(
          respo,
          event.accuraBathComplaintListResponseDetails,
          videoListrespo,
          ImageFileList,
          VideoFileList);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates>
      _mapAccuraBathComplaintEmpFollowerListEventState(
          AccuraBathComplaintEmpFollowerListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AccuraBathComplaintEmployeeListResponse respo =
          await userRepository.getComplaintEmployeeFollowerAPI(
              event.complaintEmpFollowerListRequest);
      yield AccuraBathComplaintEmployeeListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapAccuraBathSaveCallEventToState(
      AccuraBathComplaintSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AccuraBathComplaintSaveResponse response = await userRepository
          .getAccuraBathComplaintSave(event.pkID, event.complaintSaveRequest);

      var splitNo = response.details[0].column3.split(",");

      await userRepository.getComplaintNoToDeleteImageAPI(
          splitNo[0],
          AccurabathComplaintImageDeleteRequest(
              CompanyId: event.complaintSaveRequest.CompanyId,
              LoginUserID: event.complaintSaveRequest.LoginUserID,
              KeyValue: splitNo[0]));

      await userRepository.getComplaintNoToDeleteVideoAPI(
          splitNo[0],
          AccurabathComplaintVideoDeleteRequest(
              CompanyId: event.complaintSaveRequest.CompanyId,
              LoginUserID: event.complaintSaveRequest.LoginUserID,
              ComplaintNo: splitNo[0]));

      if (event.imageFileList.length != 0) {
        for (int i = 0; i < event.imageFileList.length; i++) {
          if (event.imageFileList[i].path != "") {
            var getextention =
                event.imageFileList[i].path.split('/').last.split(".");
            await userRepository.getAccuraBathComplaintuploadImage(
                event.imageFileList[i],
                AccuraBathComplaintUploadImageAPIRequest(
                    ModuleName: "complaint",
                    DocName: "complaint-" +
                        splitNo[0] +
                        "-" +
                        "Image" +
                        i.toString() +
                        "." +
                        getextention[1],
                    KeyValue: splitNo[0],
                    LoginUserId: event.complaintSaveRequest.LoginUserID,
                    CompanyId: event.complaintSaveRequest.CompanyId,
                    pkID: splitNo[1],
                    file: event.imageFileList[i]));
          }
        }
      }

      if (event.videoFileList.length != 0) {
        for (int i = 0; i < event.videoFileList.length; i++) {
          if (event.videoFileList[i].path != "") {
            var getextention =
                event.videoFileList[i].path.split('/').last.split(".");

            print("ImageLastName" +
                " Image : " +
                "Image" +
                i.toString() +
                "." +
                getextention[1]);

            await userRepository.getAccuraBathComplaintuploadVideo(
                event.videoFileList[i],
                AccuraBathComplaintUploadVideoAPIRequest(
                    CompanyId: event.complaintSaveRequest.CompanyId,
                    pkID: splitNo[1],
                    ComplaintNo: splitNo[0],
                    Name: "SiteVisit-" +
                        splitNo[0] +
                        "-" +
                        "Video" +
                        i.toString() +
                        "." +
                        getextention[1],
                    Type: "sitevideo",
                    LoginUserId: event.complaintSaveRequest.LoginUserID,
                    file: event.videoFileList[i]));
          }
        }
      }

      yield AccuraBathComplaintSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates>
      _mapAccurabathComplaintImageDeleteRequestEventState(
          AccurabathComplaintImageDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AccuraBathComplaintNoToDeleteImageResponse respo =
          await userRepository.getComplaintNoToDeleteImageAPI(
              event.ComplaintNo, event.complaintNoToDeleteImageVideoRequest);
      yield AccuraBathComplaintNoToDeleteImageResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates>
      _nmapAccurabathComplaintVideoDeleteRequestEventState(
          AccurabathComplaintVideoDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AccuraBathComplaintDeleteVideoResponse respo =
          await userRepository.getComplaintNoToDeleteVideoAPI(
              event.ComplaintNo, event.accurabathComplaintVideoDeleteRequest);
      yield AccuraBathComplaintNoToDeleteVideoResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates>
      _mapAccuraBathComplaintUploadImageCallEventToState(
          AccuraBathComplaintUploadImageAPIRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AccuraBathComplaintImageUploadResponse response;
      for (int i = 0; i < event.expenseImageFile.length; i++) {
        if (event.expenseImageFile[i].path != "") {
          var getextention =
              event.expenseImageFile[i].path.split('/').last.split(".");

          print("ImageLastName" +
              " Image : " +
              "Image" +
              i.toString() +
              "." +
              getextention[1]);
          event.complaintUploadImageAPIRequest.DocName = "complaint-" +
              event.complaintUploadImageAPIRequest.KeyValue +
              "-" +
              "Image" +
              i.toString() +
              "." +
              getextention[1];
          //event.expenseImageFile[i].path.split('/').last;
          event.complaintUploadImageAPIRequest.file = event.expenseImageFile[i];
          response = await userRepository.getAccuraBathComplaintuploadImage(
              event.expenseImageFile[i], event.complaintUploadImageAPIRequest);
        }
      }

      // print("RESPPDDDD" +  await userRepository.getuploadImage(event.expenseUploadImageAPIRequest).toString());
      yield AccuraBathComplaintUploadImageCallResponseState(
          response, event.complaintUploadImageAPIRequest);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates>
      _mapAccuraBathComplaintUploadVideoCallEventToState(
          AccuraBathComplaintUploadVideoAPIRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AccuraBathComplaintVideoUploadResponse response;
      for (int i = 0; i < event.expenseImageFile.length; i++) {
        if (event.expenseImageFile[i].path != "") {
          var getextention =
              event.expenseImageFile[i].path.split('/').last.split(".");

          print("ImageLastName" +
              " Image : " +
              "Image" +
              i.toString() +
              "." +
              getextention[1]);
          event.complaintUploadImageAPIRequest.Name = "SiteVisit-" +
              event.complaintUploadImageAPIRequest.ComplaintNo +
              "-" +
              "Video" +
              i.toString() +
              "." +
              getextention[1];
          /*event.complaintUploadImageAPIRequest.Name =
              event.expenseImageFile[i].path.split('/').last;*/
          event.complaintUploadImageAPIRequest.file = event.expenseImageFile[i];
          response = await userRepository.getAccuraBathComplaintuploadVideo(
              event.expenseImageFile[i], event.complaintUploadImageAPIRequest);
        }
      }

      // print("RESPPDDDD" +  await userRepository.getuploadImage(event.expenseUploadImageAPIRequest).toString());
      yield AccuraBathComplaintUploadVideoCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapCountryListCallEventToState(
      CountryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CountryListResponse respo =
          await userRepository.country_list_call(event.countryListRequest);
      yield CountryListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapStateListCallEventToState(
      StateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      StateListResponse respo =
          await userRepository.state_list_call(event.stateListRequest);
      yield StateListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapCityListCallEventToState(
      CityCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CityApiRespose respo =
          await userRepository.city_list_details(event.cityApiRequest);
      yield CityListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapUserMenuRightsRequestEventState(
      UserMenuRightsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      UserMenuRightsResponse respo = await userRepository.user_menurightsapi(
          event.MenuID, event.userMenuRightsRequest);
      yield UserMenuRightsResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
