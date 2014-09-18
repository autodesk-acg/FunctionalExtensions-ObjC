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

#import "NSEnumerator+FNXFunctionalExtensions.h"
#import "NSArray+FNXFunctionalExtensions.h"
#import "FNXNone.h"
#import "FNXSome.h"

@implementation NSEnumerator (FNXFunctionalExtensions)
@end


@implementation NSEnumerator (FNXIterable)

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)fnx_count:(BOOL (^)(id obj))pred
{
    __block NSUInteger result = 0;
    for (id obj in self) {
        if (pred(obj)) {
            result += 1;
        }
    }
    return result;
}

// Selects all elements except first n ones.
- (id<FNXTraversable>)fnx_drop:(NSUInteger)n
{
    return [self.allObjects fnx_drop:n];
}

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)fnx_exists:(BOOL (^)(id obj))pred
{
    for (id obj in self) {
        if (pred(obj)) {
            return YES;
        }
    }
    return NO;
}

// Selects all elements of this collection which satisfy a predicate.
- (id<FNXTraversable>)fnx_filter:(BOOL (^)(id obj))pred
{
    return [self.allObjects fnx_filter:pred];
}

// Selects all elements of this collection which do not satisfy a predicate.
- (id<FNXTraversable>)fnx_filterNot:(BOOL (^)(id obj))pred
{
    return [self.allObjects fnx_filterNot:pred];
}

// Finds the first element of the collection satisfying a predicate, if any.
- (id<FNXOption>)fnx_find:(BOOL (^)(id obj))pred
{
    for (id obj in self) {
        if (pred(obj)) {
            return [FNXSome someWithValue:obj];
        }
    }
    return [NSNull fnx_none];
}

// Applies a binary operator to a start value and all elements of this collection, going left to right.
// op(...op(startValue, x_1), x_2, ..., x_n)
- (id)fnx_foldLeftWithStartValue:(id)startValue op:(id (^)(id accumulator, id obj))op
{
    id accumulator = startValue;
    for (id obj in self) {
        accumulator = op(accumulator, obj);
    }
    return accumulator;
}

// Applies a binary operator to all elements of this iterable collection and a start value, going right to left.
// op(x_1, op(x_2, ... op(x_n, z)...))
- (id)fnx_foldRightWithStartValue:(id)startValue op:(id (^)(id obj, id accumulator))op
{
    return [self.allObjects fnx_foldRightWithStartValue:startValue op:op];
}

// Tests whether a predicate holds for all elements of this collection.
- (BOOL)fnx_forall:(BOOL (^)(id obj))pred
{
    for (id obj in self) {
        if (!pred(obj)) {
            return NO;
        }
    }
    return YES;
}

// Applies a function fn to all elements of this collection.
- (void)fnx_foreach:(void (^)(id obj))fn
{
    for (id obj in self) {
        fn(obj);
    }
}

// Selects the first element of this collection.
- (id)fnx_head
{
    // We want this to throw an exception if out of bounds.
    return self.allObjects[0];
}

// Optionally selects the first element of this collection.
- (id<FNXOption>)fnx_headOption
{
    return [self.allObjects fnx_headOption];
}

// Selects the last element.
- (id)fnx_last
{
    return [self.allObjects fnx_last];
}

// Optionally selects the last element.
- (id<FNXOption>)fnx_lastOption
{
    return [self.allObjects fnx_lastOption];
}

// Selects all elements except the last.
- (id<FNXTraversable>)fnx_init
{
    return [self.allObjects fnx_init];
}

// Tests whether this collection is empty.
- (BOOL)fnx_isEmpty
{
    return [self.allObjects fnx_isEmpty];
}

// Builds a new collection by applying a function to all elements of this collection.
// If fn could return nil, it must return [FNXNone none] instead and the other values
// should be mapped as FNXSome values.
- (id<FNXTraversable>)fnx_map:(id (^)(id obj))fn
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        [result addObject:fn(obj)];
    }
    return [result copy];
}

// Tests whether the mutable indexed sequence is not empty.
- (BOOL)fnx_nonEmpty
{
    return [self.allObjects fnx_nonEmpty];
}

// The size of this collection.
- (NSUInteger)fnx_size
{
    return self.allObjects.count;
}

// Selects all elements except the first.
- (id<FNXTraversable>)fnx_tail
{
    return [self.allObjects fnx_tail];
}

// Converts this traversable to an array.
- (NSArray *)fnx_toArray
{
    return self.allObjects;
}

- (NSEnumerator *)fnx_iterator
{
    // Create a fresh enumerator since enumerators can't be reset.
    return self.allObjects.objectEnumerator;
}

@end
