//
//  GIfAnimation.m
//  LVBezierPathDemo
//
//  Created by user on 16/3/15.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "GIfAnimation.h"
#import "UIImage+GIF.h"

/// 屏幕的宽度
#define  WIDTH  [UIScreen mainScreen].bounds.size.width
/// 屏幕高度
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

#define kUIColor(Red,Green,Blue) [UIColor colorWithRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:1]
//动画运动的控制点
#define controlPointY HEIGHT*7/24
//动画运动的起点
#define startPointY HEIGHT*9/24

//百分比字号
#define minFont 12
#define topMaxFont 14
//动画图片的Size
#define imageW 30
#define imageH 30
//线宽
#define lineW 2.0
//显示百分比Lable的Frame
#define lableW 90
#define lableH 30

//动画持续的时间
static const CGFloat durtionTime = 5.00;
//时间间隔
static const CGFloat timeInterval = 0.01;


@interface GIfAnimation ()
{
    UIImageView *imageView ;
    //计算动画持续的时间
    float time;
    ///百分比
    float _percentNum;
    
    ///百分比累加
    float _addPercentNum;
}
//百分比显示
@property (nonatomic,strong) UILabel *percentLable;
//贝塞尔曲线layer
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@end
@implementation GIfAnimation


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _percentLableColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,startPointY- imageH*3/4 - 5, imageW, imageH)];
        imageView.clipsToBounds = YES;
        imageView.backgroundColor =[UIColor clearColor];
        imageView.layer.cornerRadius = imageW/2;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode =UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage sd_animatedGIFNamed:@"running"];
        [self addSubview:imageView];
        
        _percentLable =[[UILabel alloc] init];
        _percentLable.frame = CGRectMake(WIDTH/2 - lableW/2, startPointY- imageH*3/4 + 10, lableW, lableH);
        _percentLable.font =[UIFont systemFontOfSize:13];
        _percentNum = self.percent;
        _percentLable.text =@"(0.00%)";
        _percentLable.textColor = _percentLableColor;
        [self addSubview:_percentLable];
        time = 0.00;
        
    }
    return self;
}


#pragma mark
#pragma mark --重启动画

- (void)restartAnimation{
    
    for (id obj in self.subviews) {
        
        if ([obj isEqual:imageView]) {
            
            [obj removeFromSuperview];
            imageView = nil;
            NSLog(@"-重启动画111");
            
        }
        
    }
    UIImageView *image =(UIImageView *)[self viewWithTag:222];
    
    for (id obj in self.subviews) {
        
        if ([obj isEqual:image]) {
            
            [obj removeFromSuperview];
            image = nil;
            NSLog(@"-重启动画222");
            
        }
        
    }
    _addPercentNum = 0.00;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,startPointY - imageH*3/4, imageW, imageH)];
    imageView.clipsToBounds = YES;
    imageView.backgroundColor =[UIColor clearColor];
    imageView.layer.cornerRadius = imageW/2;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode =UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage sd_animatedGIFNamed:@"running"];
    [self addSubview:imageView];
    
    [self ruleAndArc];
    
    
}
//设置动画de轨迹和规则
- (void)ruleAndArc{
    
    CGPoint endPoint = CGPointMake(WIDTH, startPointY);
    CGPoint startPoint = CGPointMake(0, startPointY);
    
    if (self.percent != 0.00) {
        [self doAnimationWithStart:startPoint EndPoint:endPoint];
    }
    //100% 的情况下初始化动画
    if (self.percent == 1.00) {
        [_firstLayerLine removeFromSuperlayer];
        [imageView.layer removeAnimationForKey:@"move"];
        self.percent = 0.00;
    }
    //添加UI刷新计时器
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionTime:)];
    //    self.displayLink.frameInterval = 30;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

//    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(actionTime:) userInfo:nil repeats:YES];
    time = 0.00;
    
    
}

#pragma mark --Block
- (void)TimeBlockA:(TimeBlock)bolck{
    _timeBolck = bolck;
}
#pragma mark
#pragma mark --计时动画运动
- (void)actionTime:(CADisplayLink *)timer{
    
    
    CALayer *tempLayer = imageView.layer.presentationLayer;
    
    if (tempLayer.frame.origin.x + imageView.bounds.size.width*2/3>WIDTH *self.percent) {
        [self pauseLayer:imageView.layer];
        [self DraWNewFrame];
        _percentLable.attributedText=[GIfAnimation setFontStringWithFloatNumber:self.percent*100 withType:@"%" withNormalFont:minFont withMaxFont:topMaxFont];
        _percentLable.textColor = _percentLableColor;
        NSString *timeStr = [NSString stringWithFormat:@"%.2f",time];
        if (self.timeBolck != nil) {
            self.timeBolck(timeStr);
        }
        [timer invalidate];
    }else{
        _percentLable.attributedText=[GIfAnimation setFontStringWithFloatNumber:_addPercentNum*20 withType:@"%" withNormalFont:minFont withMaxFont:topMaxFont];
          _percentLable.textColor = _percentLableColor;
        _addPercentNum=timeInterval+_addPercentNum;
    }
    if (time >= durtionTime) {
        time = 0.00;
    }
    time = time + timeInterval;
}

#pragma mark --创建新的layer显示界面

- (void)DraWNewFrame{
    
    CALayer *tempLayer = imageView.layer.presentationLayer;
    UIImageView *image =(UIImageView *)[self viewWithTag:222];
    for (id obj in self.subviews) {
        if ([obj isEqual:image]) {
            [obj removeFromSuperview];
            NSLog(@"-重启动画222");
        }
        if ([obj isEqual:imageView]) {
            [obj removeFromSuperview];
            NSLog(@"-重启动画111");
        }
    }
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.tag = 222;
    imageV.frame = tempLayer.frame;
    imageV.clipsToBounds = YES;
    imageV.backgroundColor =[UIColor clearColor];
    imageV.layer.cornerRadius = imageW/2;
    imageV.layer.masksToBounds = YES;
    imageV.contentMode =UIViewContentModeScaleAspectFit;
    imageV.image = [UIImage sd_animatedGIFNamed:@"running"];
    [self addSubview:imageV];
    
    
    
    CGPoint endPoint = CGPointMake(WIDTH, startPointY+ imageH/2);
    CGPoint startPoint = CGPointMake(0, startPointY + imageH/2);
    CGPoint controlPoint = CGPointMake(WIDTH/2, controlPointY +imageH/2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    //画新的layer层和暂停的界面一致
    if (_secondLayerLine) {
        [_secondLayerLine removeFromSuperlayer];
    }
    _secondLayerLine = [CAShapeLayer layer];
    _secondLayerLine.backgroundColor =[[UIColor redColor] CGColor];
    
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    _secondLayerLine.path = path.CGPath;
    _secondLayerLine.lineWidth = lineW;
    
    _secondLayerLine.fillColor = [[UIColor clearColor]CGColor];
    _secondLayerLine.strokeColor =  _percentLableColor.CGColor;
    [self.layer addSublayer:_secondLayerLine];
    _secondLayerLine.strokeStart = 0;
    _secondLayerLine.strokeEnd = self.percent;
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"strokeEnd";
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue =[NSNumber numberWithFloat:self.percent];
    if (self.percent == 0.00) {
        [_secondLayerLine removeFromSuperlayer];
    }
    animation.duration = 0.1;
    [_secondLayerLine addAnimation:animation forKey:@"moveAwaaaaay"];
    
}
/**
 *  开始动画
 *
 */
- (void)doAnimationWithStart:(CGPoint)startPoint EndPoint:(CGPoint)endPoint{
    
    CGPoint controlPoint = CGPointMake(WIDTH/2, controlPointY +imageH/2);
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, WIDTH/2, controlPointY, endPoint.x, endPoint.y);
    bounceAnimation.path = thePath;
    bounceAnimation.speed = 1 + self.percent;
    bounceAnimation.duration = durtionTime;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.fillMode = kCAFillModeForwards;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.repeatCount=NO;
    bounceAnimation.calculationMode = kCAAnimationCubicPaced;
    //百分比低于0.04解决图片显示不全的问题
    if (self.percent <= 0.04) {
    }else{
        [imageView.layer addAnimation:bounceAnimation forKey:@"move"];
    }
    
    CGPoint endPointLayer = CGPointMake(WIDTH, startPointY + imageH/2);
    CGPoint startPointLayer = CGPointMake(0, startPointY + imageH/2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (_firstLayerLine) {
        [_firstLayerLine removeFromSuperlayer];
        _firstLayerLine = nil;
    }
    _firstLayerLine = [CAShapeLayer layer];
    [path moveToPoint:startPointLayer];
    [path addQuadCurveToPoint:endPointLayer controlPoint:controlPoint];
    
    _firstLayerLine.path = path.CGPath;
    _firstLayerLine.lineWidth = lineW;
    _firstLayerLine.fillColor = [[UIColor clearColor]CGColor];
    _firstLayerLine.strokeColor =  _percentLableColor.CGColor;
    [self.layer addSublayer:_firstLayerLine];
    _firstLayerLine.strokeStart = 0;
    _firstLayerLine.strokeEnd = self.percent;
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"strokeEnd" ;
    animation.speed = 1+ self.percent;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue =[NSNumber numberWithFloat:self.percent];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = durtionTime*self.percent;
    [_firstLayerLine addAnimation:animation forKey:@"moveAway"];
}

#pragma mark
#pragma mark -- 暂停和恢复动画
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 0.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    
}

#pragma mark
#pragma mark ---- 画贝塞尔曲线
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1, 0, 0, 1.0);
    //底部轨迹
    CGContextMoveToPoint(context, 0, startPointY + imageH/2 );//设置Path的起点
    CGContextAddQuadCurveToPoint(context,WIDTH/2, controlPointY +imageH/2, WIDTH, startPointY+ imageH/2);
    //画曲线
    UIBezierPath *bePath = [UIBezierPath bezierPath];
    bePath.lineWidth = lineW;
    [kUIColor(51, 61, 66) setStroke];
    [bePath stroke];
}


#pragma mark    返回不同大小字体的字符串   number－(float)数值      type－类型字符串  normalFont－正常字体     maxFont－大字体
+(NSMutableAttributedString *)setFontStringWithFloatNumber:(float )number withType:(NSString *)type withNormalFont:(float)normalFont withMaxFont:(float)maxFont
{
    NSString *numString=[NSString stringWithFormat:@"%.2f",number];
    NSString *mainString=[NSString stringWithFormat:@"(%@ %@)",numString,type];
    NSMutableAttributedString *attSting=[[NSMutableAttributedString alloc] initWithString:mainString];

    [attSting addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:normalFont] range:NSMakeRange(numString.length,type.length-1)];
    
    return attSting;
}

@end
