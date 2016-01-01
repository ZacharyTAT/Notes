//
//  ZHNote.h
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  一条笔记记录

#import <Foundation/Foundation.h>

@interface ZHNote : NSObject

/** 笔记的唯一标识 */
@property (nonatomic,assign)NSInteger noteId;

/** 标题 */
@property (nonatomic, copy)NSString *title;

/** 修改日期 */
@property (nonatomic, strong)NSDate *modifydate;

/** 笔记具体内容 */
@property (nonatomic, copy)NSString *content;

/** 是否为置顶项 */
@property (nonatomic,assign,getter = isStick)BOOL stick;

/**
 *  note模型构造方法
 *
 *  @param title      标题
 *  @param modifydate 修改日期
 *  @param content    具体内容
 *  @param stick      是否为置顶项
 *
 *  @return note模型
 */
- (instancetype)initWithTitle:(NSString *)title modifydate:(NSDate *)modifydate content:(NSString *)content stick:(BOOL)stick;

/**
 *  快速创建一个note的方法
 *
 *  @param title      标题
 *  @param modifydate 修改日期
 *  @param content    具体内容
 *  @param stick      是否为置顶项
 *
 *  @return note模型
 */
+ (instancetype)noteWithTitle:(NSString *)title modifydate:(NSDate *)modifydate content:(NSString *)content stick:(BOOL)stick;
@end







