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
        
        context(@"Should return 0 for the number of elements in the collection that satisfy a predicate", ^{
            it(@"Where the predicate is satisfied", ^{
                NSUInteger result = [input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result) should] equal:@(0)];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                NSUInteger result = [input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue(result) should] equal:@(0)];
            });
        });
        
        context(@"No predicate should hold for any of the elements in the collection", ^{
            it(@"Where the predicate is satisfied", ^{
                BOOL result = [input fnx_exists:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result) should] beFalse];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                BOOL result = [input fnx_exists:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue(result) should] beFalse];
            });
        });
        
        context(@"The collectiion of elements of the collection that don't satisfy a predicate should be empty", ^{
            it(@"Where the predicate is satisfied", ^{
                id<FNXOption> result = [input fnx_filter:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue([result fnx_isEmpty]) should] beTrue];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                id<FNXOption> result = [input fnx_filter:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue([result fnx_isEmpty]) should] beTrue];
            });
        });
        
        context(@"The first element of the collection that satisfies a predicate should be None", ^{
            it(@"Where the predicate is satisfied", ^{
                id<FNXOption> result = [input fnx_find:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result.fnx_isDefined) should] beFalse];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                id<FNXOption> result = [input fnx_find:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue(result.fnx_isDefined) should] beFalse];
            });
        });
        
        it(@"Should be able to apply a binary operator to a start value and the elements of the collection from beginning to end", ^{
            id result = [input fnx_foldLeftWithStartValue:@(1000)
                                                       op:^id(NSNumber *accumulator, NSNumber *obj) {
                                                           return @(accumulator.intValue / obj.intValue);
                                                       }];
            [[result should] equal:@(1000)];
        });
        
        it(@"Should be able to apply a binary operator to a start value and the elements of the collection from end to beginning", ^{
            id result = [input fnx_foldRightWithStartValue:@(5)
                                                        op:^id(NSNumber *obj, NSNumber *accumulator) {
                                                            return @(obj.intValue / accumulator.intValue);
                                                        }];
            [[result should] equal:@(5)];
        });
        
        context(@"Should return true when testing whether or not a predicate holds for None", ^{
            it(@"Where the predicate is satisfied", ^{
                BOOL result = [input fnx_forall:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result) should] beTrue];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                BOOL result = [input fnx_forall:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue(result) should] beTrue];
            });
        });
        
        it(@"Should do nothing when applying a function to None", ^{
            __block NSInteger total = 0;
            [input fnx_foreach:^(NSNumber *obj) {
                total = 1;
            }];
            [[theValue(total) should] equal:@(0)];
        });
        
        it(@"Should be empty", ^{
            BOOL result = [input fnx_isEmpty];
            [[theValue(result) should] beTrue];
        });
        
        context(@"When building a new collection by applying a function to the value should return an empty one", ^{
            id<FNXOption> result = [input fnx_map:^id(NSNumber *obj) {
                return @(2 * obj.intValue);
            }];
            [[theValue(result.fnx_isEmpty) should] beTrue];
        });
        
        it(@"Should have a size of 0", ^{
            NSUInteger result = [input fnx_size];
            [[theValue(result) should] equal:@(0)];
        });
        
        it(@"Should return an empty array", ^{
            NSArray *result = [input fnx_toArray];
            [[theValue(result.count) should] equal:@(0)];
        });
        
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
                id<FNXOption> result = [input fnx_filterNot:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue([result fnx_isEmpty]) should] beTrue];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                id<FNXOption> result = [input fnx_filterNot:^BOOL(NSNumber *n) {
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
        
        it(@"Should return None for the optional head value", ^{
            [[((id)[input fnx_headOption]) should] equal:[NSNull fnx_none]];
        });
        
        it(@"Should throw when returning all elements except the last", ^{
            [[theBlock(^{
                [input fnx_init];
            }) should] raise];
        });
        
        it(@"Should throw when returning the last value", ^{
            [[theBlock(^{
                [input fnx_last];
            }) should] raise];
        });

        it(@"Should return None for the optional last value", ^{
            [[((id)[input fnx_lastOption]) should] equal:[NSNull fnx_none]];
        });

        it(@"Should return false for non-empty", ^{
            [[theValue([input fnx_nonEmpty]) should] beFalse];
        });

        it(@"Should throw when returning all elements except the first", ^{
            [[theBlock(^{
                [input fnx_tail];
            }) should] raise];
        });
        
    });

    context(@"<FNXOption>", ^{
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
