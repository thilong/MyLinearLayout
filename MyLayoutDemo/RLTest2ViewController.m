//
//  RLTest2ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/6.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "RLTest2ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface RLTest2ViewController ()

@property(nonatomic,strong) UIButton *visibilityButton;
@property(nonatomic, strong) UISwitch *visibilitySwitch;

@end

@implementation RLTest2ViewController

-(UIButton*)createButton:(NSString*)title backgroundColor:(UIColor*)color
{
    UIButton *v = [UIButton new];
    v.backgroundColor = color;
    [v setTitle:title forState:UIControlStateNormal];
    [v setTitleColor:[CFTool color:4] forState:UIControlStateNormal];
    v.titleLabel.font = [CFTool font:14];
    v.titleLabel.numberOfLines = 2;
    v.titleLabel.adjustsFontSizeToFitWidth = YES;
    v.layer.shadowOffset = CGSizeMake(3, 3);
    v.layer.shadowColor = [CFTool color:4].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.3;


    return v;
}

-(void)loadView
{
    /*
       这个例子展示的是相对布局里面 多个子视图按比例分配宽度或者高度的实现机制，通过对子视图扩展的MyLayoutSize尺寸对象的equalTo方法的值设置为一个数组对象，即可实现尺寸的按比例分配能力。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.paddingTrailing = 10;
    self.view = rootLayout;
    
    UISwitch *visibilitySwitch = [UISwitch new];
    [visibilitySwitch.trailingPos myEqualTo:(@0)];
    [visibilitySwitch.topPos myEqualTo:(@10)];
    [rootLayout addSubview:visibilitySwitch];
    self.visibilitySwitch = visibilitySwitch;
    
    UILabel *visibilitySwitchLabel = [UILabel new];
    visibilitySwitchLabel.text = NSLocalizedString(@"flex size when subview hidden switch:", @"");
    visibilitySwitchLabel.textColor = [CFTool color:4];
    visibilitySwitchLabel.font = [CFTool font:15];
    [visibilitySwitchLabel sizeToFit];
    [visibilitySwitchLabel.leadingPos myEqualTo:(@10)];
    [visibilitySwitchLabel.centerYPos myEqualTo:(visibilitySwitch.centerYPos)];
    [rootLayout addSubview:visibilitySwitchLabel];
    
    
    /**水平平分3个子视图**/
    UIButton *v1 = [self createButton:NSLocalizedString(@"average 1/3 width\nturn above switch", @"") backgroundColor:[CFTool color:5]];
    [v1.heightSize myEqualTo:(@40)];
    [v1.topPos myEqualTo:(@60)];
    [v1.leadingPos myEqualTo:(@10)];
    [rootLayout addSubview:v1];
    
    
    UIButton *v2 = [self createButton:NSLocalizedString(@"average 1/3 width\nhide me", @"") backgroundColor:[CFTool color:6]];
    [v2 addTarget:self action:@selector(handleHidden:) forControlEvents:UIControlEventTouchUpInside];
    [v2.heightSize myEqualTo:(v1.heightSize)];
    [v2.topPos myEqualTo:(v1.topPos)];
    [[v2.leadingPos myEqualTo:(v1.trailingPos)] myOffset:(10)];
    [rootLayout addSubview:v2];
    self.visibilityButton = v2;
    

    UIButton *v3 = [self createButton:NSLocalizedString(@"average 1/3 width\nshow me", @"") backgroundColor:[CFTool color:7]];
    [v3 addTarget:self action:@selector(handleShow:) forControlEvents:UIControlEventTouchUpInside];
    [v3.heightSize myEqualTo:(v1.heightSize)];
    [v3.topPos myEqualTo:(v1.topPos)];
    [[v3.leadingPos myEqualTo:(v2.trailingPos)] myOffset:(10)];
    [rootLayout addSubview:v3];
    

    //v1,v2,v3平分父视图的宽度。因为每个子视图之间都有10的间距，因此平分时要减去这个间距值。这里的宽度通过设置等于数组来完成均分。
    [[v1.widthSize myEqualTo:(@[[v2.widthSize myAdd:(-10)], [v3.widthSize myAdd:(-10)]])] myAdd:(-10)];
    

    
    /**某个视图宽度固定其他平分**/
    UIButton *v4 = [self createButton:NSLocalizedString(@"width equal to 160", @"") backgroundColor:[CFTool color:5]];
    [[v4.topPos myEqualTo:(v1.bottomPos)] myOffset:(30)];
    [v4.leadingPos myEqualTo:(@10)];
    [v4.heightSize myEqualTo:(@40)];
    [v4.widthSize myEqualTo:(@160)]; //第一个视图宽度固定
    [rootLayout addSubview:v4];
    
    
    UIButton *v5 = [self createButton:NSLocalizedString(@"1/2 with of free superview", @"") backgroundColor:[CFTool color:6]];
    [v5.topPos myEqualTo:(v4.topPos)];
    [[v5.leadingPos myEqualTo:(v4.trailingPos)] myOffset:(10)];
    [v5.heightSize myEqualTo:(v4.heightSize)];
    [rootLayout addSubview:v5];
    

    UIButton *v6 = [self createButton:NSLocalizedString(@"1/2 with of free superview", @"") backgroundColor:[CFTool color:7]];
    [v6.topPos myEqualTo:(v4.topPos)];
    [[v6.leadingPos myEqualTo:(v5.trailingPos)] myOffset:(10)];
    [v6.heightSize myEqualTo:(v4.heightSize)];
    [rootLayout addSubview:v6];
    
    
    //v4宽度固定,v5,v6按一定的比例来平分父视图的宽度，这里同样也是因为每个子视图之间有间距，因此都要减10
    [[v5.widthSize myEqualTo:(@[[v4.widthSize myAdd:(-10)], [v6.widthSize myAdd:(-10)]])] myAdd:(-10)];
    
    
    
    
    /**子视图按比例平分**/
    UIButton *v7 = [self createButton:NSLocalizedString(@"20% with of superview", @"") backgroundColor:[CFTool color:5]];
    [[v7.topPos myEqualTo:(v4.bottomPos)] myOffset:(30)];
    [v7.leadingPos myEqualTo:(@10)];
    [v7.heightSize myEqualTo:(@40)];
    [rootLayout addSubview:v7];
    
    
    UIButton *v8 = [self createButton:NSLocalizedString(@"30% with of superview", @"") backgroundColor:[CFTool color:6]];
    [v8.topPos myEqualTo:(v7.topPos)];
    [[v8.leadingPos myEqualTo:(v7.trailingPos)] myOffset:(10)];
    [v8.heightSize myEqualTo:(v7.heightSize)];
    [rootLayout addSubview:v8];
    
    
    UIButton *v9 = [self createButton:NSLocalizedString(@"50% with of superview", @"") backgroundColor:[CFTool color:7]];
    [v9.topPos myEqualTo:(v7.topPos)];
    [[v9.leadingPos myEqualTo:(v8.trailingPos)] myOffset:(10)];
    [v9.heightSize myEqualTo:(v7.heightSize)];
    [rootLayout addSubview:v9];
    
    //v7,v8,v9按照2：3：5的比例均分父视图。
    [[[v7.widthSize myEqualTo:(@[[[v8.widthSize myMultiply:(0.3)] myAdd:(-10)],[[v9.widthSize myMultiply:(0.5)] myAdd:(-10)]])] myMultiply:(0.2)] myAdd:(-10)];
    
    
    /*
       下面部分是一个高度均分的实现方法。
     */
    
    MyRelativeLayout * bottomLayout = [MyRelativeLayout new];
    bottomLayout.backgroundColor = [CFTool color:0];
    [bottomLayout.leadingPos myEqualTo:(@10)];
    [bottomLayout.trailingPos myEqualTo:(@0)];
    [[bottomLayout.topPos myEqualTo:(v7.bottomPos)] myOffset:(30)];
    [bottomLayout.bottomPos myEqualTo:(@10)];
    [rootLayout addSubview:bottomLayout];
    
    /*高度均分*/
    UIButton *v10 = [self createButton:@"1/2" backgroundColor:[CFTool color:5]];
    [v10.widthSize myEqualTo:(@40)];
    [[v10.trailingPos myEqualTo:(bottomLayout.centerXPos)] myOffset:(50)];
    [v10.topPos myEqualTo:(@10)];
    [bottomLayout addSubview:v10];
    
    UIButton *v11 = [self createButton:@"1/2" backgroundColor:[CFTool color:6]];
    [v11.widthSize myEqualTo:(v10.widthSize)];
    [v11.trailingPos myEqualTo:(v10.trailingPos)];
    [[v11.topPos myEqualTo:(v10.bottomPos)] myOffset:(10)];
    [bottomLayout addSubview:v11];

    //V10,V11实现了高度均分
    [[v10.heightSize myEqualTo:(@[[v11.heightSize myAdd:(-20)]])] myAdd:(-10)];
    
    
    UIButton *v12 = [self createButton:@"1/3" backgroundColor:[CFTool color:5]];
    [v12.widthSize myEqualTo:(@40)];
    [[v12.leadingPos myEqualTo:(bottomLayout.centerXPos)] myOffset:(50)];
    [v12.topPos myEqualTo:(@10)];
    [bottomLayout addSubview:v12];
    
    UIButton *v13 = [self createButton:@"1/3" backgroundColor:[CFTool color:6]];
    [v13.widthSize myEqualTo:(v12.widthSize)];
    [v13.leadingPos myEqualTo:(v12.leadingPos)];
    [[v13.topPos myEqualTo:(v12.bottomPos) ]  myOffset:(10)];
    [bottomLayout addSubview:v13];
    
    UIButton *v14 = [self createButton:@"1/3" backgroundColor:[CFTool color:7]];
    [v14.widthSize myEqualTo:(v12.widthSize)];
    [v14.leadingPos myEqualTo:(v12.leadingPos)];
    [[v14.topPos myEqualTo:(v13.bottomPos)] myOffset:(10)];
    [bottomLayout addSubview:v14];
    
    //注意这里最后一个偏移-20，也能达到和底部边距的效果。
    [[v12.heightSize myEqualTo:(@[[v13.heightSize myAdd:(-10)],[v14.heightSize myAdd:(-20)]])] myAdd:(-10)];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Handle Method

-(void)handleHidden:(UIButton*)sender
{
    if (self.visibilitySwitch.isOn)
    {
        self.visibilityButton.visibility = MyVisibility_Gone;
    }
    else
    {
        self.visibilityButton.visibility = MyVisibility_Invisible;
    }

}

-(void)handleShow:(UIButton*)sender
{
    self.visibilityButton.visibility = MyVisibility_Visible;
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
