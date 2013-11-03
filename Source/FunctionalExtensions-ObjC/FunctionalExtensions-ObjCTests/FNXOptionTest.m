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
#import <FunctionalExtensions-ObjC/FunctionalExtensions.h>


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

- (void)testChainedOptionsWithSome
{
    id<FNXOption> name = [FNXSome someWithValue:@"  test    "];
    id<FNXOption> map0 = [name fnx_map:^id(NSString *obj) { return [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; }];
    id<FNXOption> filter0 = [map0 fnx_filter:^BOOL(NSString *obj) { return obj.length > 0; }];
    id<FNXOption> map1 = [filter0 fnx_map:^id(NSString *obj) { return [obj uppercaseString]; }];
    XCTAssertEqualObjects([map1 fnx_getOrElse:@""], @"TEST", @"Chained option methods with Some didn't yield correct value.");
}

- (void)testChainedOptionsWithNone
{
    id<FNXOption> name = [NSNull fnx_none];
    id<FNXOption> map0 = [name fnx_map:^id(NSString *obj) { return [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; }];
    id<FNXOption> filter0 = [map0 fnx_filter:^BOOL(NSString *obj) { return obj.length > 0; }];
    id<FNXOption> map1 = [filter0 fnx_map:^id(NSString *obj) { return [obj uppercaseString]; }];
    XCTAssertEqualObjects([map1 fnx_getOrElse:@""], @"", @"Chained option methods with None didn't yield correct value.");
}

@end
