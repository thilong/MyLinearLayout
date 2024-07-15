//
//  RLTest1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/26.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "RLTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@implementation RLTest1ViewController

-(void)loadView
{
    /*
       这个DEMO，主要介绍相对布局里面的子视图如果通过扩展属性MyLayoutPos对象属性来设置各视图之间的依赖关系。
       苹果系统原生的AutoLayout其本质就是一套相对布局体系。但是MyRelativeLayout所具有的功能比AutoLayout还要强大。
     */
    
    /*
       对于相对视图中子视图的位置对象MyLayoutPos中的equalTo方法和offset方法设置为数值时的意义有部分同学不是很明白，这里面统一解释清楚
      1.如果leftPos、rightPos、topPos、bottomPos中的equalTo方法中设置为一个数值的话，这个数表示的是位置离父视图的边距值。当设置为正数是就是内缩而设置为负数时就是外延。比如A.leftPos.equalTo(@10)表示A的左边距离父视图的左边10的位置，A.rightPos.equalTo(@10)表示A的右边距离父视图的右边10的位置。A.topPos.equalTo(@-10)表示A的上边在父视图的上边-10的位置。从例子可以看出这里的数值的正负是和位置本身相关的。
     2.MyLayoutPos中的offset方法表示位置值的偏移量，而这个偏移量的正负数的意义则是根据位置的不同而不同的。
        2.1.如果是leftPos和centerXPos那么正数表示往右偏移，负数表示往左偏移。
        2.2.如果是topPos和centerYPos那么正数表示往下偏移，负数表示往上偏移。
        2.3.如果是rightPos那么正数表示往左偏移，负数表示往右偏移。
        2.4.如果是bottomPos那么正数表示往上偏移，负数表示往下偏移。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.insetsPaddingFromSafeArea = ~UIRectEdgeBottom;  //默认情况下底部的安全区会和布局视图的底部padding进行叠加，当这样设置后底部安全区将不会叠加到底部的padding上去。您可以注释这句代码看看效果。
    self.view = rootLayout;

    
    //mylayout提供了类似Masonry的布局设置语法，你可以通过属性进行布局，也可以用makeLayout方式来进行设置。通过makeLayout方式设置时，子视图可以在任意时刻设置。
    //通过makeLayout方法设置布局不局限于在相对布局下，可以在任何布局下设置。
    /*
     [rootLayout makeLayout:^(MyMaker *make) {
     make.padding.equalTo(@10);
     }];
     */

    /*
       顶部区域部分
     */
    UILabel *todayLabel = [UILabel new];
    todayLabel.text = @"Today";
    todayLabel.font = [CFTool font:17];
    todayLabel.textColor = [CFTool color:4];
    [todayLabel sizeToFit];
    [todayLabel.centerXPos myEqualTo:(@0)];  //水平中心点在父布局水平中心点的偏移为0，意味着和父视图水平居中对齐。
    [todayLabel.topPos myEqualTo:(@20)];     //顶部离父视图的边距为20
    [rootLayout addSubview:todayLabel];
    /*
     [todayLabel makeLayout:^(MyMaker *make) {
     
     make.centerX.equalTo(@0);
     make.top.equalTo(@20);
     make.sizeToFit;
     }];
     */
    
    /*
       左上角区域部分
     */
    UIView *topLeftCircle = [UIView new];
    topLeftCircle.backgroundColor = [CFTool color:2];
    [[[topLeftCircle.widthSize myEqualTo:(rootLayout.widthSize)] myMultiply:(3/5.0)] myMax:(200)]; //宽度是父视图宽度的3/5,且最大只能是200。
    [topLeftCircle.heightSize myEqualTo:(topLeftCircle.widthSize)];    //高度和自身宽度相等。
    [topLeftCircle.leadingPos myEqualTo:(@10)];    //左边距离父视图10
    [topLeftCircle.topPos myEqualTo:(@90)];     //顶部距离父视图90
    [rootLayout addSubview:topLeftCircle];
    
    __weak UIView* weakGreenCircle = topLeftCircle;
    rootLayout.rotationToDeviceOrientationBlock = ^(MyBaseLayout *layout, BOOL isFirst, BOOL isPortrait)
    {//rotationToDeviceOrientationBlock是在布局视图第一次布局后或者有屏幕旋转时给布局视图一个机会进行一些特殊设置的block。这里面我们将子视图的半径设置为尺寸的一半，这样就可以实现在任意的屏幕上，这个子视图总是呈现为圆形。这里rotationToDeviceOrientationBlock和子视图的viewLayoutCompleteBlock的区别是前者是针对布局的，后者是针对子视图的。前者是在布局视图第一次完成布局或者后续屏幕有变化时布局视图调用，而后者则是子视图在布局视图完成后调用。
        //这里不用子视图的viewLayoutCompleteBlock原因是，viewLayoutCompleteBlock只会在布局后执行一次，无法捕捉屏幕旋转的情况，而因为这里面的子视图的宽度是依赖于父视图的，所以必须要用rotationToDeviceOrientationBlock来实现。
        weakGreenCircle.layer.cornerRadius = weakGreenCircle.frame.size.width / 2;

    };
    /*
     [topLeftCircle makeLayout:^(MyMaker *make) {
     
     make.width.equalTo(rootLayout).multiply(3/5.0).max(@200);
     make.height.equalTo(topLeftCircle.widthSize);
     make.leading.equalTo(@10);
     make.top.equalTo(@90);
     
     }];
     */

    
    UILabel *walkLabel = [UILabel new];
    walkLabel.text = @"Walk";
    walkLabel.textColor = [CFTool color:5];
    walkLabel.font = [CFTool font:15];
    [walkLabel sizeToFit];
    [walkLabel.centerXPos myEqualTo:(topLeftCircle.centerXPos)];      //水平中心点和greenCircle水平中心点一致，意味着和greenCircle水平居中对齐。
    [[walkLabel.bottomPos myEqualTo:(topLeftCircle.topPos)] myOffset:(5)];  //底部是greenCircle的顶部再往上偏移5个点。
    [rootLayout addSubview:walkLabel];
   /* 
    [walkLabel makeLayout:^(MyMaker *make) {
        
        make.centerX.equalTo(topLeftCircle.centerXPos);
        make.bottom.equalTo(topLeftCircle.topPos).offset(5);
        make.sizeToFit;
        
    }];
    */
    
    UILabel *walkSteps = [UILabel new];
    walkSteps.text = @"9,362";
    walkSteps.font = [CFTool font:15];
    walkSteps.textColor = [CFTool color:0];
    [walkSteps sizeToFit];
    [walkSteps.centerXPos myEqualTo:(topLeftCircle.centerXPos)];
    [walkSteps.centerYPos myEqualTo:(topLeftCircle.centerYPos)];   //水平中心点和垂直中心点都和greenCircle一样，意味着二者居中对齐。
    [rootLayout addSubview:walkSteps];
   /*
    [walkSteps makeLayout:^(MyMaker *make) {
        
        make.center.equalTo(topLeftCircle);
        make.sizeToFit;
        
    }];
    */
    
    
    UILabel *steps = [UILabel new];
    steps.text = @"steps";
    steps.textColor = [CFTool color:8];
    steps.font = [CFTool font:15];
    [steps sizeToFit];
    [steps.centerXPos myEqualTo:(walkSteps.centerXPos)];  //和walkSteps水平居中对齐。
    [steps.topPos myEqualTo:(walkSteps.bottomPos)];       //顶部是walkSteps的底部。
    [rootLayout addSubview:steps];
    /*
    [steps makeLayout:^(MyMaker *make) {
        
        make.centerX.equalTo(walkSteps.centerXPos);
        make.top.equalTo(walkSteps.bottomPos);
        make.sizeToFit;
    }];
    */
    
    /*
      右上角区域部分
     */
    UIView *topRightCircle = [UIView new];
    topRightCircle.backgroundColor = [CFTool color:3];
    [[topRightCircle.topPos myEqualTo:(topLeftCircle.topPos)] myOffset:(-10)];  //顶部和greenCircle顶部对齐，并且往上偏移10个点。
    [[topRightCircle.trailingPos myEqualTo:(rootLayout.trailingPos)] myOffset:(10)];  //右边和布局视图右对齐，并且往左边偏移10个点。
    [topRightCircle.widthSize myEqualTo:(@120)];                           //宽度是120
    [topRightCircle.heightSize myEqualTo:(topRightCircle.widthSize)];           //高度和宽度相等。
    topRightCircle.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
    {//viewLayoutCompleteBlock是在子视图布局完成后给子视图一个机会进行一些特殊设置的block。这里面我们将子视图的半径设置为尺寸的一半，这样就可以实现在任意的屏幕上，这个子视图总是呈现为圆形。viewLayoutCompleteBlock只会在布局完成后调用一次，就会被布局系统销毁。
        sbv.layer.cornerRadius = sbv.frame.size.width / 2;
    };
    [rootLayout addSubview:topRightCircle];
    /*
    [topRightCircle makeLayout:^(MyMaker *make) {
        
        make.top.equalTo(topLeftCircle).offset(-10);
        make.trailing.equalTo(rootLayout).offset(10);
        make.width.equalTo(@120);
        make.height.equalTo(topRightCircle.widthSize);
        
    }];
    */
    
    UILabel *cycleLabel = [UILabel new];
    cycleLabel.text = @"Cycle";
    cycleLabel.textColor = [CFTool color:6];
    cycleLabel.font = [CFTool font:15];
    [cycleLabel sizeToFit];
    [cycleLabel.centerXPos myEqualTo:(topRightCircle.centerXPos)];        //和blueCircle水平居中对齐
    [[cycleLabel.bottomPos myEqualTo:(topRightCircle.topPos)] myOffset:(5)];   //底部在blueCircle的上面，再往下偏移5个点。
    [rootLayout addSubview:cycleLabel];
    /*
    [cycleLabel makeLayout:^(MyMaker *make) {
        
        make.centerX.equalTo(topRightCircle.centerXPos);
        make.bottom.equalTo(topRightCircle.topPos).offset(5);
        make.sizeToFit;
        
    }];
    */
    
    UILabel *cycleMin = [UILabel new];
    cycleMin.text = @"39 Min";
    cycleMin.textColor = [CFTool color:0];
    cycleMin.font = [CFTool font:15];
    [cycleMin sizeToFit];
    [cycleMin.leadingPos myEqualTo:(topRightCircle.leadingPos)];     //左边和blueCircle左对齐
    [cycleMin.centerYPos myEqualTo:(topRightCircle.centerYPos)];  //和blueCircle垂直居中对齐。
    [rootLayout addSubview:cycleMin];
    /*
    [cycleMin makeLayout:^(MyMaker *make) {
        
        make.leading.centerY.equalTo(topRightCircle);
        make.sizeToFit;
        
    }];
    */
    
 
    /*
       中间区域部分
     */
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [CFTool color:7];
    [lineView1.leadingPos myEqualTo:(@0)];
    [lineView1.trailingPos myEqualTo:(@0)];  //和父布局的左右边距为0，这个也同时确定了视图的宽度和父视图一样。
    [lineView1.heightSize myEqualTo:(@2)];  //高度固定为2
    [lineView1.centerYPos myEqualTo:(@0)];   //和父视图垂直居中对齐。
    [rootLayout addSubview:lineView1];
    /*
    [lineView1 makeLayout:^(MyMaker *make) {
        
        make.leading.trailing.centerY.equalTo(@0);
        make.height.equalTo(@2);
    }];
    */
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [CFTool color:8];
    [[lineView2.widthSize myEqualTo:(rootLayout.widthSize)] myAdd:(-20)];  //宽度等于父视图的宽度减20
    [lineView2.heightSize myEqualTo:(@2)];                            //高度固定为2
    [[lineView2.topPos myEqualTo:(lineView1.bottomPos)] myOffset:(2)];    //顶部在lineView1的下面往下偏移2
    [lineView2.centerXPos myEqualTo:(rootLayout.centerXPos)];       //和父视图水平居中对齐
    [rootLayout addSubview:lineView2];
   /* 
    [lineView2 makeLayout:^(MyMaker *make) {
        
        make.width.equalTo(rootLayout).add(-20);
        make.height.equalTo(@2);
        make.top.equalTo(lineView1.bottomPos).offset(2);
        make.centerX.equalTo(rootLayout);
        
    }];
    */
    
    UIView *squareView = [UIView new];
    squareView.backgroundColor = [CFTool color:9];
    //宽度是父布局宽度和高度二者之间的最小值的1/5, 高度等于宽度。
    //这里面用到了数组的一个扩展属性myMinSize。要求数组中的元素必须是MyLayoutSize类型，而且这些值也必须在本视图约束计算前已经有明确的值。
    [[squareView.widthSize myEqualTo:(@[rootLayout.widthSize, rootLayout.heightSize].myMinSize)] myMultiply:(0.2)];
    [squareView.heightSize myEqualTo:(squareView.widthSize)];
    [squareView.centerXPos myEqualTo:(rootLayout.centerXPos)];
    [[squareView.centerYPos myEqualTo:(rootLayout.centerYPos)] myOffset:(40)];
    [rootLayout addSubview:squareView];
    
    
    /*
       左下角区域部分。
     */
    UIView *bottomHalfCircleView = [UIView new];
    bottomHalfCircleView.backgroundColor = [CFTool color:5];
    bottomHalfCircleView.layer.cornerRadius = 25;
    [bottomHalfCircleView.widthSize myEqualTo:(@50)];      //宽度固定为50
    [bottomHalfCircleView.heightSize myEqualTo:(bottomHalfCircleView.widthSize)];  //高度等于宽度
    [[bottomHalfCircleView.centerYPos myEqualTo:(rootLayout.bottomPos)] myOffset:(10)]; //垂直中心点和父布局的底部对齐，并且往下偏移10个点。 因为rootLayout设置了paddingBottom为10，所以这里要偏移10，否则不需要设置偏移。
    [[bottomHalfCircleView.leadingPos myEqualTo:(rootLayout.leadingPos)] myOffset:(50)]; //左边父布局左对齐，并且向右偏移50个点。
    [rootLayout addSubview:bottomHalfCircleView];
    /*
    [bottomHalfCircleView makeLayout:^(MyMaker *make) {
        
        make.width.equalTo(@50);
        make.height.equalTo(bottomHalfCircleView.widthSize);
        make.centerY.equalTo(rootLayout.bottomPos).offset(10);
        make.leading.equalTo(rootLayout).offset(50);
        
    }];
    */
    
    UIView *lineView3 = [UIView new];
    lineView3.backgroundColor = [CFTool color:5];
    [lineView3.widthSize myEqualTo:(@5)];
    [lineView3.heightSize myEqualTo:(@50)];
    [lineView3.bottomPos myEqualTo:(bottomHalfCircleView.topPos)];
    [lineView3.centerXPos myEqualTo:(bottomHalfCircleView.centerXPos)];
    [rootLayout addSubview:lineView3];
    /*
    [lineView3 makeLayout:^(MyMaker *make) {
        
        make.width.equalTo(@5).height.equalTo(@50).bottom.equalTo(bottomHalfCircleView.topPos).centerX.equalTo(bottomHalfCircleView);
        
    }];
    */
    
    UILabel *walkLabel2 = [UILabel new];
    walkLabel2.text = @"Weight";
    walkLabel2.font = [CFTool font:15];
    walkLabel2.textColor = [CFTool color:11];
    [walkLabel2 sizeToFit];
    [[walkLabel2.leadingPos myEqualTo:(lineView3.trailingPos)] myOffset:(15)];
    [walkLabel2.centerYPos myEqualTo:(lineView3.centerYPos)];
    [rootLayout addSubview:walkLabel2];
    /*
    [walkLabel2 makeLayout:^(MyMaker *make) {
        
        make.leading.equalTo(lineView3.trailingPos).offset(15);
        make.centerY.equalTo(lineView3);
        make.sizeToFit;
    }];
    */
     
    UILabel *walkLabel3 = [UILabel new];
    walkLabel3.text = @"70 kg";
    walkLabel3.font = [CFTool font:20];
    walkLabel3.textColor = [CFTool color:12];
    [walkLabel3 sizeToFit];
    [[walkLabel3.leadingPos myEqualTo:(walkLabel2.trailingPos)] myOffset:(5)];
    [walkLabel3.baselinePos myEqualTo:(walkLabel2.baselinePos)];  //walkLabel3的基线和walkLabel2的基线对齐。
    [rootLayout addSubview:walkLabel3];
    /*
    [walkLabel3 makeLayout:^(MyMaker *make) {
        
        make.leading.equalTo(walkLabel2.trailingPos).offset(5);
        make.baseline.equalTo(walkLabel2);
        make.sizeToFit;
        
    }];
    */

    UILabel *timeLabel1 = [UILabel new];
    timeLabel1.text = @"9:12";
    timeLabel1.font = [CFTool font:14];
    timeLabel1.textColor = [CFTool color:12];
    [timeLabel1 sizeToFit];
    [[timeLabel1.trailingPos myEqualTo:(lineView3.leadingPos)] myOffset:(25)];
    [timeLabel1.centerYPos myEqualTo:(lineView3.topPos)];
    [rootLayout addSubview:timeLabel1];
    /*
    [timeLabel1 makeLayout:^(MyMaker *make) {
        
        make.trailing.equalTo(lineView3.leadingPos).offset(25);
        make.centerY.equalTo(lineView3.topPos);
        make.sizeToFit;
        
    }];
    */
    
    UILabel *timeLabel2 = [UILabel new];
    timeLabel2.text = @"9:30";
    timeLabel2.font = [CFTool font:14];
    timeLabel2.textColor = [CFTool color:12];
    [timeLabel2 sizeToFit];
    [timeLabel2.trailingPos myEqualTo:(timeLabel1.trailingPos)];
    [timeLabel2.centerYPos myEqualTo:(lineView3.bottomPos)];
    [rootLayout addSubview:timeLabel2];
    /*
    [timeLabel2 makeLayout:^(MyMaker *make) {
        
        make.trailing.equalTo(timeLabel1);
        make.centerY.equalTo(lineView3.bottomPos);
        make.sizeToFit;
        
    }];
    */
    
    UIView *lineView4 = [UIView new];
    lineView4.backgroundColor = [CFTool color:5];
    lineView4.layer.cornerRadius = 25;
    [lineView4.widthSize myEqualTo:(bottomHalfCircleView.widthSize)];
    [[lineView4.heightSize myEqualTo:(lineView4.widthSize)] myAdd:(30)];
    [lineView4.bottomPos myEqualTo:(lineView3.topPos)];
    [lineView4.centerXPos myEqualTo:(lineView3.centerXPos)];
    [rootLayout addSubview:lineView4];
    /*
    [lineView4 makeLayout:^(MyMaker *make) {
        
        make.width.equalTo(bottomHalfCircleView);
        make.height.equalTo(lineView4.widthSize).add(30);
        make.bottom.equalTo(lineView3.topPos);
        make.centerX.equalTo(lineView3);
    }];
     */
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    [[imageView4.widthSize myEqualTo:(lineView4.widthSize)] myMultiply:(1/3.0)];
    [imageView4.heightSize myEqualTo:(imageView4.widthSize)];
    [imageView4.centerXPos myEqualTo:(lineView4.centerXPos)];
    [imageView4.centerYPos myEqualTo:(lineView4.centerYPos)];
    [rootLayout addSubview:imageView4];
    /*
    [imageView4 makeLayout:^(MyMaker *make) {
        
        make.width.equalTo(lineView4).multiply(1/3.0);
        make.height.equalTo(imageView4.widthSize);
        make.center.equalTo(lineView4);
     
    }];
    */
    
    UILabel *homeLabel = [UILabel new];
    homeLabel.text = @"Home";
    homeLabel.font = [CFTool font:15];
    homeLabel.textColor = [CFTool color:4];
    [homeLabel sizeToFit];
    [[homeLabel.leadingPos myEqualTo:(lineView4.trailingPos)] myOffset:(10)];
    [homeLabel.centerYPos myEqualTo:(lineView4.centerYPos)];
    [rootLayout addSubview:homeLabel];
    /*
    [homeLabel makeLayout:^(MyMaker *make) {
        
        make.leading.equalTo(lineView4.trailingPos).offset(10);
        make.centerY.equalTo(lineView4);
        make.sizeToFit;
        
    }];
    */
    
    /*
      右下角区域部分。
     */
    UIImageView *bottomRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    [bottomRightImageView.trailingPos myEqualTo:(rootLayout.trailingPos)];
    [bottomRightImageView.bottomPos myEqualTo:(rootLayout.bottomPos)];
    [rootLayout addSubview:bottomRightImageView];
    /*
    [bottomRightImageView makeLayout:^(MyMaker *make) {
        make.trailing.bottom.equalTo(rootLayout);
    }];
     */
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

@end
