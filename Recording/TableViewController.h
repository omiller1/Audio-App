//
//  TableViewController.h
//  Recording
//
//  Created by Olivia Miller on 7/8/16.
//  Copyright © 2016 Olivia Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording1.h"
#import <AVFoundation/AVFoundation.h>

@interface TableViewController : UITableViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) NSMutableArray* listOfRecordings;

@property (strong, nonatomic) AVAudioPlayer* player;

@end
