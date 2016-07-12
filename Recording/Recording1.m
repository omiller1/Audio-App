//
//  Recording1.m
//  Recording
//
//  Created by Olivia Miller on 7/6/16.
//  Copyright © 2016 Olivia Miller. All rights reserved.
//

#import "Recording1.h"

@implementation Recording1

@synthesize date;



-(instancetype)initWithCoder:(NSCoder *)aDecoder
{

    self = [super init];
    if(self){
        self.date = [aDecoder decodeObjectOfClass: [Recording1 class] forKey: @"date"];
    }
    return self;
    
}

-(void) encodeWithCoder: (NSCoder*) encoder
{
    [encoder encodeObject: self.date forKey: @"date"];
    
}

-(Recording1*) initWithDate:(NSDate*) aDate
{
    
    self=[super init];
    if (self) self.date = aDate;
    return self;
}

-(NSString*) path{
    
    NSString* home = NSHomeDirectory();
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate: self.date];
    return [NSString stringWithFormat:@"%@/Documents/%@.caf",home, dateString];
}

-(NSURL*) url {
    return [NSURL URLWithString:self.path];
    
}

-(NSString*) name{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateString = [dateFormatter stringFromDate: self.date];
    return dateString;
}

@end
