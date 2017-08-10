//
//  LocationTool.h
//  代理模式到Block模式的转换
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>
typedef void(^ResultBlock)(CLLocation *location, CLPlacemark *placemark,NSString *error);

@interface LocationTool : NSObject


single_interface(LocationTool)

-(void)getCurrentLocation:(ResultBlock)block;

@end
