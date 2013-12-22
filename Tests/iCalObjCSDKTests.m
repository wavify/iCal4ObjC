//
//  iCalObjCSDKTests.m
//  iCalObjCSDKTests
//
//  Created by Satoshi Konno on 11/04/08.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "iCalObjCSDKTests.h"
#import "CGICalendarContentLine.h"

@implementation iCalObjCSDKTests

- (void)setUp {
	[super setUp];
	// Set-up code here.
}

- (void)tearDown {
	// Tear-down code here.
	[super tearDown];
}

- (void)testValue {
	CGICalendarValue *icalValue;
	icalValue = [CGICalendarValue new];
	STAssertFalse(icalValue.hasName, @"");
	icalValue.name = @"ROLE";
	STAssertTrue(icalValue.hasName, @"");
	STAssertEqualObjects(icalValue.name, @"ROLE", @"");
	icalValue = [CGICalendarValue new];
	STAssertFalse(icalValue.hasValue, @"");
	icalValue.value = @"REQ-PARTICIPANT";
	STAssertTrue(icalValue.hasValue, @"");
	STAssertEqualObjects(icalValue.value, @"REQ-PARTICIPANT", @"");
}

- (void)testParameter {
	CGICalendarParameter *icalParam;
	icalParam = [[CGICalendarParameter alloc] initWithString:@"ROLE=REQ-PARTICIPANT"];
	STAssertEqualObjects(icalParam.name, @"ROLE", @"");
	STAssertEqualObjects(icalParam.value, @"REQ-PARTICIPANT", @"");
	STAssertEqualObjects(icalParam.string, @"ROLE=REQ-PARTICIPANT", @"");
	icalParam = [CGICalendarParameter new];
	icalParam.name = @"ROLE";
	icalParam.value = @"REQ-PARTICIPANT";
	STAssertEqualObjects(icalParam.string, @"ROLE=REQ-PARTICIPANT", @"");
}

- (void)testContentLine {
	NSString *testContentLine = @"ATTACH;FMTTYPE=audio/basic:http://host.com/pub/audio-files/ssbanner.aud\r\n";
	CGICalendarContentLine *icalContentLne = [[CGICalendarContentLine alloc] initWithString:testContentLine];
	STAssertEqualObjects(icalContentLne.name, @"ATTACH", @"");
	STAssertEqualObjects(icalContentLne.value, @"http://host.com/pub/audio-files/ssbanner.aud", @"");
	STAssertEquals(icalContentLne.parameters.count, (NSUInteger)1, @"");
	STAssertEqualObjects(icalContentLne.description, testContentLine, @"");
}


@end
