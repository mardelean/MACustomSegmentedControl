#MACustomSegmentedControl
A custom segmented control, with rectangular segments.

[![Build Status](https://travis-ci.org/mardelean/MACustomSegmentedControl.svg?branch=master)](https://travis-ci.org/mardelean/MACustomSegmentedControl)

##Installation
Drag and drop ```MACustomSegmentedControlView.h/m``` into your project.

##Usage

``` objc
CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 100);
MACustomSegmentedControlView *segmentedControlView = [[MACustomSegmentedControlView alloc] initWithFrame:frame andItems:@[@"One", @"Two", @"Three", @"Four"]];
segmentedControlView.delegate = self;
segmentedControlView.title = @"Segmented control example";
[segmentedControlView setNumberOfSegmentsInLine:4 forOrientation:UIInterfaceOrientationMaskLandscape];
[segmentedControlView setNumberOfSegmentsInLine:2 forOrientation:UIInterfaceOrientationMaskPortrait];

[self.view addSubview:segmentedControlView];

```

##Screenshot


![Screenshot](https://github.com/MadalinaArdelean/MACustomSegmentedControl/raw/master/screenshot.png)
