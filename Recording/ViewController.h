//
//  ViewController.h
//  Recording
//
//  Created by Olivia Miller on 7/6/16.
//  Copyright © 2016 Olivia Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Recording1.h"

@interface ViewController : UIViewController < AVAudioRecorderDelegate >
@property (strong, nonatomic) AVAudioRecorder* recorder;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) Recording1* currentRecording;
@property (strong, nonatomic) NSMutableArray* listOfRecordings;
@property (strong, nonatomic) AVAudioSession* recordings;
@property (strong, nonatomic) AVAudioRecorder*recordForDuration;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
-(IBAction) startRecordingPressed: (id) sender;
-(IBAction) stopRecording: (id) sender;
@end