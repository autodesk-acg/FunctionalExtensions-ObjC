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


SPEC_BEGIN(FNXOptionSpec)

describe(@"FNXOption", ^{
    
    context(@"FNXNone", ^{
        id<FNXNone> input = [NSNull fnx_none];

        it(@"Should return 0 for the number of items that satisfy a predicate", ^{
            NSUInteger result = [input fnx_count:^BOOL(NSNumber *n) {
                return n.intValue < 5;
            }];
            [[theValue(result) should] equal:@(0)];
        });

        it(@"Should throw when trying to return the value", ^{
            [[theBlock(^{
                [input fnx_get];
            }) should] raise];
        });

        it(@"Should return NO for isDefined", ^{
            [[theValue(input.fnx_isDefined) should] beFalse];
        });
        
        it(@"Should return YES for isEmpty", ^{
            [[theValue(input.fnx_isEmpty) should] beTrue];
        });
        
        it(@"Should return NO for nonEmpty", ^{
            [[theValue(input.fnx_nonEmpty) should] beFalse];
        });

        it(@"Should return an alternative value for orElse", ^{
            id<FNXOption> result = [input fnx_orElse:^id<FNXOption>{
                return [FNXSome someWithValue:@(15)];
            }];
            [[result.fnx_get should] equal:@(15)];
        });
    });

    context(@"FNXSome", ^{
        FNXSome *input = [FNXSome someWithValue:@(10)];

        context(@"Should be able to count the number of elements that satisfy a predicate", ^{
            it(@"Where the predicate is satisfied", ^{
                NSUInteger result = [input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result) should] equal:@(1)];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                FNXSome *input = [FNXSome someWithValue:@(10)];
                NSUInteger result = [input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue(result) should] equal:@(0)];
            });
        });
        
        it(@"Should be able to return the value", ^{
            [[input.fnx_get should] equal:@(10)];
        });
        
        it(@"Should return YES for isDefined", ^{
            [[theValue(input.fnx_isDefined) should] beTrue];
        });
        
        it(@"Should return NO for isEmpty", ^{
            [[theValue(input.fnx_isEmpty) should] beFalse];
        });
        
        it(@"Should return YES for nonEmpty", ^{
            [[theValue(input.fnx_nonEmpty) should] beTrue];
        });
        
        it(@"Should return the same value for orElse", ^{
            id<FNXOption> result = [input fnx_orElse:^id<FNXOption>{
                return [FNXSome someWithValue:@(15)];
            }];
            [[result.fnx_get should] equal:@(10)];
        });
    });

    context(@"<FNXTraversable>", ^{
    });
    
});

SPEC_END
