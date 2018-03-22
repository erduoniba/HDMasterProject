//
//  HDBarChartsViewController.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/20.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDBarChartsViewController.h"

#import "HDBarChartsView.h"
#import "HDBarChartsModel.h"

@interface HDBarChartsViewController ()

@property (nonatomic, assign) NSInteger blocks;
@property (nonatomic, assign) NSInteger elements;

@property (nonatomic, strong) HDBarChartsView *barChartsView;

@end

@implementation HDBarChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _barChartsView = [[HDBarChartsView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 300)];
    _barChartsView.blockSpace = 20;
    _barChartsView.maxYAxisValue = 25.0f;
    _barChartsView.yAxisElements = @[@25, @20, @15, @10, @5];
    _barChartsView.barShowAnimateType = HDBarChartsAnimateTypeCurveEaseInOut;
    [self.view addSubview:_barChartsView];

    _blocks = 7;
    _elements = 2;
    [self reloadBarChartsView];


    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(50, 450, 100, 30)];
    [stepper addTarget:self action:@selector(blocksCount:) forControlEvents:UIControlEventValueChanged];
    stepper.value = _blocks;
    stepper.maximumValue = 10;
    stepper.minimumValue = 1;
    [self.view addSubview:stepper];

    UIStepper *stepper2 = [[UIStepper alloc] initWithFrame:CGRectMake(200, 450, 100, 30)];
    [stepper2 addTarget:self action:@selector(elementsCount:) forControlEvents:UIControlEventValueChanged];
    stepper2.value = _elements;
    stepper2.maximumValue = 4;
    stepper2.minimumValue = 1;
    [self.view addSubview:stepper2];
}

- (void)blocksCount:(UIStepper *)stepper {
    _blocks = stepper.value;

    [self reloadBarChartsView];
}

- (void)elementsCount:(UIStepper *)stepper {
    _elements = stepper.value;

    [self reloadBarChartsView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)reloadBarChartsView {
    NSMutableArray *blocks = [NSMutableArray array];
    for (int i=0; i<_blocks; i++) {
        HDBarChartsBlock *block = [HDBarChartsBlock new];
        NSMutableArray *elements = [NSMutableArray array];
        for (int j=0; j<_elements; j++) {
            HDBarChartsElement *element = [HDBarChartsElement new];
            element.value = random()%20;
            element.color = [UIColor colorWithRed:rand()%255/255.0 green:rand()%255/255.0 blue:rand()%255/255.0 alpha:1];
            [elements addObject:element];
        }
        block.elememts = elements;
        block.xAxisTitle = [NSString stringWithFormat:@"11.%d", (int)i+3];
        [blocks addObject:block];
    }
    [_barChartsView reloadBarChartsView:blocks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
