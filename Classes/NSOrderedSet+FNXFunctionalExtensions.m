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

#import "NSOrderedSet+FNXFunctionalExtensions.h"
#import "FNXOption.h"
#import "FNXSome.h"
#import "FNXNone.h"
#import "NSArray+FNXFunctionalExtensions.h"


@implementation NSOrderedSet (FNXFunctionalExtensions)

// Builds a new collection by applying a function to all elements of this collection
// and using the elements of the resulting collections.
- (NSOrderedSet *)fnx_flatMap:(id<FNXTraversableOnce> (^)(id obj))fn
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        [result addObjectsFromArray:fn(obj).fnx_toArray];
    }
    return [NSOrderedSet orderedSetWithArray:result];
}

// Returns a new collection with the elements of this collection in reversed order.
- (NSOrderedSet *)fnx_reverse
{
    return (0 == self.count)
        ? [NSOrderedSet orderedSet]
        : [NSOrderedSet orderedSetWithArray:self.reverseObjectEnumerator.allObjects];
}

@end


@implementation NSOrderedSet (FNXIterable)

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
    if (n >= self.count) {
        return [NSArray array];
    } else {
        NSRange range = NSMakeRange(n, self.count - n);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        return [self objectsAtIndexes:indexSet];
    }
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
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return pred(obj);
    }];
    return [self objectsAtIndexes:indexSet];
}

// Selects all elements of this collection which do not satisfy a predicate.
- (id<FNXTraversable>)fnx_filterNot:(BOOL (^)(id obj))pred
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return !pred(obj);
    }];
    return [self objectsAtIndexes:indexSet];
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
    id accumulator = startValue;
    for (id obj in self.reverseObjectEnumerator) {
        accumulator = op(obj, accumulator);
    }
    return accumulator;
}

// Tests whether a predicate holds for all elements of this collection.
- (BOOL)fnx_forall:(BOOL (^)(id obj))pred
{
    __block BOOL result = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = result && pred(obj);
        *stop = !result;
    }];
    return result;
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
    return self[0];
}

// Optionally selects the first element of this collection.
- (id<FNXOption>)fnx_headOption
{
    if (self.count > 0) {
        return [FNXSome someWithValue:self[0]];
    } else {
        return [NSNull fnx_none];
    }
}

// Selects the last element.
- (id)fnx_last
{
    // This should throw an exception if the collection is empty.
    return self[self.count - 1];
}

// Optionally selects the last element.
- (id<FNXOption>)fnx_lastOption
{
    if (self.count > 0) {
        return [FNXSome someWithValue:self.fnx_last];
    } else {
        return [NSNull fnx_none];
    }
}

// Selects all elements except the last.
- (id<FNXTraversable>)fnx_init
{
    // This should throw an exception if the collection is empty.
    NSRange range = NSMakeRange(0, self.count - 1);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    return [self objectsAtIndexes:indexSet];
}

// Tests whether this collection is empty.
- (BOOL)fnx_isEmpty
{
    return 0 == self.count;
}

// Builds a new collection by applying a function to all elements of this collection.
// If fn could return nil, it must return [FNXNone none] instead and the other values
// should be mapped as FNXSome values.
- (id<FNXTraversable>)fnx_map:(id (^)(id obj))fn
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        [result addObject:fn(obj)];
    }
    return [result copy];
}

// Tests whether the mutable indexed sequence is not empty.
- (BOOL)fnx_nonEmpty
{
    return self.count > 0;
}

// The size of this collection.
- (NSUInteger)fnx_size
{
    return self.count;
}

// Selects all elements except the first.
- (id<FNXTraversable>)fnx_tail
{
    // This should throw an exception if the list is empty.
    NSRange range = NSMakeRange(1, self.count - 1);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    return [self objectsAtIndexes:indexSet];
}

// Converts this traversable to an array.
- (NSArray *)fnx_toArray
{
    return self.array;
}

- (NSEnumerator *)fnx_iterator
{
    return self.objectEnumerator;
}

@end
