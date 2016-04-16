//
//  ZHTextField.m
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHTextField.h"

@interface ZHTextField()

@end

@implementation ZHTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
//    self.backgroundColor = [UIColor blueColor];

    
    //01.关闭自动检查
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //02.关闭自动打开大写键
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    

}



@end
