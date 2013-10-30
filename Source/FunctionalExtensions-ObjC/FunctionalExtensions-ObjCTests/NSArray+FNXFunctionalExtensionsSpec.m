//
//  NSArray+FNXFunctionalExtensionsSpec.m
//  FunctionalExtensions-ObjC
//
//  Created by Kent Wong on 10/29/2013.
//  Copyright (c) 2013 Autodesk Inc. All rights reserved.
//

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
                    FNXOption *result = [input fnx_find:^BOOL(NSNumber *n) {
                        return n.intValue >= 20;
                    }];
                    [[theValue(result.nonEmpty) should] beTrue];
                    [[result.get should] equal:@(20)];
                });

                it(@"Where a match doesn't exist", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(40)];
                    FNXOption *result = [input fnx_find:^BOOL(NSNumber *n) {
                        return n.intValue >= 200;
                    }];
                    [[theValue(result.nonEmpty) should] beFalse];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                FNXOption *result = [input fnx_find:^BOOL(NSNumber *n) {
                    return n.intValue >= 20;
                }];
                [[theValue(result.nonEmpty) should] beFalse];
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
                    FNXOption *result = input.fnx_headOption;
                    [[theValue(result.nonEmpty) should] beTrue];
                    [[result.get should] equal:@(20)];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(100), @(20)];
                    FNXOption *result = input.fnx_headOption;
                    [[theValue(result.nonEmpty) should] beTrue];
                    [[result.get should] equal:@(100)];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                FNXOption *result = input.fnx_headOption;
                [[theValue(result.isEmpty) should] beTrue];
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
                    FNXOption *result = input.fnx_lastOption;
                    [[theValue(result.nonEmpty) should] beTrue];
                    [[result.get should] equal:@(20)];
                });
                
                it(@"With several elements", ^{
                    NSArray *input = @[@(100), @(20), @(30)];
                    FNXOption *result = input.fnx_lastOption;
                    [[theValue(result.nonEmpty) should] beTrue];
                    [[result.get should] equal:@(30)];
                });
            });
            
            it(@"For an empty collection", ^{
                NSArray *input = @[];
                FNXOption *result = input.fnx_lastOption;
                [[theValue(result.isEmpty) should] beTrue];
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
    
});

SPEC_END
