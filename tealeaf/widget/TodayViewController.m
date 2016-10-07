//
//  TodayViewController.m
//  widget
//
//  Created by Jishnu Mohan <jishnu7@gmail.com> on 04/10/16.
//  Copyright © 2016 Hashcube. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation TodayViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateActionLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (IBAction)launchHostingApp:(id)sender
{
    // TODO: use sender.tag to identify the button and send widgetAction based on that
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    bundleIdentifier = [bundleIdentifier stringByReplacingOccurrencesOfString: @".twidget" withString:@""];

    NSString *urlString = [NSString stringWithFormat:@"%@://widget?widgetAction=play", bundleIdentifier];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    [self.extensionContext openURL:URL completionHandler:nil];
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self updateActionLabel];
}

- (void)updateActionLabel {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.hashcube.sudokuquest"];
    NSString *number = [defaults stringForKey:@"play"];

    if([number length] == 0) {
        // TODO: localize this
        number = @"Play";
    }

    [self.actionButton setTitle:number forState:UIControlStateNormal];
}

@end
