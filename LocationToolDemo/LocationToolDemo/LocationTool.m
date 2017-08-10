//
//  LocationTool.m
//  代理模式到Block模式的转换
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LocationTool.h"
#import <UIKit/UIKit.h>
#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue]>=version)
@interface LocationTool()<CLLocationManagerDelegate>
@property (nonatomic, copy) ResultBlock resultBlock;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@end

@implementation LocationTool
//单例对象的实现
single_implementation(LocationTool)

-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;

        //iOS8.0+需要请求授权
        if (isIOS(8.0)) {
            //请求哪个权限没法确定，要靠开发者决定
            //1、获取info.plist文件内容
            NSDictionary *infos = [[NSBundle mainBundle]infoDictionary];
            //2、获取开发者设置的权限
            NSString *always = infos[@"NSLocationAlwaysUsageDescription"];
            NSString *whenInuse = infos[@"NSLocationWhenInUseUsageDescription"];

            if (always.length) {//请求前后台权限
                [_locationManager requestAlwaysAuthorization];
            }else if(whenInuse.length){//请求前台权限
                [_locationManager requestWhenInUseAuthorization];
                //在前台授权模式下，如果想要在后台获取用户位置信息，必须勾选后台模式Location updates，才能获取用户的位置信息
                NSArray *services = infos[@"UIBackgroundModes"];
                if (![services containsObject:@"location"]) {
                    NSLog(@"友情提示: 在前台授权模式下，如果想要在后台获取用户位置信息，必须勾选后台模式Location updates，才能获取用户的位置信息");
                }else{
                    if (isIOS(9.0)) {
                        _locationManager.allowsBackgroundLocationUpdates = YES;
                    }
                }
            }else{
                NSLog(@"错误:在iOS8.0之后，需要在plist文件配置NSLocationAlwaysUsageDescription或者NSLocationWhenInUseUsageDescription定位权限");
            }



        }


        [_locationManager requestAlwaysAuthorization];
    }
    return _locationManager;
}
-(CLGeocoder *)geoCoder{
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

-(void)getCurrentLocation:(ResultBlock)block{
    //先记录到block，然后再合适的位置调用block
    _resultBlock = block;
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];

    }else{
        self.resultBlock(nil, nil, @"定位服务没有打开");
    }

}


#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    if (location.horizontalAccuracy<0) return;


    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
             //获取地标对象
            CLPlacemark *placemark = [placemarks firstObject];

            self.resultBlock(location, placemark, nil);
        }else{

            self.resultBlock(location, nil, error.description);
        }
    }];
   // [self.locationManager stopUpdatingLocation];

}
@end
