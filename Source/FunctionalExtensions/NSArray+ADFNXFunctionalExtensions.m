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

#import "NSArray+ADFNXFunctionalExtensions.h"
#import "ADFNXSome.h"
#import "ADFNXNone.h"


@implementation NSArray (ADFNXFunctionalExtensions)

// Builds a new array from this collection without any duplicate elements.
- (NSArray *)adfnx_distinct
{
    return [self valueForKeyPath:@"@distinctUnionOfObjects.self"];
}

// Selects all elements except first n ones.
- (NSArray *)adfnx_drop:(NSUInteger)n
{
    if (n >= self.count) {
        return [NSArray array];
    } else {
        NSRange range = NSMakeRange(n + 1, self.count - n);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        return [self objectsAtIndexes:indexSet];
    }
}

// Tests whether a predicate holds for some of the elements of this array.
- (BOOL)adfnx_exists:(BOOL (^)(id obj))pred
{
    for (id obj in self) {
        if (pred(obj)) {
            return YES;
        }
    }
    return NO;
}

// Finds the first element of the collection satisfying a predicate, if any.
- (ADFNXOption *)adfnx_find:(BOOL (^)(id obj))pred
{
    for (id obj in self) {
        if (pred(obj)) {
            return [ADFNXSome someWithValue:obj];
        }
    }
    return [ADFNXNone none];
}

// Builds a new collection by applying a function to all elements of this collection
// and using the elements of the resulting collections.
- (NSArray *)adfnx_flatMap:(id (^)(id obj))fn
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        [result addObject:fn(obj)];
    }
    return [result copy];
}

// Applies a function fn to all elements of this collection in _parallel_.
- (void)adfnx_foreachParallel:(void (^)(id obj))fn
{
    [self enumerateObjectsWithOptions:NSEnumerationConcurrent
                           usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                               fn(obj);
                           }];
}

// Selects the first element of this collection.
- (id)adfnx_head
{
    // We want this to throw an exception if out of bounds.
    return self[0];
}

// Optionally selects the first element of this collection.
- (ADFNXOption *)adfnx_headOption
{
    return self.count > 0 ? [ADFNXSome someWithValue:self[0]] : [ADFNXNone none];
}

// Selects all elements except the last.
- (id)adfnx_init
{
    // This should throw an exception if the collection is empty.
    NSRange range = NSMakeRange(0, self.count - 1);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    return [self objectsAtIndexes:indexSet];
}

// Selects the last element.
- (id)adfnx_last
{
    // This should throw an exception if the collection is empty.
    return self[self.count - 1];
}

// Optionally selects the last element.
- (ADFNXOption *)adfnx_lastOption
{
    return self.count > 0 ? [ADFNXSome someWithValue:self.adfnx_last] : [ADFNXNone none];
}

// Returns a new collection with the elements of this collection in reversed order.
- (NSArray *)adfnx_reverse
{
    return (0 == self.count) ? [NSArray array] : self.reverseObjectEnumerator.allObjects;
}

// Selects all elements except the first.
- (NSArray *)adfnx_tail
{
    // This should throw an exception if the list is empty.
    NSRange range = NSMakeRange(1, self.count - 1);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    return [self objectsAtIndexes:indexSet];
}

@end


@implementation NSArray (ADFNXTraversable)

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)adfnx_count:(BOOL (^)(id obj))pred
{
    __block NSUInteger result = 0;
    for (id obj in self) {
        if (pred(obj)) {
            result += 1;
        }
    }
    return result;
}

// Selects all elements of this collection which satisfy a predicate.
- (id<ADFNXTraversable>)adfnx_filter:(BOOL (^)(id obj))pred
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return pred(obj);
    }];
    return [self objectsAtIndexes:indexSet];
}

// Selects all elements of this collection which do not satisfy a predicate.
- (id<ADFNXTraversable>)adfnx_filterNot:(BOOL (^)(id obj))pred
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return !pred(obj);
    }];
    return [self objectsAtIndexes:indexSet];
}

// Tests whether a predicate holds for all elements of this collection.
- (BOOL)adfnx_forall:(BOOL (^)(id obj))pred
{
    __block BOOL result = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = result && pred(obj);
        *stop = !result;
    }];
    return result;
}

// Applies a function fn to all elements of this collection.
- (void)adfnx_foreach:(void (^)(id obj))fn
{
    for (id obj in self) {
        fn(obj);
    }
}

// Tests whether this collection is empty.
- (BOOL)adfnx_isEmpty
{
    return 0 == self.count;
}

// Builds a new collection by applying a function to all elements of this collection.
// If fn could return nil, it must return [FNXNone none] instead and the other values
// should be mapped as FNXSome values.
- (NSArray *)adfnx_map:(id (^)(id obj))fn
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        [result addObject:fn(obj)];
    }
    return [result copy];
}

// Builds a new collection by applying a function to all elements of this array in _parallel_.
// If fn could return nil, it must return [FNXNone none] instead and the other values
// should be mapped as FNXSome values.
- (NSArray *)adfnx_mapParallel:(id (^)(id obj))fn
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (NSUInteger i = 0; i < self.count; ++i) {
        [result addObject:NSNull.null];
    }
    
    // Because the block may be called concurrently, we have to insert the result of the map directly,
    // rather than using [addObject:].
    [self enumerateObjectsWithOptions:NSEnumerationConcurrent
                           usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                               result[idx] = fn(obj);
                           }];
    
    return [result copy];
}

// Tests whether the mutable indexed sequence is not empty.
- (BOOL)adfnx_nonEmpty
{
    return self.count > 0;
}

@end
