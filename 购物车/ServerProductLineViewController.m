//
//  ServerProductLineViewController.m
//  YIXiuEngineer
//
//  Created by 赵群涛 on 16/5/10.
//  Copyright © 2016年 赵群涛. All rights reserved.
//

#import "ServerProductLineViewController.h"
#import "ProductTableViewCell.h"
#import "UILabel+MyLable.h"
#import "Product.h"
#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(100)]
@interface ServerProductLineViewController ()<UITableViewDelegate,UITableViewDataSource>


{
    //展示数据源数组
    NSMutableArray *dataArray;
    //全选按钮
    UIButton *selectAll;
    //是否全选
    BOOL isSelect;
    
    //已选的商品集合
    NSMutableArray *selectGoods;
}

@property (nonatomic, strong)UITableView *productLineTableView;


@end

@implementation ServerProductLineViewController


-(void)viewWillAppear:(BOOL)animated
{
    //每次进入购物车的时候把选择的置空
    [selectGoods removeAllObjects];
    isSelect = NO;
    selectAll.selected = NO;
    [self creatData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]init];
    selectGoods = [[NSMutableArray alloc]init];
    [self setNav];
    [self createTableView];
}




- (void)createTableView {
    
    self.productLineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.productLineTableView.delegate =self;
    self.productLineTableView.dataSource = self;
    self.productLineTableView.showsVerticalScrollIndicator = NO;
    self.productLineTableView.separatorStyle = 0;
    self.productLineTableView.rowHeight = 50;
    [self.view addSubview:self.productLineTableView];
    
    [self createTopView];
    
}

- (void)createTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    UILabel *label = [UILabel initWithText:@"全部选中" withFontSize:20 WithFontColor:[UIColor blueColor] WithMaxSize:CGSizeMake(100, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(15, 20, 220, 20);
    [topView addSubview:label];
    
    //全选按钮
    selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectAll setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    selectAll.frame = CGRectMake(15, 10, WIDTH - 30, 30);
    [selectAll setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
//    selectAll.backgroundColor = [UIColor lightGrayColor];
    [selectAll setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//
    [selectAll setTitle:@"        " forState:UIControlStateNormal];
    selectAll.imageEdgeInsets = UIEdgeInsetsMake(0,WIDTH - 50,0,selectAll.titleLabel.bounds.size.width);
    [topView addSubview:selectAll];
    
    
    topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:line];
    
    self.productLineTableView.tableHeaderView = topView;
}


-(void)selectAllBtnClick:(UIButton*)button
{
    //点击全选时,把之前已选择的全部删除
    [selectGoods removeAllObjects];
    
    button.selected = !button.selected;
    isSelect = button.selected;
    if (isSelect) {
        
        for (Product *model in dataArray) {
            [selectGoods addObject:model];
        }
       
    }
    else
    {
        [selectGoods removeAllObjects];
       
    }
    
    [self.productLineTableView reloadData];
}

#pragma mark uitableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identifier=@"ProductTableViewCell";
    ProductTableViewCell *productcell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (productcell == nil) {
        productcell = [[ProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    productcell.selectionStyle=UITableViewCellSelectionStyleNone;
    productcell.isSelected = isSelect;
    //是否被选中
    if ([selectGoods containsObject:[dataArray objectAtIndex:indexPath.row]]) {
        productcell.isSelected = YES;
    }
    
    productcell.cartBlock = ^(BOOL isSelec){
        
        if (isSelec) {
            [selectGoods addObject:[dataArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [selectGoods removeObject:[dataArray objectAtIndex:indexPath.row]];
        }
        
        if (selectGoods.count == dataArray.count) {
            selectAll.selected = YES;
        }
        else
        {
            selectAll.selected = NO;
        }
        
    };
    [productcell reloadDataWith:[dataArray objectAtIndex:indexPath.row]];
    
    return productcell;
    
}

-(void)creatData
{
    for (int i = 0; i < 10; i++) {
        Product *model = [[Product alloc]init];
        model.nameStr = MJRandomData;
        [dataArray addObject:model];
    }
    
}


#pragma mark ---配置导航条
- (void)setNav{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *additionBtn = [[UIButton alloc] init];
    [additionBtn setTitle:@"保存" forState:UIControlStateNormal];
    additionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [additionBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [additionBtn addTarget:self action:@selector(saveClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    additionBtn.frame = CGRectMake(0, 0, 40, 25);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:additionBtn];
}


- (void)saveClickBtn:(UIButton *)btn {
    NSLog(@"保存");
    NSString *str= @"";
    for (int i = 0; i < selectGoods.count ; i++) {
        Product *model = [[Product alloc]init];
        model = selectGoods[i];
        str = [str stringByAppendingString:model.nameStr];
        
        
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"保存结果：%@", str] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:true completion:nil];
   
}


@end
