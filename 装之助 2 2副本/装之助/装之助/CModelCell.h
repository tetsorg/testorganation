//
//  CModelCell.h
//  装之助
//
//  Created by caiyc on 14/12/1.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CModelCell : UITableViewCell
@property(nonatomic,retain)UIImageView *authImage;
@property(nonatomic,retain)UILabel *authNameLable;
@property(nonatomic,retain)UILabel *distubTimeLable;
@property(nonatomic,retain)UILabel *contentLable;
@property(nonatomic,retain)UILabel *supportLabel;
@property(nonatomic,retain)UILabel *badLabel;
@property(nonatomic,retain)UILabel *collectLabel;
@property(nonatomic,retain)UIButton *supportBtn;
@property(nonatomic,retain)UIButton *badBtn;
@property(nonatomic,retain)UIButton *collectBtn;

@end
