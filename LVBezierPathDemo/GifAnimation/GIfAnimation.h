//
//  GIfAnimation.h
//  LVBezierPathDemo
//
//  Created by user on 16/3/15.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *  传递停止的时间
 *
 *  @param NSString
 */
typedef void(^TimeBlock)(NSString *);

@interface GIfAnimation : UIView
// 传入的百分比
@property (nonatomic,assign) CGFloat percent;
//创建动画的layer层
@property (nonatomic,strong) CAShapeLayer *firstLayerLine ;
//创建动画的layer层
@property (nonatomic,strong) CAShapeLayer *secondLayerLine ;
@property (nonatomic,copy) TimeBlock timeBolck;




//********Color************//
@property (nonatomic ,strong) UIColor *percentLableColor;



/**
 *  暂停动画
 *
 *  @param layer
 */
-(void)pauseLayer:(CALayer*)layer;
/**
 *  恢复动画
 *
 *  @param layer
 */
-(void)resumeLayer:(CALayer*)layer;
/**
 *  重启动画
 */
- (void)restartAnimation;

/**
 *  声明Block方法
 *
 *  @param bolck
 */
- (void)TimeBlockA:(TimeBlock )bolck;
@end
