//
//  IGBaseService.m
//  InstagramSDKDemo
//
//  Created by Gevorg Ghukasyan on 2016-06-29.
//  Copyright © 2016 Gevorg Ghukasyan. All rights reserved.
//

#import "IGBaseService.h"
#import "IGConstants.h"
#import <UIKit/UIKit.h>
#import "IGManager.h"
#import <CommonCrypto/CommonHMAC.h>

static NSString *const IG_SIG_KEY = @"55e91155636eaa89ba5ed619eb4645a4daf1103f2161dbfe6fd94d5ea7716095";


@interface IGBaseService ()

@end

@implementation IGBaseService

- (void)makeFullyPostRequest:(NSString *)url
             withParams:(NSDictionary*)params
             completion:(IGResponseBlock)completion {
    
    [self makeRequestWithEndpoint:url
                       withParams:params
                      requestType:IGRequestTypePost
                       completion:completion];
}

- (void)makeFullyGetRequest:(NSString *)url
            withParams:(NSDictionary*)params
            completion:(IGResponseBlock)completion {
    
    [self makeRequestWithEndpoint:url
                       withParams:params
                      requestType:IGRequestTypeGet
                       completion:completion];
}

- (void)makeRequestWithEndpoint:(NSString *)endpointUrls
                     withParams:(NSDictionary*)params
                    requestType:(IGRequestType )requestType
                     completion:(IGResponseBlock)completion {
    
    NSString *urlStr = [NSString stringWithFormat:kBaseServerUrl, endpointUrls];
    NSData *bodyData = [self configureDefoultParamsWithParam:params];
    NSString *cookieString = [self configureDefoultCookies];
    
    [self makeRequestWithUrl:urlStr
              withParamsData:bodyData
                 requestType:requestType
                cookieString:cookieString
                  completion:completion];
}

- (void)syncInstagram:(IGResponseBlock)completion {
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *eqperiments = @"ig_nonfb_sso_universe,ig_ios_multiple_accounts_badging_universe,ig_ios_disk_analytics,enable_nux_language,ig_ios_password_less_registration_universe,ig_ios_white_camera_dogfooding_universe,ig_ios_one_click_login_universe_2,ig_ios_whiteout_dogfooding,ig_ios_one_password_extension,ig_ios_registration_phone_default_universe,ig_ios_branding_refresh,ig_ios_whiteout_kill_switch,ig_ios_analytics_compress_file,ig_ios_one_click_login_tab_design_universe,ig_ios_use_family_device_id_universe,ig_ios_registration_robo_call_time";
    
    NSDictionary *dic = @{
                          @"experiments" : eqperiments,
                          @"id": uniqueIdentifier
                          };
    

    NSString *signed_body = [self encodePostParameters:dic];
    

    NSString *hmac = [self hmac:signed_body withKey:IG_SIG_KEY];
    
    
    NSDictionary *params = @{@"ig_sig_key_version" : @"5",
                              @"signed_body" : [NSString stringWithFormat:@"%@.%@", hmac, signed_body]
                              };
    
    NSString *requestString = [self encodePostParameters:params];

    NSString *urlSting = [NSString stringWithFormat:kBaseServerUrl, kSyncEndpoint];
    
    NSString *cookieString;// = @"mid=Vk9YawAAAAEDMq9a-O0OtNCuZ58o";
    
    [self makeRequestWithUrl:urlSting
              withParamsData:[requestString dataUsingEncoding:NSUTF8StringEncoding]
                 requestType:IGRequestTypePost
                cookieString:cookieString
                  completion:completion];
}



- (void)makeRequestWithUrl:(NSString *)urlString
            withParamsData:(NSData *)paramsData
               requestType:(IGRequestType )requestType
              cookieString:(NSString *)cookies
                completion:(IGResponseBlock)completion {
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    request.timeoutInterval = [IGManager sharedManager].requestTimeout;
    
    if (requestType == IGRequestTypePost) {
        
        request.HTTPMethod = @"POST";
    } else {
        request.HTTPMethod = @"GET";
    }
    
    
    if (paramsData) {
        
        [request setHTTPBody:paramsData];
        NSString *postLength = [NSString stringWithFormat:@"%d",[paramsData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    }
    
    if (cookies) {
        
//        [request setValue:cookies forHTTPHeaderField:@"Cookie"];
    }
    [request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"3w==" forHTTPHeaderField:@"X-IG-Capabilities"];
    [request setValue:@"WiFi" forHTTPHeaderField:@"X-IG-Connection-Type"];
    [request setValue:@"Instagram 8.3.0" forHTTPHeaderField:@"User-Agent"];

    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    

    
//    NSLog(@"request :: %@",     request.allHTTPHeaderFields);

    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"responce :: %@", dataJSON);
        NSLog(@"responce :: %@", response);
        

        if (error) {
            
            completion(nil, error);
        } else {
            
            completion(dataJSON, nil);
        }
    }];
    [dataTask resume];
}

- (NSData *)configureDefoultParamsWithParam:(NSDictionary *)param {
    
    NSMutableDictionary *fullyParams = param ? [param mutableCopy] : [[NSMutableDictionary alloc] init];
    
    [fullyParams setValue:@5 forKey:@"ig_sig_key_version"];
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [fullyParams setValue:uniqueIdentifier forKey:@"device_id"];
    
    if (fullyParams) {
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:fullyParams options:0 error:&error];
        if (!error) {
            
            return postData;
        } else {
            
            NSLog(@"error parse :: %@", error);
            
        }
    }
    return nil;
}

- (NSString *)configureDefoultCookies {
    
    NSString *cookiesString = @"";
    cookiesString = [cookiesString stringByAppendingString:@"is_starred_enabled=yes;"];
    
    NSString *csrftoken = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefoultCSRFtoken];
    
    if (csrftoken) {
        
        cookiesString = [cookiesString stringByAppendingString:[NSString stringWithFormat:@"csrftoken=%@", csrftoken]];
    }
    
    return cookiesString;
}

//- (void)preparingForRequest:(NSMutableURLRequest *)request withParams:(NSMutableDictionary *)params {
//    
////    NSString *appVersion = [NSString stringWithFormat:@"app_version=t.i.%@;",
////                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
////    
//    
//    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//
//    NSMutableDictionary *fullyParams = params ? : [[NSMutableDictionary alloc] init];
//    
//    [fullyParams setValue:@5 forKey:@"ig_sig_key_version"];
//    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    [fullyParams setValue:uniqueIdentifier forKey:@"device_id"];
//
//    if (fullyParams) {
//        
//        NSError *error;
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:fullyParams options:0 error:&error];
//        if (!error) {
//            
//            [request setHTTPBody:postData];
//        } else {
//            
//            NSLog(@"error parse :: %@", error);
//        }
//    }
//
//    
//    NSString *cookiesString = @"";
//    cookiesString = [cookiesString stringByAppendingString:@"is_starred_enabled=yes;"];
//    
//    NSString *csrftoken = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefoultCSRFtoken];
//    
//    if (csrftoken) {
//        
//        cookiesString = [cookiesString stringByAppendingString:[NSString stringWithFormat:@"csrftoken=%@", csrftoken]];
//    }
//    
//    [request setValue:cookiesString forHTTPHeaderField:@"Cookie"];
//}

- (NSString *)encodePostParameters:(NSDictionary *)parameters
{
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSString *key in parameters) {
        NSString *string;
        id value = parameters[key];
        if ([value isKindOfClass:[NSData class]]) {
            string = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
        } else if ([value isKindOfClass:[NSString class]]) {
            string = value;
        } else {                         // if you want to handle other data types, add that here
            string = [value description];
        }
        [results addObject:[NSString stringWithFormat:@"%@=%@", key, [self percentEscapeString:string]]];
    }
    
    NSString *postString = [results componentsJoinedByString:@"&"];
    
    return postString;
    
    return [postString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)percentEscapeString:(NSString *)string
{
    
//    NSString *encodedURL = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (CFStringRef)string,
                                                                     NULL,
                                                                     (CFStringRef)@":/?@!$&'()*+,;=",
                                                                     kCFStringEncodingUTF8));
}

//NSData *hmacForKeyAndData(NSString *key, NSString *data)
//{
//    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
//    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
//    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//
//    NSString *base64Hash = [hash base64EncodedStringWithOptions:0];
//
//    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
//}

- (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

@end
