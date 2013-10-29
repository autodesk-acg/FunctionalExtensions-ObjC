//
//  NSArray+FNXFunctionalExtensionsSpec.m
//  FunctionalExtensions-ObjC
//
//  Created by Kent Wong on 10/29/2013.
//  Copyright (c) 2013 Autodesk Inc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "NSArray+FNXFunctionalExtensions.h"


SPEC_BEGIN(NSArray_FNXFunctionalExtensionsSpec)

describe(@"NSArray+FNXFunctionalExtensions", ^{
    
    context(@"Scala-style functional extensions for NSArray", ^{
        
        beforeAll(^{ // Occurs once
        });
        
        afterAll(^{ // Occurs once
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
        });
        
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
                id result = [input fnx_drop:2];
                [[result should] equal:@[]];
            });
            
        });
        
        context(@"Should be able to determine if any elements fulfill a predicate", ^{
            
            context(@"For a nonempty collection", ^{
                it(@"Where an item fulfills the predicate", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(20)];
                    [[theValue([input fnx_exists:^BOOL(NSNumber *n) {
                        return n.intValue > 10;
                    }]) should] equal:@(YES)];
                });

                it(@"Where an item doesn't fulfill the predicate", ^{
                    NSArray *input = @[@(10), @(20), @(30), @(20)];
                    [[theValue([input fnx_exists:^BOOL(NSNumber *n) {
                        return n.intValue > 200;
                    }]) should] equal:@(NO)];
                });
            });

            it(@"For an empty collection", ^{
                NSArray *input = @[];
                [[theValue([input fnx_exists:^BOOL(NSNumber *n) {
                    return n.intValue > 10;
                }]) should] equal:@(NO)];
            });
            
        });
        
    });
    
});

SPEC_END
