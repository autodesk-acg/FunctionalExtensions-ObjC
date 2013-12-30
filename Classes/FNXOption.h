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


@protocol FNXOption <NSObject>

// Returns the option's value.
// Abstract
- (id)fnx_get;

// Returns the option's value if the option is nonempty, otherwise return the result of evaluating defaultValue.
- (id)fnx_getOrElse:(id)defaultValue;

// Returns YES if the option is an instance of ADFNXSome, NO otherwise.
// Abstract
- (BOOL)fnx_isDefined;

// Returns this ADFNXOption if it is nonempty, otherwise return the result of evaluating alternative.
- (id<FNXOption>)fnx_orElse:(id<FNXOption>(^)(void))alternative;

- (id<FNXIterable>)fnx_toIterable;

#pragma mark - FNXTraversableOnce

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)fnx_count:(BOOL (^)(id obj))pred;

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)fnx_exists:(BOOL (^)(id obj))pred;

// Selects all elements of this collection which satisfy a predicate.
- (id<FNXOption>)fnx_filter:(BOOL (^)(id obj))pred;

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
- (id<FNXOption>)fnx_map:(id (^)(id obj))fn;

// The size of this collection.
- (NSUInteger)fnx_size;

// Converts this traversable to an array.
- (NSArray *)fnx_toArray;

#pragma mark - FNXTraversable

// Selects all elements except first n ones.
- (id<FNXIterable>)fnx_drop:(NSUInteger)n;

// Selects all elements of this collection which do not satisfy a predicate.
- (id<FNXOption>)fnx_filterNot:(BOOL (^)(id obj))pred;

// Selects the first element of this collection.
- (id)fnx_head;

// Optionally selects the first element of this collection.
- (id<FNXOption>)fnx_headOption;

// Selects all elements except the last.
- (id<FNXIterable>)fnx_init;

// Selects the last element.
- (id)fnx_last;

// Optionally selects the last element.
- (id<FNXOption>)fnx_lastOption;

// Tests whether the collection is not empty.
- (BOOL)fnx_nonEmpty;

// Selects all elements except the first.
- (id<FNXIterable>)fnx_tail;

@end


@interface FNXOptionAsIterable : NSObject <FNXIterable>

@property (nonatomic, strong, readonly) id<FNXOption> option;

+ (instancetype)optionAsIterableWithOption:(id<FNXOption>)option;

@end
