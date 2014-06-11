//
//  MASegmentView.h
//  SegmentedControl
//
//  Created by Madalina Ardelean on 28/05/14.
//  Copyright (c) 2014 Madalina Ardelean. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MABaseSegmentView.h"

@interface MASegmentView : MABaseSegmentView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *labelFont UI_APPEARANCE_SELECTOR;

@end
