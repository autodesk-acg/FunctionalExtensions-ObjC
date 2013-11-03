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


SPEC_BEGIN(FNXSomeSpec)

describe(@"FNXSome", ^{

    FNXSome *input = [FNXSome someWithValue:@(10)];

    context(@"<FNXTraversableOnce>", ^{
        
        context(@"Should be able to count the number of elements in the collection that satisfy a predicate", ^{
            it(@"Where the predicate is satisfied", ^{
                NSUInteger result = [input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result) should] equal:@(1)];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                NSUInteger result = [input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue(result) should] equal:@(0)];
            });
        });
        
        context(@"Should be able to test whether or not a predicate holds for some of the elements in the collection", ^{
            it(@"Where the predicate is satisfied", ^{
                BOOL result = [input fnx_exists:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result) should] beTrue];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                BOOL result = [input fnx_exists:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue(result) should] beFalse];
            });
        });
        
        context(@"Should be able to select elements of the collection that don't satisfy a predicate", ^{
            it(@"Where the predicate is satisfied", ^{
                id<FNXOption> result = [input fnx_filter:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue([result fnx_size]) should] equal:@(1)];
                [[[result fnx_toArray][0] should] equal:@(10)];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                id<FNXOption> result = [input fnx_filter:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue([result fnx_size]) should] equal:@(0)];
            });
        });
        
        context(@"Should be able to find the first element of the collection that satisfies a predicate", ^{
            it(@"Where the predicate is satisfied", ^{
                id<FNXOption> result = [input fnx_find:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result.fnx_isDefined) should] beTrue];
                [[result.fnx_get should] equal:@(10)];
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
            [[result should] equal:@(1000 / 10)];
        });

        it(@"Should be able to apply a binary operator to a start value and the elements of the collection from end to beginning", ^{
            id result = [input fnx_foldRightWithStartValue:@(5)
                                                        op:^id(NSNumber *obj, NSNumber *accumulator) {
                                                            return @(obj.intValue / accumulator.intValue);
                                                        }];
            [[result should] equal:@(10 / 5)];
        });

        context(@"Should be able to test whether or not a predicate holds for the value", ^{
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
                [[theValue(result) should] beFalse];
            });
        });

        it(@"Should be able to apply a function to each element", ^{
            __block NSInteger total = 1;
            [input fnx_foreach:^(NSNumber *obj) {
                total += obj.intValue;
            }];
            [[theValue(total) should] equal:@(1 + 10)];
        });
        
        it(@"Should be non-empty", ^{
            BOOL result = [input fnx_isEmpty];
            [[theValue(result) should] beFalse];
        });
        
        context(@"Should be able to build a new collection by applying a function to the value", ^{
            id<FNXOption> result = [input fnx_map:^id(NSNumber *obj) {
                return @(2 * obj.intValue);
            }];
            [[((id)result) should] equal:@[@(2*10)]];
        });
        
        it(@"Should have a size of 1", ^{
            NSUInteger result = [input fnx_size];
            [[theValue(result) should] equal:@(1)];
        });
        
        it(@"Should be able to create an array with the value in it", ^{
            NSArray *result = [input fnx_toArray];
            [[theValue(result.count) should] equal:@(1)];
            [[result[0] should] equal:@(10)];
        });

    });
    
    context(@"<FNXTraversable>", ^{

        context(@"Dropping", ^{
            it(@"Zero items, should return a traversable with the value", ^{
                id<FNXTraversable> result = [input fnx_drop:0];
                [[theValue([result fnx_size]) should] equal:@(1)];
                [[[result fnx_toArray][0] should] equal:@(10)];
            });

            it(@"More than zero items, should return an empty traversable", ^{
                id<FNXTraversable> result = [input fnx_drop:1];
                [[theValue([result fnx_size]) should] equal:@(0)];
            });
        });
        
        context(@"Should be able to select elements of the collection that don't satisfy a predicate", ^{
            it(@"Where the predicate is satisfied", ^{
                id<FNXOption> result = [input fnx_filterNot:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue([result fnx_size]) should] equal:@(0)];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                id<FNXOption> result = [input fnx_filterNot:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue([result fnx_size]) should] equal:@(1)];
                [[[result fnx_head] should] equal:@(10)];
            });
        });
        
        it(@"Should be able to return the head or last value", ^{
            [[[input fnx_head] should] equal:@(10)];
            [[[input fnx_last] should] equal:@(10)];
        });
        
        it(@"Should be able to return the head or last value, optionally", ^{
            [[((id)[input fnx_headOption]) should] equal:[FNXSome someWithValue:@(10)]];
            [[((id)[input fnx_lastOption]) should] equal:[FNXSome someWithValue:@(10)]];
        });
        
        it(@"Should return an empty traversable for all elements except the last", ^{
            id<FNXTraversable> result = [input fnx_init];
            [[theValue(result.fnx_isEmpty) should] beTrue];
        });
        
        it(@"Should return an empty traversable for all elements except the first", ^{
            id<FNXTraversable> result = [input fnx_tail];
            [[theValue(result.fnx_isEmpty) should] beTrue];
        });

    });
    
    context(@"<FNXOption>", ^{
        context(@"Should be able to count the number of elements that satisfy a predicate", ^{
            it(@"Where the predicate is satisfied", ^{
                NSUInteger result = [input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result) should] equal:@(1)];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                NSUInteger result = [input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue(result) should] equal:@(0)];
            });
        });
        
        it(@"Should be able to return the value", ^{
            [[input.fnx_get should] equal:@(10)];
        });
        
        it(@"Should return the value for getOrElse", ^{
            [[[input fnx_getOrElse:@(15)] should] equal:@(10)];
        });
        
        it(@"Should be defined", ^{
            [[theValue(input.fnx_isDefined) should] beTrue];
        });
        
        it(@"Should be non-empty", ^{
            [[theValue(input.fnx_isEmpty) should] beFalse];
            [[theValue(input.fnx_nonEmpty) should] beTrue];
        });
        
        it(@"Should return the same value for orElse", ^{
            id<FNXOption> result = [input fnx_orElse:^id<FNXOption>{
                return [FNXSome someWithValue:@(15)];
            }];
            [[result.fnx_get should] equal:@(10)];
        });
    });

    context(@"NSObject", ^{
        it(@"Should be able to test equality", ^{
            [[theValue([input isEqual:input]) should] beTrue];
            [[theValue([input isEqual:[FNXSome someWithValue:@(10)]]) should] beTrue];
            [[theValue([input isEqual:[FNXSome someWithValue:@(23)]]) should] beFalse];
        });
    });

});

SPEC_END
