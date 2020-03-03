//
//  BTDefine.h
//  BTStore
//
//  Created by Jason_Lee on 2018/2/1.
//  Copyright © 2018年 Karl. All rights reserved.
//

#ifndef BTDefine_h
#define BTDefine_h


#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif


// orderModel
#define KEY_NAME_orderId   @"orderId"
#define KEY_NAME_order_id  @"order_id"

#define KEY_NAME_stockCode   @"stockCode"
#define KEY_NAME_stock_code  @"stock_code"

#define KEY_NAME_doneVol   @"doneVol"
#define KEY_NAME_done_vol  @"done_vol"

#define KEY_NAME_swapVol   @"swapVol"
#define KEY_NAME_swap_vol  @"swap_vol"

#define KEY_NAME_feeCoinCode @"feeCoinCode"
#define KEY_NAME_fee_coin_code @"fee_coin_code"

#define KEY_NAME_doneFee   @"doneFee"
#define KEY_NAME_done_fee  @"done_fee"

#define KEY_NAME_errorno   @"errorno"
#define KEY_NAME_errno  @"errno"

#define KEY_NAME_createdAt  @"createdAt"
#define KEY_NAME_created_at   @"created_at"
#define KEY_NAME_Fee   @"fee"
#define KEY_NAME_way   @"way"

#define KEY_NAME_updated_at  @"updated_at"
#define KEY_NAME_updatedAt  @"updatedAt"

#define KEY_NAME_finishedAt  @"finishedAt"
#define KEY_NAME_finished_at  @"finished_at"

#define KEY_NAME_stock_code @"stock_code"
#define KEY_NAME_vol @"vol"
#define KEY_NAME_price @"price"
#define KEY_NAME_way @"way"
#define KEY_NAME_category @"category"
#define KEY_NAME_nonce @"nonce"

// tradeModel
#define KEY_NAME_deal_price   @"deal_price"
#define KEY_NAME_dealPrice  @"dealPrice"

#define KEY_NAME_deal_vol   @"deal_vol"
#define KEY_NAME_dealVol  @"dealVol"

#define KEY_FEE_COIN @"fee_coin_code"

#define KEY_NAME_fee   @"fee"
#define KEY_NAME_way   @"way"

#define KEY_NAME_store_code   @"stock_code"
#define KEY_NAME_storeCode  @"stockcode"

#define KEY_NAME_orders @"orders"
#define KEY_NAME_trades @"trades"
#define KEY_NAME_depth @"depth"

#define KEY_NAME_ticker @"ticker"

#define ORDER_CHECK_RESPONSE \
if (![responseObject isKindOfClass:[NSDictionary class]]) {\
if ( failure) {\
if([[responseObject allKeys] containsObject:@"message"]) {\
CALL_BACK_FAILURE(responseObject[@"message"]);\
}\
if([[responseObject allKeys] containsObject:@"msg"]) {\
CALL_BACK_FAILURE(responseObject[@"msg"]);\
}\
return;\
}\
}\
id dataObject = responseObject[@"data"];\
if (![dataObject isKindOfClass:[NSDictionary class]]) {\
if ( failure) {\
if([[responseObject allKeys] containsObject:@"message"]) {\
CALL_BACK_FAILURE(responseObject[@"message"]);\
}\
if([[responseObject allKeys] containsObject:@"msg"]) {\
CALL_BACK_FAILURE(responseObject[@"msg"]);\
}\
return;\
}\
}

#define CALL_BACK_FAILURE(ERR)\
if ( nil != failure) {\
failure(ERR);\
}

#define SHOW_ERROR_MESSAGE(error)\
if (error != nil && [error isKindOfClass:[NSString class]]) {\
[BTAlertView showTipsInfoWithTitle:LA_GLOBAL_TIPS content:error WithCancelBlock:^{\
}];\
} else if (error != nil) {\
[BTAlertView showTipsInfoWithTitle:LA_GLOBAL_TIPS content:LA_BT_LOAD_FAIL WithCancelBlock:^{\
}];\
}\

#define CALL_BACK_SUCCESS(data)\
if ( nil != success) {\
success(data);\
}

#define CALLBACK_SUCCESS(response,callBackValue)\
if ([response[@"errno"] isEqualToString:@"OK"]) {\
CALL_BACK_SUCCESS(callBackValue);\
} else {\
if([[response allKeys] containsObject:@"msg"]) {\
    CALL_BACK_FAILURE(response[@"msg"]);\
}\
if([[response allKeys] containsObject:@"message"]) {\
    CALL_BACK_FAILURE(response[@"message"]);\
}\
}\


// safe access
#define isNilOrNull(obj) (obj == nil || [obj isEqual:[NSNull null]])

#define CONFIG_INFO @"basePath.plist"

#endif // BTDefine_h
