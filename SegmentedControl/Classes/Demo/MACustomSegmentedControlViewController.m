//
//  MACustomSegmentedControlViewController.m
//  SegmentedControl
//
//  Created by Madalina Ardelean on 28/05/14.
//  Copyright (c) 2014 Madalina Ardelean. All rights reserved.
//

#import "MACustomSegmentedControlViewController.h"
#import "MACustomSegmentedControlView.h"
#import "MASegmentView.h"

@interface MACustomSegmentedControlViewController () <MACustomSegmentedControlDelegate,
                                                     UITableViewDataSource,
                                                     UITableViewDelegate,
                                                     UIActionSheetDelegate>

@property (nonatomic, strong) MACustomSegmentedControlView *segmentedControlView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) NSInteger selectedAttributeIndex;
@property (nonatomic, strong) NSArray *tableItems;
@property (nonatomic, assign) BOOL selected;

@end

@implementation MACustomSegmentedControlViewController

static NSString *kCellIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.segmentedControlView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.tableView];
    self.tableItems = @[@"Allow multiple selection",
                        @"Segment background color",
                        @"Segment color when selected",
                        @"Segment text color",
                        @"Segment text color when selected"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat offsetX = 10.0;
    
    CGFloat segmentHeight = 110;
    CGFloat segmentWidth = CGRectGetWidth(self.view.bounds) - 2.0 * offsetX;
    self.segmentedControlView.frame = CGRectMake(offsetX, 20.0, segmentWidth, segmentHeight);
    
    CGFloat tableHeight = 120.0;
    CGFloat tableOriginY = CGRectGetHeight(self.view.bounds) - tableHeight;
    self.tableView.frame = CGRectMake(0.0, tableOriginY, CGRectGetWidth(self.view.bounds), tableHeight);
    
    CGFloat textViewHeight = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(self.segmentedControlView.frame) ;
    self.textView.frame = CGRectMake(offsetX, CGRectGetMaxY(self.segmentedControlView.frame), segmentWidth, textViewHeight);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    cell.textLabel.text = self.tableItems[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    UIColor *color;
    switch (indexPath.row) {
        case 0:
            [self configureCell:cell];
            return cell;
        case 1:
            color = self.segmentedControlView.segmentBackgroundColor;
            break;
        case 2:
            color = self.segmentedControlView.selectedSegmentBackgroundColor;
            break;
        case 3:
            color = self.segmentedControlView.segmentTextColor;
            break;
        case 4:
            color = self.segmentedControlView.selectedSegmentTextColor;
        default:
            break;
    }
    
    [self setColor:color forCell:cell];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose a color"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Red", @"Blue", @"Yellow", @"Gray", @"Black", @"White",nil];
    [actionSheet showInView:self.view];
    self.selectedAttributeIndex = indexPath.row;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    //The first cell will not be able to be selected because it's action will be implemented by the switch it contains
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - MACustomSegmentedDelegate

- (void)segmentedControl:(MACustomSegmentedControlView *)segmentedControl didSelectItemAtIndex:(NSUInteger)index {
    MASegmentView *segment = (MASegmentView *)[segmentedControl segmentAtIndex:index];
    NSString *string = [NSString stringWithFormat:@"The segment '%@' was selected \n", segment.text];
    NSMutableString *textViewString = [self.textView.text mutableCopy];
    [textViewString appendString:string];
    self.textView.text = textViewString;
}

- (void)segmentedControl:(MACustomSegmentedControlView *)segmentedControl didDeselectItemAtIndex:(NSUInteger)index {
    MASegmentView *segment = (MASegmentView *)[segmentedControl segmentAtIndex:index];
    NSString *string = [NSString stringWithFormat:@"The segment '%@' was deselected \n", segment.text];
    NSMutableString *textViewString = [self.textView.text mutableCopy];
    [textViewString appendString:string];
    self.textView.text = textViewString;}

#pragma mark - Private methods

- (void)switchChanged:(UISwitch *)sender {
    if (!sender.on) {
        [self refreshSegmentedControl];
        [self.segmentedControlView selectSegmentAtIndex:0];
    }
    self.segmentedControlView.allowMultipleSelection = sender.on;
    self.selected = sender.on;
}

- (void)setAttributeColor:(UIColor *)color {
    switch (self.selectedAttributeIndex) {
        case 1:
            self.segmentedControlView.segmentBackgroundColor = color;
            break;
        case 2:
            self.segmentedControlView.selectedSegmentBackgroundColor = color;
            break;
        case 3:
            self.segmentedControlView.segmentTextColor = color;
            break;
        case 4:
            self.segmentedControlView.selectedSegmentTextColor = color;
            break;
        default:
            break;
    }
    [self refreshSegmentedControl];
    [self.tableView reloadData];
}

- (void)setColor:(UIColor *)color forCell:(UITableViewCell *)cell {
    CGFloat viewHeight = 20;
    CGFloat cellHeight = CGRectGetHeight(cell.frame);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, (cellHeight - viewHeight) / 2.0, 20, viewHeight)];
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1.0;
    view.backgroundColor = color;
    cell.accessoryView = view;
}

- (void)refreshSegmentedControl {
    NSInteger count = [self.segmentedControlView numberOfSegments];
    for (NSInteger index = 0; index < count; index++) {
        [self.segmentedControlView deselectSegmentAtIndex:index];
    }
}

- (void)configureCell:(UITableViewCell *)cell {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    [switchView setOn:self.selected animated:NO];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - UIAlertViewDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self setAttributeColor:[UIColor redColor]];
            break;
        case 1:
            [self setAttributeColor:[UIColor blueColor]];
            break;
        case 2:
            [self setAttributeColor:[UIColor yellowColor]];
            break;
        case 3:
            [self setAttributeColor:[UIColor lightGrayColor]];
            break;
        case 4:
            [self setAttributeColor:[UIColor blackColor]];
            break;
        case 5:
            [self setAttributeColor:[UIColor whiteColor]];
            break;
        default:
            break;
    }
}

#pragma mark - Properties

- (MACustomSegmentedControlView *)segmentedControlView {
    if (!_segmentedControlView) {
        _segmentedControlView = [[MACustomSegmentedControlView alloc] initWithFrame:CGRectZero andItems:@[@"One", @"Two", @"Three", @"Four"]];
        _segmentedControlView.delegate = self;
        _segmentedControlView.title = @"Segmented control example";
        [_segmentedControlView setNumberOfSegmentsInLine:4 forOrientation:UIInterfaceOrientationMaskLandscape];
        [_segmentedControlView setNumberOfSegmentsInLine:2 forOrientation:UIInterfaceOrientationMaskPortrait];
        _segmentedControlView.selectedSegmentBackgroundColor = [UIColor redColor];
        [_segmentedControlView selectSegmentAtIndex:0];
    }
    return _segmentedControlView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    return _tableView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor lightGrayColor];
        _textView.scrollEnabled = YES;
    }
    return _textView;
}

@end
