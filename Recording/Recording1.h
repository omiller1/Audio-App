//
//  Recording1.h
//  Recording
//
//  Created by Olivia Miller on 7/6/16.
//  Copyright © 2016 Olivia Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recording1 : NSObject <NSCoding>
@property (strong, nonatomic) NSDate* date;
//always save in ~/Documents/yyyyMMddHHmmss (documents)
@property (readonly, nonatomic) NSString* path;
@property (readonly, nonatomic) NSURL* url;
@property (readonly, nonatomic) NSString* name;
-(Recording1*) initWithDate: (NSDate*) aDate;
@end