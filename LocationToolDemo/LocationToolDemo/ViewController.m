//
//  ViewController.m
//  代理模式到Block模式的转换
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "LocationTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[LocationTool sharedLocationTool] getCurrentLocation:^(CLLocation *location, CLPlacemark *placemark, NSString *error) {
        if (error.length) {
            NSLog(@"%@", error);
        }else{
            NSLog(@"%@----%@", location, placemark);
        }
    }];
}



@end
