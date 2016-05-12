//
//  ViewController.m
//  购物车
//
//  Created by 赵群涛 on 16/5/11.
//  Copyright © 2016年 赵群涛. All rights reserved.
//

#import "ViewController.h"
#import "ServerProductLineViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.585 green:0.721 blue:1.000 alpha:1.000];
}
- (IBAction)btn:(id)sender {
    ServerProductLineViewController *seff = [[ServerProductLineViewController alloc] init];
    [self.navigationController pushViewController:seff animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
