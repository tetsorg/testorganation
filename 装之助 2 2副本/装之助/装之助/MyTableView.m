//
//  MyTableView.m
//  SliderView
//
//  Created by Jeffrey on 14-11-14.
//  Copyright (c) 2014年 Jeffrey_wjx. All rights reserved.
//

#import "MyTableView.h"
#import "MyCell.h"
@implementation MyTableView{

  @private
    UITableView *talbe;
    //选中颜色改变
    //保存之前选中的cell，用于颜色还原
    MyCell *changeCell;

}
@synthesize dataSource,rowHeight;

-(id)initWithFrame:(CGRect)frame tag:(int)tag{

    self = [super initWithFrame:frame];
    self.tag = tag;
    if(self){
       
        [self produceContentView];
    
    }

    return self;
}

-(void)setFrame:(CGRect)frame{

    [super setFrame:frame];
    talbe.frame = self.bounds;

}
-(void)produceContentView{

    talbe = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    talbe.backgroundColor = [UIColor clearColor];
    talbe.delegate = self;
    talbe.dataSource = self;
    [self addSubview:talbe];

}
-(void)setRowHeight:(float)ht{

    rowHeight = ht;
    talbe.rowHeight = rowHeight;

}
-(void)setDataSource:(NSArray *)ds{

     dataSource = ds;
    [talbe reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return dataSource.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIndentifer = @"cell";
    MyCell *cell= [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if(!cell){
        
        cell = [[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *secImgView = [[UIImageView alloc]initWithFrame:cell.bounds];
        secImgView.image = self.selectImage;
        cell.selectedBackgroundView = secImgView;
       
    }
    //默认选中第一行
    if (indexPath.section == 0 && self.tag == 1){
        
         [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
         changeCell =  cell;
    }
   
    
    cell.textLabel.textColor = (indexPath.section==0 && self.tag == 1) ? [UIColor redColor]:[UIColor blackColor];
    cell.textLabel.text = dataSource[indexPath.section];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"点击了要刷新数据");
    MyCell *cell = (MyCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(![cell isEqual:changeCell]){
     
        NSLog(@"是不一样的");
        cell.textLabel.textColor = [UIColor redColor];
        changeCell.textLabel.textColor = [UIColor blackColor];
        changeCell = cell;
    
    }
    [self.delegate tableViewdisSelectRow:indexPath mark:self.tag];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
