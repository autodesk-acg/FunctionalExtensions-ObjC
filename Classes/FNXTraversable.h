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

@protocol FNXOption;


@protocol FNXTraversableOnce <NSObject>

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)fnx_count:(BOOL (^)(id obj))pred;

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)fnx_exists:(BOOL (^)(id obj))pred;

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

// The size of this collection.
- (NSUInteger)fnx_size;

// Converts this traversable to an array.
- (NSArray *)fnx_toArray;

@end


@protocol FNXTraversable <FNXTraversableOnce>

// Selects all elements except first n ones.
- (id<FNXTraversable>)fnx_drop:(NSUInteger)n;

// Selects all elements of this collection which satisfy a predicate.
- (id<FNXTraversable>)fnx_filter:(BOOL (^)(id obj))pred;

// Selects all elements of this collection which do not satisfy a predicate.
- (id<FNXTraversable>)fnx_filterNot:(BOOL (^)(id obj))pred;

// Selects the first element of this collection.
- (id)fnx_head;

// Optionally selects the first element of this collection.
- (id<FNXOption>)fnx_headOption;

// Selects all elements except the last.
- (id<FNXTraversable>)fnx_init;

// Selects the last element.
- (id)fnx_last;

// Optionally selects the last element.
- (id<FNXOption>)fnx_lastOption;

// Builds a new collection by applying a function to all elements of this collection.
- (id<FNXTraversable>)fnx_map:(id (^)(id obj))fn;

// Tests whether the collection is not empty.
- (BOOL)fnx_nonEmpty;

// Selects all elements except the first.
- (id<FNXTraversable>)fnx_tail;

@end


@protocol FNXIterable <FNXTraversable>

// Returns an iterator for elements in this collection
- (NSEnumerator *)fnx_iterator;

@end
