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

#import <Foundation/Foundation.h>
#import "FNXTraversable.h"


// Scala-style functional extensions for NSArray.
@interface NSArray (FNXFunctionalExtensions) <FNXIterable>

// Builds a new array from this collection without any duplicate elements.
- (NSArray *)fnx_distinct;

// Selects all elements except last n ones.
- (NSArray *)fnx_dropRight:(NSUInteger)n;

// Drops longest prefix of elements that satisfy a predicate.
- (NSArray *)fnx_dropWhile:(BOOL (^)(id obj))pred;

// Builds a new collection by applying a function to all elements of this collection
// and using the elements of the resulting collections.
- (NSArray *)fnx_flatMap:(NSArray *(^)(id obj))fn;

// Invokes pred for elements of this collection. Returns NO if any results return NO; YES, otherwise.
// pred must be a method on the element that takes no arguments and returns BOOL.
- (BOOL)fnx_forallWithSelector:(SEL)pred;

// Invokes fn for elements of this collection.
// fn must be a method on the element that takes no arguments and returns void.
- (void)fnx_foreachWithSelector:(SEL)fn;

//// Applies a function fn to all elements of this collection in _parallel_.
//- (void)fnx_foreachParallel:(void (^)(id obj))fn;

// Partitions this collection into a dictionary of collections according to some discriminator function, fn. The
// discriminator function should return an object representing which bucket the object must be placed into and that will
// be used as a key in the resultant dictionary.
- (NSDictionary *)fnx_groupBy:(id (^)(id obj))fn;

//// Builds a new collection by applying a function to all elements of this array in _parallel_.
//// If fn could return nil, it must return [FNXNone none] instead and the other values
//// should be mapped as FNXSome values.
//- (NSArray *)fnx_mapParallel:(id (^)(id obj))fn;

// Returns a new collection with the elements of this collection in reversed order.
- (NSArray *)fnx_reverse;

@end


@interface NSArray (FNXTraversableOnce)

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)fnx_count:(BOOL (^)(id obj))pred;

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)fnx_exists:(BOOL (^)(id obj))pred;

// Selects all elements of this collection which satisfy a predicate.
- (NSArray *)fnx_filter:(BOOL (^)(id obj))pred;

// Finds the first element of the collection satisfying a predicate, if any.
- (id<FNXOption>)fnx_find:(BOOL (^)(id obj))pred;

// Applies a binary operator to a start value and all elements of this collection, going left to right.
// op(...op(startValue, x_1), x_2, ..., x_n)
// Can be used on an empty traversable.
- (id)fnx_foldLeftWithStartValue:(id)startValue op:(id (^)(id accumulator, id obj))op;

// Applies a binary operator to all elements of this iterable collection and a start value, going right to left.
// op(x_1, op(x_2, ... op(x_n, z)...))
// Can be used on an empty traversable.
- (id)fnx_foldRightWithStartValue:(id)startValue op:(id (^)(id obj, id accumulator))op;

// Tests whether a predicate holds for all elements of this collection.
- (BOOL)fnx_forall:(BOOL (^)(id obj))pred;

// Apply the given procedure fn to every element in the collection.
- (void)fnx_foreach:(void (^)(id obj))fn;

// Tests whether this collection is empty.
- (BOOL)fnx_isEmpty;

// Builds a new collection by applying a function to all elements of this collection.
- (NSArray *)fnx_map:(id (^)(id obj))fn;

// The size of this collection.
- (NSUInteger)fnx_size;

// Converts this traversable to an array.
- (NSArray *)fnx_toArray;

@end


@interface NSArray (FNXTraversable)

// Selects all elements except first n ones.
- (NSArray *)fnx_drop:(NSUInteger)n;

// Selects all elements of this collection which do not satisfy a predicate.
- (NSArray *)fnx_filterNot:(BOOL (^)(id obj))pred;

// Selects the first element of this collection.
- (id)fnx_head;

// Optionally selects the first element of this collection.
- (id<FNXOption>)fnx_headOption;

// Selects all elements except the last.
- (NSArray *)fnx_init;

// Selects the last element.
- (id)fnx_last;

// Optionally selects the last element.
- (id<FNXOption>)fnx_lastOption;

// Tests whether the collection is not empty.
- (BOOL)fnx_nonEmpty;

// Selects all elements except the first.
- (NSArray *)fnx_tail;

@end


@interface NSArray (FNXIterable)

// Returns an iterator for elements in this collection
- (NSEnumerator *)fnx_iterator;

@end
