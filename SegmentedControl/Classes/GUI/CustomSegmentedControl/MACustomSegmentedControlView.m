//
//  MACustomSegmentedControlView.m
//  SegmentedControl
//
//  Created by Madalina Ardelean on 28/05/14.
//  Copyright (c) 2014 Madalina Ardelean. All rights reserved.
//

#import "MACustomSegmentedControlView.h"
#import "MASegmentView.h"

@interface MACustomSegmentedControlView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *segments;

@property (nonatomic, assign) NSUInteger numberOfItemsForPortrait;
@property (nonatomic, assign) NSUInteger numberOfItemsForLandscape;

@end

@implementation MACustomSegmentedControlView

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items {
    NSAssert(items, @"Items array should not be nil");

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.numberOfItemsForPortrait = self.numberOfItemsForLandscape = [items count];
        [self addSubview:self.titleLabel];
        [self addItemsToSubview:items];
        [self setupDefaults];

    }
    return self;
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    self.titleLabel.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), labelHeight);
    [self resizeSegments];
}

#pragma mark - Public methods

- (MABaseSegmentView *)segmentAtIndex:(NSUInteger)index {
    if (self.segments[index]) {
        return self.segments[index];
    }
    return nil;
}

- (NSUInteger)indexOfSegment:(MABaseSegmentView *)segment {
    return [self.segments indexOfObject:segment];
}

#pragma mark - Action methods

- (void)selectSegmentAtIndex:(NSUInteger)index {
    MABaseSegmentView *currentSegment = [self segmentAtIndex:index];
    for (MABaseSegmentView *segment in self.segments) {
        if (!self.allowMultipleSelection) {
            if (![currentSegment isEqual:segment]) {
                if ([segment isSelected]) {
                    [self deselectSegmentAtIndex:[self indexOfSegment:segment]];
                }
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(segmentedControl:didSelectItemAtIndex:)]) {
        [self.delegate segmentedControl:self didSelectItemAtIndex:index];
    }
    [currentSegment setSelected:YES];
}

- (void)selectSegment:(MABaseSegmentView *)segment {
    NSUInteger index = [self indexOfSegment:segment];
    [self selectSegmentAtIndex:index];
}

- (void)deselectSegmentAtIndex:(NSUInteger)index {

    if ([self.delegate respondsToSelector:@selector(segmentedControl:didDeselectItemAtIndex:)]) {
        [self.delegate segmentedControl:self didDeselectItemAtIndex:index];
    }
    MABaseSegmentView *segment = [self segmentAtIndex:index];
    segment.selected = NO;    
}

- (NSInteger)numberOfSegments {
    return [self.segments count];
}

- (void)setNumberOfSegmentsInLine:(NSUInteger)numberOfSegmentsInLine forOrientation:(UIInterfaceOrientationMask)orientation {
    
    switch (orientation) {
        case UIInterfaceOrientationMaskPortrait:
            self.numberOfItemsForPortrait = numberOfSegmentsInLine;
            break;
        case UIInterfaceOrientationMaskLandscape:
            self.numberOfItemsForLandscape = numberOfSegmentsInLine;
            break;
        default:
            self.numberOfItemsForLandscape = numberOfSegmentsInLine;
            self.numberOfItemsForPortrait = numberOfSegmentsInLine;
            break;
    }
}

- (NSUInteger)numberOfSegmentsInLineForOrientation:(UIInterfaceOrientation)orientation {
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return self.numberOfItemsForPortrait;
    } else if (UIInterfaceOrientationIsLandscape(orientation)) {
        return self.numberOfItemsForLandscape;
    }
    return 0;
}

#pragma mark - Properties

- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor {
    if ([_segmentBackgroundColor isEqual:segmentBackgroundColor]) {
        return;
    }
    _segmentBackgroundColor = segmentBackgroundColor;
    for (MABaseSegmentView *segment in self.segments) {
        segment.segmentBackgroundColor = _segmentBackgroundColor;
    }
}

- (void)setSegmentTextColor:(UIColor *)segmentTextColor {
    if ([_segmentTextColor isEqual:segmentTextColor]) {
        return;
    }
    _segmentTextColor = segmentTextColor;
    
    for (MABaseSegmentView *segment in self.segments) {
        segment.segmentTextColor = _segmentTextColor;
    }
}

- (void)setSelectedSegmentBackgroundColor:(UIColor *)selectedSegmentBackgroundColor {
    if ([_selectedSegmentBackgroundColor isEqual:selectedSegmentBackgroundColor]) {
        return;
    }
    _selectedSegmentBackgroundColor = selectedSegmentBackgroundColor;
    
    for (MABaseSegmentView *segment in self.segments) {
        segment.selectedSegmentBackgroundColor = _selectedSegmentBackgroundColor;
    }
}

- (void)setSelectedSegmentTextColor:(UIColor *)selectedSegmentTextColor {
    if ([_selectedSegmentTextColor isEqual:selectedSegmentTextColor]) {
        return;
    }
    _selectedSegmentTextColor = selectedSegmentTextColor;
    
    for (MABaseSegmentView *segment in self.segments) {
        segment.selectedTextColor = selectedSegmentTextColor;
    }
}

- (void)setTitle:(NSString *)title {
    if ([_title isEqualToString:title]) {
        return;
    }
    _title = title;
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

#pragma mark - Private methods

- (void)addItemsToSubview:(NSArray *)items {
    NSUInteger count = [items count];
    
    self.segments = [self viewsFromItems:items];
    for (NSUInteger index = 0; index < count; index ++) {
        
         __weak MABaseSegmentView *segment = self.segments[index];
        segment.frame = [self frameForSegmentAtIndex:index];
        segment.shouldSelectSegment = ^{
            BOOL select = YES;
            if ([self.delegate respondsToSelector:@selector(segmentedControl:shouldSelectItemAtIndex:)]) {
                select = [self.delegate segmentedControl:self shouldSelectItemAtIndex:index];
            }
            if (select && ![segment isSelected]) {
                [self selectSegmentAtIndex:index];
            } else if([segment isSelected] && self.allowMultipleSelection) {
                [self deselectSegmentAtIndex:index];
            }
        };
        [self addSubview:segment];
    }
}

- (NSArray *)viewsFromItems:(NSArray *)items {
    NSMutableArray *segmentViews = [NSMutableArray array];
    NSUInteger numberOfItems = [items count];

    for (NSUInteger index = 0; index < numberOfItems; index++) {

        MASegmentView *segmentView;
        if ([items[index] isKindOfClass:[MABaseSegmentView class]]) {
            segmentView = items[index];
        } else {
            segmentView = [[MASegmentView alloc] initWithFrame:CGRectZero];
            segmentView.text = items[index];
        }
        [segmentViews addObject:segmentView];
    }
    return segmentViews;
}

- (CGRect)frameForSegmentAtIndex:(NSUInteger)index {
    CGFloat minLineSpacing = [self minLineSpacing];
    CGFloat minRowSpacing = [self minRowSpacing];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    NSUInteger numberOfItemsForOrientation = [self numberOfSegmentsInLineForOrientation:orientation];
    
    CGFloat segmentWidth = (CGRectGetWidth(self.bounds) - (numberOfItemsForOrientation - 1) * minRowSpacing) / numberOfItemsForOrientation;
    CGFloat space = CGRectGetHeight(self.bounds) * 0.1;

    CGFloat originY;
    CGFloat originX;
    
    if (index >= numberOfItemsForOrientation) {
        NSUInteger lineNumber = index / numberOfItemsForOrientation;
        originX = (index - numberOfItemsForOrientation * lineNumber) * (segmentWidth + minRowSpacing);
        originY = CGRectGetMaxY(self.titleLabel.frame) + space + (self.segmentHeight + minLineSpacing) * lineNumber;
    } else {
        originX = index * (segmentWidth + ((index == 0) ? 0 : minRowSpacing));
        originY = CGRectGetMaxY(self.titleLabel.frame) + space;
    }
    
    CGRect frame = CGRectMake(originX, originY, segmentWidth, self.segmentHeight);
    return frame;
}

- (void)resizeSegments {
    for (MABaseSegmentView *segment in self.segments) {
        segment.frame = [self frameForSegmentAtIndex:[self.segments indexOfObject:segment]];
    }
}

- (void)setupDefaults {
    self.minLineSpacing = 1.0;
    self.minRowSpacing = 1.0;
    self.segmentHeight = 36.0;
    self.segmentBackgroundColor         = [UIColor lightGrayColor];
    self.segmentTextColor               = [UIColor blackColor];
    self.selectedSegmentTextColor       = [UIColor whiteColor];
    self.selectedSegmentBackgroundColor = [UIColor darkGrayColor];
}

@end
