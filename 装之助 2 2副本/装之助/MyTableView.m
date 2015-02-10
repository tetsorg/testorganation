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
   // MyCell *changeCell;
    NSIndexPath *_indexpath;

}
@synthesize dataSource,rowHeight,isFirsts;

-(id)initWithFrame:(CGRect)frame tag:(int)tag{

    self = [super initWithFrame:frame];
    self.tag = tag;
    if(self){
        if (tag == 1) _indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
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
     UIImageView *tImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, tableView.frame.size.width-100, rowHeight-20)];
        //默认选中第一行

    
        if ([_indexpath compare:indexPath] == NSOrderedSame && _indexpath != nil) {

              //红色字体，背景选中图片,
               [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
               cell.textLabel.textColor = [UIColor redColor];
        }else{

           cell.textLabel.textColor = [UIColor blackColor];
        
        }
    
    cell.textLabel.text = dataSource[indexPath.section];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    NSArray *imageArr = @[@"书房",@"卧房",@"厨房",@"客餐厅",@"青少年房"];
    if(rowHeight==80)
    {
        tImage.image = [UIImage imageNamed:imageArr[indexPath.section]];
        [cell.contentView addSubview:tImage];
        
    }

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   

    MyCell *cell = (MyCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor redColor];
    
    if (_indexpath != nil) {
        
        if ([_indexpath compare:indexPath] != NSOrderedSame){
        
            MyCell *deselectCell = (MyCell *)[tableView cellForRowAtIndexPath:_indexpath];
            deselectCell.textLabel.textColor = [UIColor blackColor];
            
        }
        
        
    }
    _indexpath = indexPath;

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
