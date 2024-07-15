//
//  RLTest3ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/9.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//
#import <MyLayout/MyLayout.h>

#import "RLTest3ViewController.h"
#import "CFTool.h"

@interface RLTest3ViewController ()

@end

@implementation RLTest3ViewController

-(void)loadView
{
    /*
       这个例子展示的相对布局里面某些视图整体居中的实现机制。这个可以通过设置子视图的扩展属性的MyLayoutPos对象的equalTo方法的值为数组来实现。
       对于AutoLayout来说一直被诟病的是要实现某些视图整体在父视图中居中时，需要在外层包裹一个视图，然后再将这个包裹的视图在父视图中居中。而对于MyRelativeLayout来说实现起来则非常的简单。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
    MyRelativeLayout *layout1 = [self createLayout1];  //子视图整体水平居中的布局
    MyRelativeLayout *layout2 = [self createLayout2];  //子视图整体垂直居中的布局
    MyRelativeLayout *layout3 = [self createLayout3];  //子视图整体居中的布局。
   
    layout1.backgroundColor = [CFTool color:0];
    layout2.backgroundColor = [CFTool color:0];
    layout3.backgroundColor = [CFTool color:0];
    
    
    [layout1.widthSize myEqualTo:(rootLayout.widthSize)];
    [layout2.widthSize myEqualTo:(rootLayout.widthSize)];
    [layout3.widthSize myEqualTo:(rootLayout.widthSize)];
    [[layout1.heightSize myEqualTo:(@[[layout2.heightSize myAdd:(-10)], layout3.heightSize])] myAdd:(-10)]; //均分三个布局的高度。
    [[layout2.topPos myEqualTo:(layout1.bottomPos)] myOffset:(10)];
    [[layout3.topPos myEqualTo:(layout2.bottomPos)] myOffset:(10)];
    
    
    [rootLayout addSubview:layout1];
    [rootLayout addSubview:layout2];
    [rootLayout addSubview:layout3];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

-(UILabel*)createLabel:(NSString*)title backgroundColor:(UIColor*)color
{
    UILabel *v = [UILabel new];
    v.backgroundColor = color;
    v.text = title;
    v.font = [CFTool font:17];
    v.textAlignment = NSTextAlignmentCenter;
    [v sizeToFit];
    v.layer.shadowOffset = CGSizeMake(3, 3);
    v.layer.shadowColor = [CFTool color:4].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.3;
    
    
    return v;
}


//子视图整体水平居中的布局
-(MyRelativeLayout*)createLayout1
{
    MyRelativeLayout *layout = [MyRelativeLayout new];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"subviews horz centered in superview", @"");
    titleLabel.font = [CFTool font:16];
    titleLabel.textColor = [CFTool color:4];
    [titleLabel sizeToFit];
    [titleLabel.leadingPos myEqualTo:(@5)];
    [layout addSubview:titleLabel];
    
    
    UIView *v1 = [self createLabel:@"A" backgroundColor:[CFTool color:4]];
    [v1.widthSize myEqualTo:(@100)];
    [v1.heightSize myEqualTo:(@50)];
    [v1.centerYPos myEqualTo:(@0)];
    [layout addSubview:v1];
    
    
    UIView *v2 = [self createLabel:@"B" backgroundColor:[CFTool color:6]];
    [v2.widthSize myEqualTo:(@50)];
    [v2.heightSize myEqualTo:(@30)];
    [v2.centerYPos myEqualTo:(@0)];
    [layout addSubview:v2];
    
    //通过为centerXPos等于一个数组值，表示v1和v2在父布局视图之内整体水平居中,这里的20表示v1和v2之间还有20的间隔。

    [v1.centerXPos myEqualTo:@[[v2.centerXPos myOffset:(20)]]];
    
    
    
    return layout;
}

//子视图整体垂直居中的布局
-(MyRelativeLayout*)createLayout2
{
    MyRelativeLayout *layout = [MyRelativeLayout new];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"subviews vert centered in superview", @"");
    titleLabel.font = [CFTool font:16];
    titleLabel.textColor = [CFTool color:4];
    [titleLabel sizeToFit];
    [titleLabel.leadingPos myEqualTo:(@5)];
    [layout addSubview:titleLabel];
    
    
    UIView *v1 = [self createLabel:@"A" backgroundColor:[CFTool color:5]];
    [v1.widthSize myEqualTo:(@200)];
    [v1.heightSize myEqualTo:(@50)];
    [v1.centerXPos myEqualTo:(@0)];
    [layout addSubview:v1];
    
    
    UIView *v2 = [self createLabel:@"B" backgroundColor:[CFTool color:6]];
    [v2.widthSize myEqualTo:(@200)];
    [v2.heightSize myEqualTo:(@30)];
    [v2.centerXPos myEqualTo:(@0)];
    [layout addSubview:v2];
    
    //通过为centerYPos等于一个数组值，表示v1和v2在父布局视图之内整体垂直居中,这里的20表示v1和v2之间还有20的间隔。
    [v1.centerYPos myEqualTo:@[[v2.centerYPos myOffset:(20)]]];
    
    return layout;
}

//子视图整体居中布局
-(MyRelativeLayout*)createLayout3
{
    MyRelativeLayout *layout = [MyRelativeLayout new];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"subviews centered in superview", @"");
    titleLabel.font = [CFTool font:16];
    titleLabel.textColor = [CFTool color:4];
    [titleLabel sizeToFit];
    [titleLabel.leadingPos myEqualTo:(@5)];
    [layout addSubview:titleLabel];
    
    UILabel *lb1up = [self createLabel:@"top leading" backgroundColor:[CFTool color:5]];
    [layout addSubview:lb1up];
    
    UILabel *lb1down = [self createLabel:@"bottom leading" backgroundColor:[CFTool color:6]];
     [layout addSubview:lb1down];
    
    
    UILabel *lb2up = [self createLabel:@"top center" backgroundColor:[CFTool color:7]];
    [layout addSubview:lb2up];
    
    UILabel *lb2down = [self createLabel:@"center" backgroundColor:[CFTool color:8]];
    [layout addSubview:lb2down];
    
    
    UILabel *lb3up = [self createLabel:@"top trailing" backgroundColor:[CFTool color:9]];
    [layout addSubview:lb3up];
    
    UILabel *lb3down = [self createLabel:@"bottom trailing" backgroundColor:[CFTool color:10]];
    [layout addSubview:lb3down];
    
    //左，中，右三组视图分别整体垂直居中显示，并且下面和上面间隔10
    [lb1up.centerYPos myEqualTo:@[[lb1down.centerYPos myOffset:(10)]]];
    [lb2up.centerYPos myEqualTo:@[[lb2down.centerYPos myOffset:(10)]]];
    [lb3up.centerYPos myEqualTo:@[[lb3down.centerYPos myOffset:(10)]]];
    
    //上面的三个视图整体水平居中显示并且间隔60
    [lb1up.centerXPos myEqualTo:(@[[lb2up.centerXPos myOffset:(60)],[lb3up.centerXPos myOffset:(60)]])];
    
    //下面的三个视图的水平中心点和上面三个视图的水平中心点对齐
    [lb1down.centerXPos myEqualTo:(lb1up.centerXPos)];
    [lb2down.centerXPos myEqualTo:(lb2up.centerXPos)];
    [lb3down.centerXPos myEqualTo:(lb3up.centerXPos)];
    
    
    
    
    return layout;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
