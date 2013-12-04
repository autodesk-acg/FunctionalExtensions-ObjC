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

#import "FNXMockWithBOOL.h"
#import "FNXMockWithProcedure.h"

#import <Kiwi/Kiwi.h>
#import <FunctionalExtensions-ObjC/FunctionalExtensions.h>


SPEC_BEGIN(NSArray_FNXFunctionalExtensionsSpec)

describe(@"NSArray+FNXFunctionalExtensions", ^{
    
    context(@"NSArray", ^{
        
        context(@"Should be able to return distinct values from an array with duplicate values, preserving order", ^{
            
            it(@"For a nonempty collection", ^{
                NSArray *input = @[@(10), @(20), @(30), @(20), @(40)];
                NSArray *expected = @[@(10), @(20), @(30), @(40)];
                [[input.fnx_distinct should] equal:expected];
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                NSArray *expected = @[];
                [[input.fnx_distinct should] equal:expected];
            });
            
        });
        
        context(@"Should be able to select all elements except the last n ones", ^{
            
            it(@"For a nonempty collection", ^{
                NSArray *input = @[@(10), @(20), @(30), @(40)];
                id result = [input fnx_dropRight:2];
                [[result should] equal:@[@(10), @(20)]];
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id<FNXTraversable> result = [input fnx_dropRight:2];
                [[theValue(result.fnx_size) should] equal:@(0)];
            });
            
        });
        
        context(@"Should be able to drop the longest prefix of elements that satisfy a predicate", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"Whose predicate includes several prefix elements", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(40)];
                    NSArray *result = [input fnx_dropWhile:^BOOL (NSNumber *obj) {
                        return obj.intValue < 20;
                    }];
                    [[result should] equal:@[@(20), @(30), @(40)]];
                });
                
                it(@"Whose predicate does not include several prefix elements", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(40)];
                    NSArray *result = [input fnx_dropWhile:^BOOL (NSNumber *obj) {
                        return obj.intValue > 20;
                    }];
                    [[result should] equal:input];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                NSArray *result = [input fnx_dropWhile:^BOOL (NSNumber *obj) {
                    return obj.intValue < 20;
                }];
                [[theValue(result.fnx_size) should] equal:@(0)];
            });
            
        });
        
        context(@"Should be able to partition elements based on a discriminator function", ^{
            
            id (^discriminate)(id) = ^id (NSNumber *obj) {
                if (obj.intValue < 3) {
                    return @"A";
                } else if (obj.intValue < 6) {
                    return @"B";
                } else {
                    return @"C";
                }
            };
            
            context(@"For a nonempty collection", ^{
                NSArray *input = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8)];
                NSDictionary *result = [input fnx_groupBy:discriminate];
                [[result[@"A"] should] equal:@[@(1), @(2)]];
                [[result[@"B"] should] equal:@[@(3), @(4), @(5)]];
                [[result[@"C"] should] equal:@[@(6), @(7), @(8)]];
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                NSDictionary *result = [input fnx_groupBy:discriminate];
                [[theValue(result.count) should] equal:@(0)];
            });
            
        });

        context(@"Should be able to return the array elements in reverse order", ^{

            it(@"For a nonempty collection", ^{
                NSArray *input = @[@(10), @(20), @(30), @(20)];
                NSArray *expected = @[@(20), @(30), @(20), @(10)];
                [[input.fnx_reverse should] equal:expected];
            });

            it(@"For an empty collection", ^{
                NSArray *input = @[];
                NSArray *expected = @[];
                [[input.fnx_reverse should] equal:expected];
            });
            
        });
        
        context(@"Should be able to test whether or not a selector predicate holds for all elements", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"Where the predicate holds", ^{
                    NSArray *input = @[[FNXMockWithBOOL mockWithBOOL:YES],
                                       [FNXMockWithBOOL mockWithBOOL:YES],
                                       [FNXMockWithBOOL mockWithBOOL:YES]];
                    BOOL result = [input fnx_forallWithSelector:@selector(boolValue)];
                    [[theValue(result) should] beTrue];
                });
                
                it(@"Where the predicate doesn't hold", ^{
                    NSArray *input = @[[FNXMockWithBOOL mockWithBOOL:NO],
                                       [FNXMockWithBOOL mockWithBOOL:YES],
                                       [FNXMockWithBOOL mockWithBOOL:NO]];
                    BOOL result = [input fnx_forallWithSelector:@selector(boolValue)];
                    [[theValue(result) should] beFalse];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                BOOL result = [input fnx_forallWithSelector:@selector(boolValue)];
                [[theValue(result) should] beTrue];
            });
            
        });
        
        context(@"Should be able to apply a function to each element", ^{
            
            context(@"For a nonempty collection", ^{
                NSArray *input = @[[FNXMockWithProcedure mockWithProcedure],
                                   [FNXMockWithProcedure mockWithProcedure],
                                   [FNXMockWithProcedure mockWithProcedure]];
                [input fnx_foreachWithSelector:@selector(procedure)];
                for (FNXMockWithProcedure *obj in input) {
                    [[theValue(obj.testValue) should] equal:theValue(2)];
                }
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [input fnx_foreachWithSelector:@selector(procedure)];
            });
            
        });
        
    });

    context(@"<FNXTraversable>", ^{
        
        context(@"Should be able to return the count of items fulfilling a predicate", ^{
            
            it(@"For a nonempty collection", ^{
                NSArray *input = @[@(10), @(20), @(30), @(20)];
                [[theValue([input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue > 10;
                }]) should] equal:@(3)];
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theValue([input fnx_count:^BOOL(NSNumber *n) {
                    return n.intValue > 10;
                }]) should] equal:@(0)];
            });
            
        });
        
        context(@"Should be able to select all elements except the first n ones", ^{
            
            it(@"For a nonempty collection", ^{
                NSArray *input = @[@(10), @(20), @(30), @(40)];
                id result = [input fnx_drop:2];
                [[result should] equal:@[@(30), @(40)]];
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id<FNXTraversable> result = [input fnx_drop:2];
                [[theValue(result.fnx_size) should] equal:@(0)];
            });
            
        });
        
        context(@"Should be able to determine if any elements satisfy a predicate", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"Where an item satisfies the predicate", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(20)];
                    [[theValue([input fnx_exists:^BOOL(NSNumber *n) {
                        return n.intValue > 10;
                    }]) should] beTrue];
                });

                it(@"Where an item doesn't satisfy the predicate", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(20)];
                    [[theValue([input fnx_exists:^BOOL(NSNumber *n) {
                        return n.intValue > 200;
                    }]) should] beFalse];
                });
            });

            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theValue([input fnx_exists:^BOOL(NSNumber *n) {
                    return n.intValue > 10;
                }]) should] beFalse];
            });
            
        });
        
        context(@"Should be able to select elements of the collection that satisfy a predicate", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"Where matches exist", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(40)];
                    id result = [input fnx_filter:^BOOL(NSNumber *n) {
                        return n.intValue % 20 == 0;
                    }];
                    [[result should] equal:@[@(20), @(40)]];
                });

                it(@"Where matches don't exist", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(40)];
                    id<FNXTraversableOnce> result = [input fnx_filter:^BOOL(NSNumber *n) {
                        return n.intValue >= 200;
                    }];
                    [[theValue(result.fnx_size) should] equal:@(0)];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id<FNXTraversableOnce> result = [input fnx_filter:^BOOL(NSNumber *n) {
                    return n.intValue % 20 == 0;
                }];
                [[theValue(result.fnx_size) should] equal:@(0)];
            });
            
        });
        
        context(@"Should be able to select elements of the collection that don't satisfy a predicate", ^{
            
            it(@"For a nonempty collection", ^{
                NSArray *input = @[@(10), @(20), @(30), @(40)];
                id result = [input fnx_filterNot:^BOOL(NSNumber *n) {
                    return n.intValue % 20 == 0;
                }];
                [[result should] equal:@[@(10), @(30)]];
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id<FNXTraversable> result = [input fnx_filterNot:^BOOL(NSNumber *n) {
                    return n.intValue % 20 == 0;
                }];
                [[theValue(result.fnx_size) should] equal:@(0)];
            });
            
        });
        
        context(@"Should be able to find the first element satisfying a predicate", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"Where a match exists", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(40)];
                    id<FNXOption> result = [input fnx_find:^BOOL(NSNumber *n) {
                        return n.intValue >= 20;
                    }];
                    [[theValue(result.fnx_nonEmpty) should] beTrue];
                    [[result.fnx_get should] equal:@(20)];
                });

                it(@"Where a match doesn't exist", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(40)];
                    id<FNXOption> result = [input fnx_find:^BOOL(NSNumber *n) {
                        return n.intValue >= 200;
                    }];
                    [[theValue(result.fnx_nonEmpty) should] beFalse];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id<FNXOption> result = [input fnx_find:^BOOL(NSNumber *n) {
                    return n.intValue >= 20;
                }];
                [[theValue(result.fnx_nonEmpty) should] beFalse];
            });
            
        });
        
        context(@"Should be able to apply a binary operator to a start value and the elements of the collection from beginning to end", ^{

            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(10)];
                    id result = [input fnx_foldLeftWithStartValue:@(1000)
                                                               op:^id(NSNumber *accumulator, NSNumber *obj) {
                                                                   return @(accumulator.intValue / obj.intValue);
                                                               }];
                    [[result should] equal:@(1000 / 10)];
                });

                it(@"With several elements", ^{
                    NSArray *input = @[@(10), @(5)];
                    id result = [input fnx_foldLeftWithStartValue:@(1000)
                                                               op:^id(NSNumber *accumulator, NSNumber *obj) {
                                                                   return @(accumulator.intValue / obj.intValue);
                                                               }];
                    [[result should] equal:@((1000 / 10) / 5)];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id result = [input fnx_foldLeftWithStartValue:@(10)
                                                           op:^id(NSNumber *accumulator, NSNumber *obj) {
                                                               return @(accumulator.intValue + obj.intValue);
                                                           }];
                [[result should] equal:@(10)];
            });

        });
        
        context(@"Should be able to apply a binary operator to a start value and the elements of the collection from end to beginning", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    id result = [input fnx_foldRightWithStartValue:@(5)
                                                                op:^id(NSNumber *obj, NSNumber *accumulator) {
                                                                    return @(obj.intValue / accumulator.intValue);
                                                                }];
                    [[result should] equal:@(20 / 5)];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(100), @(20)];
                    id result = [input fnx_foldRightWithStartValue:@(5)
                                                                op:^id(NSNumber *obj, NSNumber *accumulator) {
                                                                    return @(obj.intValue / accumulator.intValue);
                                                                }];
                    [[result should] equal:@(100 / (20 / 5))];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id result = [input fnx_foldRightWithStartValue:@(5)
                                                            op:^id(NSNumber *obj, NSNumber *accumulator) {
                                                                return @(obj.intValue / accumulator.intValue);
                                                            }];
                [[result should] equal:@(5)];
            });
            
        });
        
        context(@"Should be able to test whether or not a predicate holds for all elements", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"Where the predicate holds", ^{
                    NSArray *input = @[@(100), @(20)];
                    BOOL result = [input fnx_forall:^BOOL(NSNumber *obj) {
                        return obj.intValue % 2 == 0;
                    }];
                    [[theValue(result) should] beTrue];
                });
                
                it(@"Where the predicate doesn't hold", ^{
                    NSArray *input = @[@(100), @(20)];
                    BOOL result = [input fnx_forall:^BOOL(NSNumber *obj) {
                        return obj.intValue % 2 == 1;
                    }];
                    [[theValue(result) should] beFalse];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                BOOL result = [input fnx_forall:^BOOL(NSNumber *obj) {
                    return obj.intValue % 2 == 1;
                }];
                [[theValue(result) should] beTrue];
            });
            
        });
        
        context(@"Should be able to apply a function to each element", ^{
            
            it(@"For a nonempty collection", ^{
                __block NSInteger total = 1;
                NSArray *input = @[@(100), @(20), @(30)];
                [input fnx_foreach:^(NSNumber *obj) {
                    total += obj.intValue;
                }];
                [[theValue(total) should] equal:@(1 + 100 + 20 + 30)];
            });
            
            it(@"For an empty collection", ^{
                __block NSInteger total = 1;
                NSArray *input = @[];
                [input fnx_foreach:^(NSNumber *obj) {
                    total += obj.intValue;
                }];
                [[theValue(total) should] equal:@(1)];
            });
            
        });
        
        context(@"Should be able to return the first element", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    [[input.fnx_head should] equal:@(20)];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(100), @(20)];
                    [[input.fnx_head should] equal:@(100)];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theBlock(^{
                    [input fnx_head];
                }) should] raise];
            });
            
        });
        
        context(@"Should be able to optionally return the first element", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    id<FNXOption> result = input.fnx_headOption;
                    [[theValue(result.fnx_nonEmpty) should] beTrue];
                    [[result.fnx_get should] equal:@(20)];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(100), @(20)];
                    id<FNXOption> result = input.fnx_headOption;
                    [[theValue(result.fnx_nonEmpty) should] beTrue];
                    [[result.fnx_get should] equal:@(100)];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id<FNXOption> result = input.fnx_headOption;
                [[theValue(result.fnx_isEmpty) should] beTrue];
            });
            
        });
        
        context(@"Should be able to select all the elements except the last one", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    [[theValue(input.fnx_init.fnx_isEmpty) should] beTrue];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(10), @(20), @(30)];
                    [[((id)input.fnx_init) should] equal:@[@(10), @(20)]];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theBlock(^{
                    [input fnx_init];
                }) should] raise];
            });
            
        });
        
        context(@"Should be able to indicate whether it's empty", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    [[theValue(input.fnx_isEmpty) should] beFalse];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(100), @(20)];
                    [[theValue(input.fnx_isEmpty) should] beFalse];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theValue(input.fnx_isEmpty) should] beTrue];
            });
            
        });
        
        context(@"Should be able to return the last element", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    [[input.fnx_last should] equal:@(20)];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(100), @(20), @(30)];
                    [[input.fnx_last should] equal:@(30)];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theBlock(^{
                    [input fnx_last];
                }) should] raise];
            });
            
        });
        
        context(@"Should be able to optionally return the last element", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    id<FNXOption> result = input.fnx_lastOption;
                    [[theValue(result.fnx_nonEmpty) should] beTrue];
                    [[result.fnx_get should] equal:@(20)];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(100), @(20), @(30)];
                    id<FNXOption> result = input.fnx_lastOption;
                    [[theValue(result.fnx_nonEmpty) should] beTrue];
                    [[result.fnx_get should] equal:@(30)];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id<FNXOption> result = input.fnx_lastOption;
                [[theValue(result.fnx_isEmpty) should] beTrue];
            });
            
        });
        
        context(@"Should be able to build a new collection by applying a function to all elements", ^{
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    id<FNXTraversableOnce> result = [input fnx_map:^id(NSNumber *obj) {
                        return @(2 * obj.intValue);
                    }];
                    [[((id)result) should] equal:@[@(2*20)]];
                });
                it(@"With several elements", ^{
                    NSArray *input = @[@(10), @(20), @(30)];
                    id<FNXTraversableOnce> result = [input fnx_map:^id(NSNumber *obj) {
                        return @(2 * obj.intValue);
                    }];
                    [[((id)result) should] equal:@[@(2*10), @(2*20), @(2*30)]];
                });
            });
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                id<FNXTraversableOnce> result = [input fnx_map:^id(NSNumber *obj) {
                    return @(2 * obj.intValue);
                }];
                [[theValue(result.fnx_isEmpty) should] beTrue];
            });
        });
        
        context(@"Should be able to indicate whether it's non-empty", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    [[theValue(input.fnx_nonEmpty) should] beTrue];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(100), @(20)];
                    [[theValue(input.fnx_nonEmpty) should] beTrue];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theValue(input.fnx_nonEmpty) should] beFalse];
            });
            
        });
        
        context(@"Should be able to provide its size", ^{
            
            it(@"For a nonempty collection", ^{
                NSArray *input = @[@(100), @(20)];
                [[theValue(input.fnx_size) should] equal:@(2)];
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theValue(input.fnx_size) should] equal:@(0)];
            });
            
        });
        
        context(@"Should be able to select all the elements except the first one", ^{
            context(@"For a nonempty collection", ^{
                it(@"With one element", ^{
                    NSArray *input = @[@(20)];
                    [[theValue(input.fnx_tail.fnx_isEmpty) should] beTrue];
                });
                it(@"With several elements", ^{
                    NSArray *input = @[@(10), @(20), @(30)];
                    [[((id)input.fnx_tail) should] equal:@[@(20), @(30)]];
                });
            });
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theBlock(^{
                    [input fnx_tail];
                }) should] raise];
            });
        });
    });
    
    context(@"<FNXIterable>", ^{
        context(@"Should be able to iterate over the items in the collection with the returned iterator", ^{
            
            void (^testIteratorWithInput)(NSArray *input) = ^(NSArray *input) {
                NSUInteger i = 0;
                NSEnumerator *iterator = [input fnx_iterator];
                id obj = iterator.nextObject;
                while (obj) {
                    [[obj should] equal:input[i]];
                    ++i;
                    obj = iterator.nextObject;
                }
            };
            
            it(@"For a nonempty collection", ^{
                NSArray *input = @[@(10), @(20), @(30)];
                testIteratorWithInput(input);
            });
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                testIteratorWithInput(input);
            });
        });
    });
    
});

SPEC_END
