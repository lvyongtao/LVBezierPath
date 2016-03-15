//
//  ViewController.m
//  LVBezierPathDemo
//
//  Created by user on 16/3/15.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "ViewController.h"
#import "GIfAnimation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
    bu.frame = CGRectMake(30, 400, 30, 30);
    bu.backgroundColor =[UIColor yellowColor];
    [bu addTarget:self action:@selector(buttonClock:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu];
    // Do any additional setup after loading the view, typically from a nib.
  
}
- (void)buttonClock:(UIButton *)btn{
    self.view.backgroundColor = [UIColor grayColor];
    GIfAnimation *animationView = [[GIfAnimation alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    animationView.percent = 0.75;
    animationView.percentLableColor = [UIColor redColor];
    [animationView restartAnimation];
    [self.view addSubview:animationView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
