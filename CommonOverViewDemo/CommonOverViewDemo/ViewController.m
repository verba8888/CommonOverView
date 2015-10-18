//
//  ViewController.m
//  CommonOverViewDemo
//
//  Created by kitahata yukihiro on 2015/10/18.
//  Copyright © 2015年 verba8888. All rights reserved.
//

#import "ViewController.h"
#import "CommonOverView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[CommonOverView sharedInstance]showIndicatorWithView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
