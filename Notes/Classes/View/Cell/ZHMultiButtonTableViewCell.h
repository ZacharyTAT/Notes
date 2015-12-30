//
//  ZHMultiButtonTableViewCell.h
//  Notes
//
//  Created by apple on 12/23/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHMultiButtonTableViewCell;

/**
 *  cell上按钮的类型
 */
typedef NS_ENUM(NSInteger, ZHTableViewCellType)
{
    /** 删除按钮 */
    ZHTableViewCellTypeDelete,
    
    /** 置顶按钮 */
    ZHTableViewCellTypeStick
};

@protocol ZHMultiButtonTableViewCellDelegate <NSObject>

@optional
/**
 *  点击了删除按钮
 */
- (void)tableViewCellDidClickDelete:(ZHMultiButtonTableViewCell *)tableViewCell;

/**
 *  点击了置顶按钮
 */
- (void)tableViewCellDidClickStick:(ZHMultiButtonTableViewCell *)tableViewCell;

@end


@interface ZHMultiButtonTableViewCell : UITableViewCell

@property(nonatomic,weak)id<ZHMultiButtonTableViewCellDelegate> cellDelegate;

@end
