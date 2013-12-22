//
//  CGICalendarObject.h
//
//  Created by Satoshi Konno on 11/01/27.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CGICalendarComponent.h"
#import "CGICalendarProperty.h"

extern NSString * const CGICalendarObjectVersionDefault;
extern NSString * const CGICalendarObjectProdidDefault;

@interface CGICalendarObject : CGICalendarComponent

+ (id)object;
+ (id)objectWithProdid:(NSString *)prodid;
+ (id)objectWithProdid:(NSString *)prodid version:(NSString *)version;

- (id)init;
- (id)initWithProdid:(NSString *)prodid;
- (id)initWithProdid:(NSString *)prodid version:(NSString *)version;

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *prodid;

- (NSArray *)componentsWithType:(NSString *)type;
@property (nonatomic, readonly) NSArray *events;
@property (nonatomic, readonly) NSArray *todos;
@property (nonatomic, readonly) NSArray *journals;
@property (nonatomic, readonly) NSArray *freebusies;
@property (nonatomic, readonly) NSArray *timezones;

@end
