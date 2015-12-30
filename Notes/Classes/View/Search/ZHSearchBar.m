//
//  ZHSearchBar.m
//  Notes
//
//  Created by apple on 12/16/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHSearchBar.h"

@interface ZHSearchBar()

@end

@implementation ZHSearchBar


- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    [super setShowsCancelButton:showsCancelButton];
    if (showsCancelButton) {
        UIView *fatherView = self.subviews[0];
        for (UIView *subView in [fatherView subviews]) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *systemCancelBtn = (UIButton *)subView;
                [systemCancelBtn setTitle:@"\t" forState:UIControlStateNormal];
                
                //创建一个label覆盖在上面
                UILabel *cancelLbl = [[UILabel alloc] init];
                cancelLbl.frame = systemCancelBtn.bounds;
                [systemCancelBtn addSubview:cancelLbl];
                cancelLbl.text = @"取消";
                cancelLbl.font = [UIFont systemFontOfSize:15.0];
                cancelLbl.textColor = [UIColor blackColor];
                break;
            }
        }
    }
}

#pragma mark - 去掉文本框的一些自动化行为
- (void)donotDoAutoThings
{
    //01.自动大写(一般指首字母)
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    //02.自动更正错误(发现错误，则自动更正为正确的文字)
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //03.自动检查错误(发现错误，文字下面有红色的虚线)
    self.spellCheckingType = UITextSpellCheckingTypeNo;
}

@end
