//
//  HttpRequestTool.h
//  FXBEST
//
//  Created by 庄琦 on 15/8/22.
//  Copyright © 2016年 Seven. All rights reserved.
//  网络请求工具类：负责整个项目的所有HTTP请求

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PersonalSegmentedViewController.h"

@interface HttpRequestTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)get:(NSString *)url params:(NSDictionary *)params currentAppearController:(UIViewController *)viewController currentAppearControllerType:(CurrentAppearControllerType)type success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params currentAppearController:(UIViewController *)viewController currentAppearControllerType:(CurrentAppearControllerType)type success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/** 同步 */
+ (void)postSynchronous:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error, NSData *data))failure;

/**
 *  获取网络状态
 */
+(AFNetworkReachabilityStatus)getNetWorkState;
/**
 *  post 上传图片
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))constractingBodyBlock success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  post 上传图片 带进度
 */
+(void)post:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))constractingBodyBlock success:(void (^)(id))success failure:(void (^)(NSError *))failure uploadProgress:(void(^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock;



@end
