/********************************************************************
 * (C) Copyright 2013 by Autodesk, Inc. All Rights Reserved. By using
 * this code,  you  are  agreeing  to the terms and conditions of the
 * License  Agreement  included  in  the documentation for this code.
 * AUTODESK  MAKES  NO  WARRANTIES,  EXPRESS  OR  IMPLIED,  AS TO THE
 * CORRECTNESS OF THIS CODE OR ANY DERIVATIVE WORKS WHICH INCORPORATE
 * IT.  AUTODESK PROVIDES THE CODE ON AN 'AS-IS' BASIS AND EXPLICITLY
 * DISCLAIMS  ANY  LIABILITY,  INCLUDING CONSEQUENTIAL AND INCIDENTAL
 * DAMAGES  FOR ERRORS, OMISSIONS, AND  OTHER  PROBLEMS IN THE  CODE.
 *
 * Use, duplication,  or disclosure by the U.S. Government is subject
 * to  restrictions  set forth  in FAR 52.227-19 (Commercial Computer
 * Software Restricted Rights) as well as DFAR 252.227-7013(c)(1)(ii)
 * (Rights  in Technical Data and Computer Software),  as applicable.
 *******************************************************************/

#import <XCTest/XCTest.h>
#import "FNXNone.h"
#import "FNXSome.h"


@interface FNXOptionTest : XCTestCase

@end


@implementation FNXOptionTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testIsDefinedWithSome
{
    FNXOption *optN = [FNXSome someWithValue:@(1)];
    XCTAssertTrue(optN.isDefined, @"Option with Some should be defined.");
}

- (void)testIsDefinedWithNone
{
    FNXOption *optN = [FNXNone none];
    XCTAssertFalse(optN.isDefined, @"Option with None should not be defined.");
}

- (void)testIsEmptyWithSome
{
    FNXOption *optN = [FNXSome someWithValue:@(1)];
    XCTAssertFalse(optN.isEmpty, @"Option with Some should be not empty.");
}

- (void)testIsEmptyWithNone
{
    FNXOption *optN = [FNXNone none];
    XCTAssertTrue(optN.isEmpty, @"Option with None should be empty.");
}

- (void)testMapWithSome
{
    FNXOption *optN = [FNXSome someWithValue:@(1)];
    FNXOption *optMappedN = [optN map:^id(NSNumber *obj) {
        return @(obj.intValue * 3);
    }];
    XCTAssertEqualObjects(optMappedN.get, @(3), @"Mapped option with Some didn't yield correct value.");
}

- (void)testMapWithNone
{
    FNXOption *optN = [FNXNone none];
    FNXOption *optMappedN = [optN map:^id(NSNumber *obj) {
        return @(obj.intValue * 3);
    }];
    XCTAssertTrue(optMappedN.isEmpty, @"Mapped option with None didn't yield correct value.");
}

- (void)testChainedOptionsWithSome
{
    FNXOption *name = [FNXSome someWithValue:@"  test    "];
    
    FNXOption *upper =
    [[[name
    map:^id(NSString *obj) { return [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; }]
    filter:^BOOL(NSString *obj) { return obj.length > 0; }]
    map:^id(NSString *obj) { return [obj uppercaseString]; }];
    
    XCTAssertEqualObjects([upper getOrElse:@""], @"TEST", @"Chained option methods with Some didn't yield correct value.");
}

- (void)testChainedOptionsWithNone
{
    FNXOption *name = [FNXNone none];
    
    FNXOption *upper =
    [[[name
       map:^id(NSString *obj) { return [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; }]
      filter:^BOOL(NSString *obj) { return obj.length > 0; }]
     map:^id(NSString *obj) { return [obj uppercaseString]; }];
    
    XCTAssertEqualObjects([upper getOrElse:@""], @"", @"Chained option methods with None didn't yield correct value.");
}

@end
