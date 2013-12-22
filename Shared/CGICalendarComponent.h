//
//  CGICalendarComponent.h
//
//  Created by Satoshi Konno on 11/01/27.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGICalendarProperty.h"

extern NSString * const CGICalendarComponentTypeEvent;
extern NSString * const CGICalendarComponentTypeTodo;
extern NSString * const CGICalendarComponentTypeJournal;
extern NSString * const CGICalendarComponentTypeFreebusy;
extern NSString * const CGICalendarComponentTypeTimezone;
extern NSString * const CGICalendarComponentTypeAlarm;

@interface CGICalendarComponent : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableArray *components;
@property (nonatomic, strong) NSMutableArray *properties;

+ (id)componentWithType:(NSString *)type;
+ (id)event;
+ (id)todo;
+ (id)journal;
+ (id)freebusy;
+ (id)timezone;
+ (id)alarm;

- (id)initWithType:(NSString *)type;

- (BOOL)isType:(NSString *)type;

@property (nonatomic, readonly) BOOL isEvent;
@property (nonatomic, readonly) BOOL isTodo;
@property (nonatomic, readonly) BOOL isJournal;
@property (nonatomic, readonly) BOOL isFreebusy;
@property (nonatomic, readonly) BOOL isTimezone;
@property (nonatomic, readonly) BOOL isAlarm;
@property (nonatomic, readonly) BOOL isFullDay;

- (void)addComponent:(CGICalendarComponent *)component;
- (void)insertComponent:(CGICalendarComponent *)component atIndex:(NSUInteger)index;
- (CGICalendarComponent *)componentAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfComponent:(CGICalendarComponent *)component;
- (void)removeComponent:(CGICalendarComponent *)component;
- (void)removeComponentAtIndex:(NSUInteger)index;

- (BOOL)hasPropertyForName:(NSString *)name;
- (void)addProperty:(CGICalendarProperty *)property;
- (void)removePropertyForName:(NSString *)name;

- (void)setPropertyValue:(NSString *)value forName:(NSString *)name;
- (void)setPropertyValue:(NSString *)value forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames;
- (void)setPropertyObject:(id)object forName:(NSString *)name;
- (void)setPropertyObject:(id)object forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames;
- (void)setPropertyDate:(NSDate *)object forName:(NSString *)name;
- (void)setPropertyDate:(NSDate *)object forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames;
- (void)setPropertyInteger:(NSInteger)value forName:(NSString *)name;
- (void)setPropertyInteger:(NSInteger)value forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames;
- (void)setPropertyFloat:(float)value forName:(NSString *)name;
- (void)setPropertyFloat:(float)value forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames;

@property (nonatomic, readonly) NSArray *allPropertyKeys;
- (CGICalendarProperty *)propertyAtIndex:(NSUInteger)index;
- (CGICalendarProperty *)propertyForName:(NSString *)name;

- (NSString *)propertyValueForName:(NSString *)name;
- (NSDate *)propertyDateForName:(NSString *)name;
- (NSInteger)propertyIntegerForName:(NSString *)name;
- (float)propertyFloatForName:(NSString *)name;

@property (nonatomic, readonly) NSString *description;

// 4.2.12 Participation Status
@property (nonatomic, assign) NSInteger participationStatus;

// 4.8.1.5 Description
@property (nonatomic, strong) NSString *notes;

// 4.8.1.7
@property (nonatomic, strong) NSString *location;

// 4.8.1.9 Priority
@property (nonatomic, assign) NSUInteger priority;

// 4.8.1.12 Summary
@property (nonatomic, strong) NSString *summary;

// 4.8.2.1 Date/Time Completed
@property (nonatomic, strong) NSDate *completed;

// 4.8.2.2 Date/Time End
@property (nonatomic, strong) NSDate *dateTimeEnd;

// 4.8.2.3 Date/Time Due
@property (nonatomic, strong) NSDate *due;

// 4.8.2.4 Date/Time Start
@property (nonatomic, strong) NSDate *dateTimeStart;

// 4.8.4.7 Unique Identifier
@property (nonatomic, strong) NSString *UID;

// 4.8.7.1 Date/Time Created
@property (nonatomic, strong) NSDate *created;

// 4.8.7.2 Date/Time Stamp
@property (nonatomic, strong) NSDate *dateTimeStamp;

// 4.8.7.3 Last Modified
@property (nonatomic, strong) NSDate *lastModified;

// 4.8.7.4 Sequence Number
@property (nonatomic, assign) NSUInteger sequenceNumber;
- (void)incrementSequenceNumber;

@end
