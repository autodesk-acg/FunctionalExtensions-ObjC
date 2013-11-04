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

#import <Kiwi/Kiwi.h>
#import <FunctionalExtensions-ObjC/FunctionalExtensions.h>


@interface FNXTraversableSpecHelper : NSObject
@end

@implementation FNXTraversableSpecHelper

+ (void (^)(id, id<FNXTraversable>))emptyTraversableExpect
{
    return ^(id testCase, id<FNXTraversable> input) {
        id self = testCase;
        it(@"Should return the correct size", ^{
            NSUInteger result = [input fnx_size];
            [[theValue(result) should] equal:@(0)];
        });
    };
}

+ (void (^)(id, id<FNXTraversable>))nonEmptyTraversableExpect
{
    return ^(id testCase, id<FNXTraversable> input) {
        id self = testCase;
        it(@"Should return the correct size", ^{
            NSUInteger result = [input fnx_size];
            [[theValue(result) should] equal:@(4)];
        });
    };
}

@end


SPEC_BEGIN(FNXTraversableSpec)

describe(@"<FNXTraversable>", ^{
    
    context(@"NSArray", ^{
        context(@"Empty", ^{
            [FNXTraversableSpecHelper emptyTraversableExpect](self, @[]);
        });
        context(@"Non-empty", ^{
            [FNXTraversableSpecHelper nonEmptyTraversableExpect](self, @[@(10), @(20), @(30), @(40)]);
        });
    });
    
});

SPEC_END
