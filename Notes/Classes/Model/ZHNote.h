//
//  ZHNote.h
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  一条笔记记录

#import <Foundation/Foundation.h>

@interface ZHNote : NSObject

/** 标题 */
@property (nonatomic, copy)NSString *title;

/** 修改日期 */
@property (nonatomic, strong)NSDate *modifydate;

/** 笔记具体内容 */
@property (nonatomic, copy)NSString *content;

/**
 *  note模型构造方法
 *
 *  @param title      标题
 *  @param modifydate 修改日期
 *  @param content    具体内容
 *
 *  @return note模型
 */
- (instancetype)initWithTitle:(NSString *)title modifydate:(NSDate *)modifydate content:(NSString *)content;

@end
