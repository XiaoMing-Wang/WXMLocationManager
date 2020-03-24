//
//  WXMLocationManager.h
//  WXMComponentization
//
//  Created by wxm on 2019/12/31.
//  Copyright © 2019 wxm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMLocation : NSObject
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *detailedAddress;
@property (nonatomic, copy) NSString *subLocality;
@property (nonatomic, copy) NSString *thoroughfare;
@property (nonatomic, copy) NSString *subThoroughfare;
@end

@interface WXMLocationManager : NSObject
+ (instancetype)sharedInstance;
- (BOOL)location;
- (void)setCallback:(void (^)(WXMLocation *location))callback;
@end

NS_ASSUME_NONNULL_END
