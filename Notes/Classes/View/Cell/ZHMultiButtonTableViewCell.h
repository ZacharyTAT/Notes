//
//  ZHMultiButtonTableViewCell.h
//  Notes
//
//  Created by apple on 12/23/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHMultiButtonTableViewCell,ZHNote;

/**
 *  cell上按钮的类型
 */
typedef NS_ENUM(NSInteger, ZHTableViewCellType)
{
    /** 删除按钮 */
    ZHTableViewCellTypeDelete,
    
    /** 置顶按钮 */
    ZHTableViewCellTypeStick,
    
    /** 取消置顶按钮 */
    ZHTableViewCellTypeCancelStick
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
/** 点击了取消置顶按钮 */
- (void)tableViewCellDidCancelStick:(ZHMultiButtonTableViewCell *)tableViewCell;

@end


@interface ZHMultiButtonTableViewCell : UITableViewCell

/** 模型 */
@property (nonatomic, strong)ZHNote *note;


/** 代理 */
@property(nonatomic,weak)id<ZHMultiButtonTableViewCellDelegate> cellDelegate;

@end





