#MACustomSegmentedControl
A custom segmented control, with rectangular segments.

##Installation
Drag and drop ```MACustomSegmentedControlView.h/m” into your project.

##Usage

CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 100);
MACustomSegmentedControlView *segmentedControlView = [[MACustomSegmentedControlView alloc] initWithFrame:frame 																			andItems:@[@"One", @"Two", @"Three", @"Four"]];
segmentedControlView.delegate = self;
segmentedControlView.title = @"Segmented control example";
[segmentedControlView setNumberOfSegmentsInLine:4 forOrientation:UIInterfaceOrientationMaskLandscape];
[segmentedControlView setNumberOfSegmentsInLine:2 forOrientation:UIInterfaceOrientationMaskPortrait];

[self.view addSubview:segmentedControlView];
