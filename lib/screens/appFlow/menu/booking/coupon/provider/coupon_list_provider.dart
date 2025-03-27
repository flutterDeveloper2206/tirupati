import 'package:flutter/material.dart';
import 'package:crm_demo/data/model/coupon/coupon_list_model.dart';
import 'package:crm_demo/data/server/respository/crm_booking_repository/crm_booking_repository.dart';

class CouponListProvider extends ChangeNotifier{

  CouponListModel? couponListResponse;

  bool isLoading = false;

  CouponListProvider(){
    getCouponList();
  }

  getCouponList() async {
    isLoading = true;
    final response = await CrmBookingRepository.getCouponListData();
    if(response.result == true){
      couponListResponse = response.data;
      isLoading = false;
      notifyListeners();
    }
  }

}