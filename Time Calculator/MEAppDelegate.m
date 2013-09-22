//
//  MEAppDelegate.m
//  Time Calculator
//
//  Created by Matthew M. Edmonds on 4/4/13.
//  Copyright (c) 2013 Matthew M. Edmonds. All rights reserved.
//

#import "MEAppDelegate.h"

@interface MEAppDelegate ()

@property (unsafe_unretained) IBOutlet NSTextField *startTime;
@property (unsafe_unretained) IBOutlet NSTextField *endTime;
@property (unsafe_unretained) IBOutlet NSTextField *totalTime;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *militaryDateFormatter;
@property (unsafe_unretained) IBOutlet NSSegmentedControl *startTimeFormat;
@property (unsafe_unretained) IBOutlet NSSegmentedControl *endTimeFormat;
@end


@implementation MEAppDelegate


- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"h:mm a"];
        _dateFormatter = formatter;
    }
    return _dateFormatter;
}

- (NSDateFormatter *)militaryDateFormatter
{
    if (!_militaryDateFormatter) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"HH:mm"];
        _militaryDateFormatter = formatter;
    }
    return _militaryDateFormatter;
}

- (NSDate *)getStartTime
{
    NSString *start = [self.startTime stringValue];
    if (!start) return nil;
    start = [start stringByReplacingOccurrencesOfString:@":" withString:@""];
    if ([start length] > 4) return nil;
    if ([start length] < 4) {
        start = [@"0" stringByAppendingString:start];
    }
    NSString *hour = [start substringToIndex:2];
    hour = [hour stringByAppendingString:@":"];
    hour = [hour stringByAppendingString:[start substringFromIndex:2]];
    start = hour;
    NSInteger selection = [self.startTimeFormat selectedSegment];
    NSDateFormatter *formatter = self.militaryDateFormatter;
    if (selection == 0) {
        formatter = self.dateFormatter;
        start = [start stringByAppendingString:@" AM"];
    } else if (selection == 1) {
        formatter = self.dateFormatter;
        start = [start stringByAppendingString:@" PM"];
    }
    NSDate *startTime = [formatter dateFromString:start];
    return startTime;
}

- (NSDate *)getEndTime
{
    NSString *end = [self.endTime stringValue];
    if (!end) return nil;
    end = [end stringByReplacingOccurrencesOfString:@":" withString:@""];
    if ([end length] > 4) return nil;
    if ([end length] < 4) {
        end = [@"0" stringByAppendingString:end];
    }
    NSString *hour = [end substringToIndex:2];
    hour = [hour stringByAppendingString:@":"];
    hour = [hour stringByAppendingString:[end substringFromIndex:2]];
    end = hour;
    NSInteger selection = [self.endTimeFormat selectedSegment];
    NSDateFormatter *formatter = self.militaryDateFormatter;
    if (selection == 0) {
        formatter = self.dateFormatter;
        end = [end stringByAppendingString:@" AM"];
    } else if (selection == 1) {
        formatter = self.dateFormatter;
        end = [end stringByAppendingString:@" PM"];
    }
    NSDate *endTime = [formatter dateFromString:end];
    return endTime;
}

- (IBAction)calculatePressed:(id)sender
{
    NSDate *start = [self getStartTime];
    NSDate *end = [self getEndTime];
    
    if (!start || !end) {
        [self.totalTime setStringValue:@"Error"];
        return;
    }
        
    NSTimeInterval timeInterval = [end timeIntervalSinceDate:start];
    double totalTime = (timeInterval / 60) / 60;
    if (totalTime < 0) totalTime = 24 + totalTime;
    [self.totalTime setStringValue:[NSString stringWithFormat:@"%.02f", totalTime]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

@end
