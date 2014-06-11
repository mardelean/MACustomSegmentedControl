//
//  MACustomSegmentedControlView.h
//  SegmentedControl
//
//  Created by Madalina Ardelean on 28/05/14.
//  Copyright (c) 2014 Madalina Ardelean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MACustomSegmentedControlView;
@class MABaseSegmentView;

@protocol MACustomSegmentedControlDelegate <NSObject>

@optional

//Selection of a segment

//Returning NO will cause no effect when the user taps the segment. The default value is YES.
- (BOOL)segmentedControl:(MACustomSegmentedControlView *)segmentedControl shouldSelectItemAtIndex:(NSUInteger)index;
- (void)segmentedControl:(MACustomSegmentedControlView *)segmentedControl didSelectItemAtIndex:(NSUInteger)index;
- (void)segmentedControl:(MACustomSegmentedControlView *)segmentedControl didDeselectItemAtIndex:(NSUInteger)index;

@end

@interface MACustomSegmentedControlView : UIView

@property (nonatomic, assign) id<MACustomSegmentedControlDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, assign) CGFloat minLineSpacing; //will return the default value if unset (1.0)
@property (nonatomic, assign) CGFloat minRowSpacing; //will return the default value if unset (1.0)
@property (nonatomic, assign) CGFloat segmentHeight; //will return the default value if unset (36.0)

@property (nonatomic, assign) BOOL allowMultipleSelection;

@property (nonatomic, strong) UIColor *segmentBackgroundColor;
@property (nonatomic, strong) UIColor *selectedSegmentBackgroundColor;
@property (nonatomic, strong) UIColor *segmentTextColor;
@property (nonatomic, strong) UIColor *selectedSegmentTextColor;

//If unset the default number of segments will be the total number of segments in the segmented control
//the orientation supports only the mask of portrait and the mask of landscape
- (void)setNumberOfSegmentsInLine:(NSUInteger)numberOfSegmentsInLine forOrientation:(UIInterfaceOrientationMask)orientation;
- (NSUInteger)numberOfSegmentsInLineForOrientation:(UIInterfaceOrientation)orientation;

- (MABaseSegmentView *)segmentAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfSegment:(MABaseSegmentView *)segment;

- (void)selectSegmentAtIndex:(NSUInteger)index;
- (void)selectSegment:(MABaseSegmentView *)segment;

- (void)deselectSegmentAtIndex:(NSUInteger)index;
- (NSInteger)numberOfSegments;

@end
