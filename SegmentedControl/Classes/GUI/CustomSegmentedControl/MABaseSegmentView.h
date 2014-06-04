//
//  MABaseSegmentView.h
//  SegmentedControl
//
//  Created by Madalina Ardelean on 30/05/14.
//  Copyright (c) 2014 Madalina Ardelean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MABaseSegmentView;

typedef void(^ShouldSelectSegment)(void);

@interface MABaseSegmentView : UIView

//The segment will be selected depending on the segmentedControl's delegate method segmentedControl:shouldSelectItemAtIndex:
@property (nonatomic, copy) ShouldSelectSegment shouldSelectSegment;

@property (nonatomic, strong) UIColor *segmentBackgroundColor;
@property (nonatomic, strong) UIColor *selectedSegmentBackgroundColor;
@property (nonatomic, strong) UIColor *segmentTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

@end
