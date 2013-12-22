//
//  CGICalendarParameter.h
//
//  Created by Satoshi Konno on 11/01/27.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGICalendarValue.h"

@interface CGICalendarParameter : CGICalendarValue

- (id)initWithString:(NSString *)aString;

@property (nonatomic, strong) NSString *string;
@property (nonatomic, readonly) NSString *description;

@end
