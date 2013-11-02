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


SPEC_BEGIN(FNXNoneSpec)

describe(@"FNXNone", ^{
    
    id<FNXNone> input = [NSNull fnx_none];
    
    context(@"<FNXTraversableOnce>", ^{
    });
    
    context(@"<FNXTraversable>", ^{
        
        context(@"Dropping", ^{
            it(@"Zero items, should return an empty traversable", ^{
                id<FNXTraversable> result = [input fnx_drop:0];
                [[theValue([result fnx_isEmpty]) should] beTrue];
            });
            
            it(@"More than zero items, should return an empty traversable", ^{
                id<FNXTraversable> result = [input fnx_drop:1];
                [[theValue([result fnx_isEmpty]) should] beTrue];
            });
        });
        
        context(@"Should be able to select elements of the collection that don't satisfy a predicate", ^{
            it(@"Where the predicate is satisfied", ^{
                id<FNXTraversable> result = [input fnx_filterNot:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue([result fnx_isEmpty]) should] beTrue];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                id<FNXTraversable> result = [input fnx_filterNot:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue([result fnx_isEmpty]) should] beTrue];
            });
        });
        
        it(@"Should throw when returning the head value", ^{
            [[theBlock(^{
                [input fnx_head];
            }) should] raise];
        });
        
        it(@"Should throw when returning the last value", ^{
            [[theBlock(^{
                [input fnx_last];
            }) should] raise];
        });
        
        it(@"Should return None for the optional head value", ^{
            [[((id)[input fnx_headOption]) should] equal:[NSNull fnx_none]];
        });
        
        it(@"Should return None for the optional last value", ^{
            [[((id)[input fnx_lastOption]) should] equal:[NSNull fnx_none]];
        });
        
        it(@"Should throw when returning all elements except the last", ^{
            [[theBlock(^{
                [input fnx_init];
            }) should] raise];
        });
        
        it(@"Should throw when returning all elements except the first", ^{
            [[theBlock(^{
                [input fnx_tail];
            }) should] raise];
        });
        
    });

    context(@"<FNXOption>", ^{
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
        
        it(@"Should return the default value for getOrElse", ^{
            [[[input fnx_getOrElse:@(15)] should] equal:@(15)];
        });
        
        it(@"Should be undefined", ^{
            [[theValue(input.fnx_isDefined) should] beFalse];
        });
        
        it(@"Should be empty", ^{
            [[theValue(input.fnx_isEmpty) should] beTrue];
            [[theValue(input.fnx_nonEmpty) should] beFalse];
        });
        
        it(@"Should return an alternative value for orElse", ^{
            id<FNXOption> result = [input fnx_orElse:^id<FNXOption>{
                return [FNXSome someWithValue:@(15)];
            }];
            [[result.fnx_get should] equal:@(15)];
        });
    });
    
    context(@"NSObject", ^{
        it(@"Should be able to test equality", ^{
            [[theValue([input isEqual:input]) should] beTrue];
            [[theValue([input isEqual:[NSNull fnx_none]]) should] beTrue];
            [[theValue([input isEqual:[NSNull null]]) should] beTrue];
            [[theValue([input isEqual:[FNXSome someWithValue:@(1)]]) should] beFalse];
        });
    });
    
});

SPEC_END
