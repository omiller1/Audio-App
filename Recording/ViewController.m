

//
//  ViewController.m
//  Recording
//
//  Created by Olivia Miller on 7/6/16.
//  Copyright © 2016 Olivia Miller. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import <AVFoundation/AVAudioSession.h>

@interface ViewController()
@end

@implementation ViewController

@synthesize currentRecording;
@synthesize recordings;
@synthesize listOfRecordings;
@synthesize timer;
@synthesize recorder;
@synthesize recordForDuration;
@synthesize progressView;

-(ViewController*) initWithCoder: (NSCoder*) aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/RecordingArchive", NSHomeDirectory()];
    if([[NSFileManager defaultManager] fileExistsAtPath: archive]){
        self.listOfRecordings = [NSKeyedUnarchiver unarchiveObjectWithFile:archive];
        [[NSFileManager defaultManager] removeItemAtPath:archive error:nil];
    }else{
        // Doesn't exist!
        NSLog(@"No file to open!!");
        self.listOfRecordings = [[NSMutableArray alloc] init];
    }
    return self;
}

    - (IBAction) stopRecording: (id) sender
    {
        [self.recorder stop];
        
        [self.timer invalidate];
        self.statusLabel.text = @"Stopped";
        self.progressView.progress = 1.0;
        
        if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
            NSLog(@"File exists");
            
        }else{
            NSLog(@"File does not exist");
        }
    }
    
    
    - (void) audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
    {
        NSLog (@"audioRecorderDidFinishRecording:successfully:");
        [self.timer invalidate];
        self.statusLabel.text = @"Stopped";
        self.progressView.progress = 1.0;
        
        if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
            NSLog(@"File exists");
        }else{
            NSLog(@"File does not exist");
        }
        
    }
    


- (void) viewDidDisappear:(BOOL)animated
{
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/RecordingArchive", NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject: self.listOfRecordings toFile: archive];
}


-(void) viewDidLoad {
    [super viewDidLoad];
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];

}

- (IBAction)startCount:(id)sender
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
}
- (void)updateUI:(NSTimer *)timer
{
    static int count =0; count++;
    
    if (count <=10)
    {
        self.statusLabel.text = [NSString stringWithFormat:@"%d %%",count*10];
        self.progressView.progress = (float)count/10.0f;
    } else
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    

}

-(IBAction)startRecordingPressed:(id)sender {
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError* err = nil;
    [audioSession setCategory: AVAudioSessionCategoryRecord error: &err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@",
              [err domain], [err code], [[err userInfo] description]);
        return;
    }
    err = nil;
    [audioSession setActive:YES error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@",
              [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    
    NSMutableDictionary* recordingSettings = [[NSMutableDictionary alloc] init];
    
    [recordingSettings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    
    [recordingSettings setValue:@44100.0 forKey:AVSampleRateKey];
    
    [recordingSettings setValue:@1 forKey:AVNumberOfChannelsKey];
    
    [recordingSettings setValue:@16 forKey:AVLinearPCMBitDepthKey];
    
    [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
    
    [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsFloatKey];
    
    [recordingSettings setValue:@(AVAudioQualityHigh)
                         forKey:AVEncoderAudioQualityKey];
    
    
    NSDate* now = [NSDate date];
    
    self.currentRecording = [[Recording1 alloc] initWithDate: now];
    [self.listOfRecordings addObject: self.currentRecording];
    
    NSLog(@"%@",self.currentRecording);
    
    err = nil;
    
    self.recorder = [[AVAudioRecorder alloc]
                     initWithURL:self.currentRecording.url
                     settings:recordingSettings
                     error:&err];
    
    if(!self.recorder){
        NSLog(@"recorder: %@ %ld %@",
              [err domain], [err code], [[err userInfo] description]);
        UIAlertController* alert = [UIAlertController
        alertControllerWithTitle:@"Warning"
            message:[err localizedDescription]
            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction
                actionWithTitle:@"OK"
                style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    //prepare to record
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if( !audioHWAvailable ){
        UIAlertController* cantRecordAlert = [UIAlertController
            alertControllerWithTitle:@"Warning"
            message:@"Audio input hardware not available."
            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction
            actionWithTitle:@"OK"
            style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {}];
        
        [cantRecordAlert addAction:defaultAction];
        [self presentViewController:cantRecordAlert animated:YES completion:nil];
        
        
        return;
    }
    
    // start recording
    [self.recorder recordForDuration:(NSTimeInterval)10];
    
    self.statusLabel.text = @"Recording...";
    self.progressView.progress = 0.0;
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.2
                  target:self
                  selector:@selector(handleTimer)
                  userInfo:nil
                  repeats:YES];
}

    //stop recording
- (IBAction)stopRecordingPressed:(id)sender
{
    [recorder stop];
    AVAudioSession *recordforDuration = [AVAudioSession sharedInstance];
    [recordforDuration setActive:NO error:nil];

}



-(void) handleTimer
{
    self.progressView.progress += .02;
    if(self.progressView.progress == 12.0)
    {
        [self.timer invalidate];
        self.statusLabel.text = @"Stopped";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableViewController* tvc = (TableViewController*)segue.destinationViewController;
    tvc.listOfRecordings = self.listOfRecordings;
    
}


@end