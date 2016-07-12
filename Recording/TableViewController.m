//
//  TableViewController.m
//  Recording
//
//  Created by Olivia Miller on 7/8/16.
//  Copyright © 2016 Olivia Miller. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController
@synthesize listOfRecordings;
@synthesize player;

////-(instancetype) initWithCoder:(NSCoder *)aDecoder
////{
//    self = [super initWithCoder:aDecoder];
//    if(self){
//        self.listOfRecordings = [[NSMutableArray alloc] init];
//        [self.listOfRecordings addObject: @"Recording 1"];
//        [self.listOfRecordings addObject: @"Recording 2"];
//        [self.listOfRecordings addObject: @"Recording 3"];
//        [self.listOfRecordings addObject: @"Recording 4"];
//        [self.listOfRecordings addObject: @"Recording 5"];
//        [self.listOfRecordings addObject: @"Recording 6"];
//        [self.listOfRecordings addObject: @"Recording 7"];
//        [self.listOfRecordings addObject: @"Recording 8"];
//        [self.listOfRecordings addObject: @"Recording 9"];
//        [self.listOfRecordings addObject: @"Recording 10"];
//        [self.listOfRecordings addObject: @"Recording 11"];
//        [self.listOfRecordings addObject: @"Recording 12"];
//        [self.listOfRecordings addObject: @"Recording 13"];
//        [self.listOfRecordings addObject: @"Recording 14"];
//        [self.listOfRecordings addObject: @"Recording 15"];
//        [self.listOfRecordings addObject: @"Recording 16"];
//        [self.listOfRecordings addObject: @"Recording 17"];
//        [self.listOfRecordings addObject: @"Recording 18"];
//        [self.listOfRecordings addObject: @"Recording 19"];
//        [self.listOfRecordings addObject: @"Recording 20"];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError* err = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
    if (err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    err = nil;
    [audioSession setActive:YES error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
    }
    NSLog(@"Hello Table View!");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listOfRecordings count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    // Configure the cell...

    Recording1* record = [self.listOfRecordings objectAtIndex: indexPath.row];
    
    cell.textLabel.text = record.name;
    
    return cell;
    
}

-(void) play:(Recording1*)recording
{
    NSLog(@"Playing %@", recording.path);
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath: recording.path], @"Doesn't exist");
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL: recording.url error:&error];
    if(error){
        NSLog(@"playing audio: %@ %ld %@", [error domain], [error code], [[error userInfo] description]);
        return;
    }else{
        player.delegate = self;
    }
    if([player prepareToPlay] == NO){
        NSLog(@"Not prepared to play!");
        return;
    }
    [player play];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // play the audio file that maps onto the cell
    [self play: [self.listOfRecordings objectAtIndex: indexPath.row]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
