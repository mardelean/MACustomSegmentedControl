//
//  MASegmentView.m
//  SegmentedControl
//
//  Created by Madalina Ardelean on 28/05/14.
//  Copyright (c) 2014 Madalina Ardelean. All rights reserved.
//

#import "MASegmentView.h"

@interface MASegmentView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation MASegmentView

@synthesize segmentBackgroundColor = _segmentBackgroundColor;
@synthesize segmentTextColor = _segmentTextColor;
@synthesize selected = _selected;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

#pragma mark - Action method

- (void)handleTap:(UIPanGestureRecognizer *)gesture {
    self.shouldSelectSegment();
}

#pragma mark - Properties

- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor {
    if ([_segmentBackgroundColor isEqual:segmentBackgroundColor]) {
        return;
    }
    _segmentBackgroundColor = segmentBackgroundColor;
    self.backgroundColor = _segmentBackgroundColor;
}

- (void)setSegmentTextColor:(UIColor *)segmentTextColor {
    if ([_segmentTextColor isEqual:segmentTextColor]) {
        return;
    }
    _segmentTextColor = segmentTextColor;
    self.textLabel.textColor = _segmentTextColor;
}

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return;
    }
    _selected = selected;
    
    if (_selected) {
        self.backgroundColor = self.selectedSegmentBackgroundColor;
        self.textLabel.textColor = self.selectedTextColor;
    } else {
        self.backgroundColor = self.segmentBackgroundColor;
        self.textLabel.textColor = self.segmentTextColor;
    }
}

- (void)setLabelFont:(UIFont *)labelFont {
    if ([_labelFont isEqual:labelFont]) {
        return;
    }
    _labelFont = labelFont;
    self.textLabel.font = _labelFont;
}

- (void)setText:(NSString *)text {
    if ([_text isEqualToString:text]) {
        return;
    }
    _text = text;
    self.textLabel.text = _text;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.userInteractionEnabled = NO;
    }
    return _textLabel;
}

@end
