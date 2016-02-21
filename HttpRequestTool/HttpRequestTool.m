//
//  HttpRequestTool.m
//  FXBEST
//
//  Created by 庄琦 on 15/8/22.
//  Copyright © 2016年 Seven. All rights reserved.
//

#import "HttpRequestTool.h"
#import "AFNetworking.h"
#import "Constant.h"
//#import "FXAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "MobClick.h"
#define timeoutSeconds 5
#define timeoutTimes 3

@implementation HttpRequestTool

static NSMutableDictionary *publicDictionary;

static AFNetworkReachabilityStatus _status;

static AFNetworkReachabilityManager *_reachability;

+(void)initialize
{
    //监测网络
    _reachability=[AFNetworkReachabilityManager sharedManager];
    _status=_reachability.networkReachabilityStatus;
    [self Reachablity];
}

+(AFNetworkReachabilityStatus)getNetWorkState
{
    return _status;
}

/**
 *  网络监测
 */
+(void)Reachablity
{
    [_reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                _status=AFNetworkReachabilityStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status=AFNetworkReachabilityStatusReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status=AFNetworkReachabilityStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusUnknown:
                _status=AFNetworkReachabilityStatusUnknown;
                break;
        }
    }];
    [_reachability startMonitoring];
}


+ (void)get:(NSString *)url params:(NSDictionary *)params currentAppearController:(UIViewController *)viewController currentAppearControllerType:(CurrentAppearControllerType)type success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setTimeoutInterval:15];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    
    // 2.发送GET请求
    [mgr GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (failure) {
            failure(error);
            if (error.code == 3840) {
//                [MBProgressHUD show:@"服务器繁忙" icon:nil view:nil];
            }else if (error.code == -1001){
                [MBProgressHUD show:@"网络超时" icon:nil view:nil];
            }
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params currentAppearController:(UIViewController *)viewController currentAppearControllerType:(CurrentAppearControllerType)type success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setTimeoutInterval:15];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    
    // 2.发送POST请求
    [mgr POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

            if(success) {
                success(responseObject);
                
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (failure) {
            failure(error);
            if (error.code == 3840) {
//                [MBProgressHUD show:@"服务器繁忙" icon:nil view:nil];
            }else if (error.code == -1001){
                [MBProgressHUD show:@"网络超时" icon:nil view:nil];
            }
        }
    }];
}

+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setTimeoutInterval:15];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    
    // 2.发送GET请求
    [mgr GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (failure) {
            failure(error);
            if (error.code == 3840) {
//                [MBProgressHUD show:@"服务器繁忙" icon:nil view:nil];
            }else if (error.code == -1001){
                [MBProgressHUD show:@"网络超时" icon:nil view:nil];
            }
        }
    }];
}

+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [self post:url params:params times:timeoutTimes success:success failure:failure];
    
    
}

+ (void)postSynchronous:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *, NSData *))failure
{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *serialization = mgr.requestSerializer;
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [serialization requestWithMethod:@"POST" URLString: [NSString stringWithFormat:@"%@app/index.php?act=store_goods&op=getSpecInfo",DYNAMICDOMAIN] parameters:params error:&error];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        failure(error, data);
        
        if (error.code == -1001) {
            [MBProgressHUD show:@"网络超时" icon:nil view:nil];
        }
        
    }else{
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (json == nil) {
            failure(nil, data);
//            [MBProgressHUD show:@"服务器繁忙" icon:nil view:nil];
        }else{
            success(json);
        }
    }
    

}


+ (void)post:(NSString *)url params:(NSDictionary *)params times:(int)times success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setTimeoutInterval:timeoutSeconds];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    // 2.发送POST请求
    [mgr POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if(success) {
            
            if ([responseObject[@"code"] isEqualToString:@"-8"] || [responseObject[@"code"] isEqualToString:@"-9"]) {
                [[EaseMob sharedInstance].chatManager  asyncLogoffWithUnbindDeviceToken:NO];
            }
            
            success(responseObject);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (failure) {
            
            if (error.code == 3840) {
                failure(error);
//                [MBProgressHUD show:@"服务器繁忙" icon:nil view:nil];
            }else if (error.code == -1001){
                
                if (times <= 0) {
                    failure(error);
//                     [MBProgressHUD show:@"网络超时" icon:nil view:nil];
                }else{
                    
                    [self post:url params:params times:times - 1 success:success failure:failure];
                }
        
            }else{
                failure(error);
            }
        }
    }];

}






/**
 *  post 上传
 */
+(void)post:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))constractingBodyBlock success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [self post:url params:params constructingBodyWithBlock:constractingBodyBlock success:success failure:failure uploadProgress:nil];
}
/**
 *  post 上传 设置进度
 */
+(void)post:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))constractingBodyBlock success:(void (^)(id))success failure:(void (^)(NSError *))failure uploadProgress:(void(^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock
{
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setTimeoutInterval:15];
    
    // 2.发送请求
    AFHTTPRequestOperation *op=[mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(constractingBodyBlock)
        {
            constractingBodyBlock(formData);
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(error);
            if (error.code == 3840) {
//                [MBProgressHUD show:@"服务器繁忙" icon:nil view:nil];
            }else if (error.code == -1001){
                [MBProgressHUD show:@"网络超时" icon:nil view:nil];
            }
        }
    }];
    if (uploadProgressBlock) {
        [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            uploadProgressBlock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }];
    }
}


@end
