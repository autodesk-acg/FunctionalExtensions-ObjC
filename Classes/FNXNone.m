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

#import "FNXNone.h"
#import "NSArray+FNXFunctionalExtensions.h"


@implementation NSNull (FNXNone)

#pragma mark - FNXTraversableOnce

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)fnx_count:(BOOL (^)(id obj))pred
{
    return 0;
}

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)fnx_exists:(BOOL (^)(id obj))pred
{
    return NO;
}

// Selects all elements of this collection which satisfy a predicate.
- (id<FNXOption>)fnx_filter:(BOOL (^)(id obj))pred
{
    return self;
}

// Finds the first element of the collection satisfying a predicate, if any.
- (id<FNXOption>)fnx_find:(BOOL (^)(id obj))pred
{
    return self;
}

// Applies a binary operator to a start value and all elements of this collection, going left to right.
// op(...op(startValue, x_1), x_2, ..., x_n)
- (id)fnx_foldLeftWithStartValue:(id)startValue op:(id (^)(id accumulator, id obj))op
{
    return startValue;
}

// Applies a binary operator to all elements of this iterable collection and a start value, going right to left.
// op(x_1, op(x_2, ... op(x_n, z)...))
- (id)fnx_foldRightWithStartValue:(id)startValue op:(id (^)(id obj, id accumulator))op
{
    return startValue;
}

// Tests whether a predicate holds for all elements of this collection.
- (BOOL)fnx_forall:(BOOL (^)(id obj))pred
{
    return YES;
}

// Apply the given procedure fn to every element in the collection.
- (void)fnx_foreach:(void (^)(id obj))fn
{
    // Nothing to do.
}

// Tests whether this collection is empty.
- (BOOL)fnx_isEmpty
{
    return YES;
}

// Builds a new collection by applying a function to all elements of this collection.
- (id<FNXOption>)fnx_map:(id (^)(id obj))fn
{
    return self;
}

// The size of this collection.
- (NSUInteger)fnx_size
{
    return 0;
}

// Converts this traversable to an array.
- (NSArray *)fnx_toArray
{
    return [NSArray array];
}

#pragma mark - FNXTraversable

// Selects all elements except first n ones.
- (id<FNXTraversable>)fnx_drop:(NSUInteger)n
{
    return [NSArray array];
}

// Selects all elements of this collection which do not satisfy a predicate.
- (id<FNXOption>)fnx_filterNot:(BOOL (^)(id obj))pred
{
    return self;
}

// Selects the first element of this collection.
- (id)fnx_head
{
    @throw [[NSException alloc] initWithName:@"ADFNXNoSuchElement"
                                      reason:NSLocalizedString(@"Head of empty list", @"Message when [ADFNXNone head] is called")
                                    userInfo:nil];
}

// Optionally selects the first element of this collection.
- (id<FNXOption>)fnx_headOption
{
    return self;
}

// Selects the last element.
- (id)fnx_last
{
    @throw [[NSException alloc] initWithName:@"ADFNXNoSuchElement"
                                      reason:NSLocalizedString(@"Last of empty list", @"Message when [ADFNXNone last] is called")
                                    userInfo:nil];
}

// Optionally selects the last element.
- (id<FNXOption>)fnx_lastOption
{
    return self;
}

// Selects all elements except the last.
- (id<FNXTraversable>)fnx_init
{
    @throw [[NSException alloc] initWithName:@"FNXUnsupportedOperation"
                                      reason:NSLocalizedString(@"Empty initial", @"Message when [ADFNXNone initial] is called")
                                    userInfo:nil];
}

// Tests whether the collection is not empty.
- (BOOL)fnx_nonEmpty
{
    return NO;
}

// Selects all elements except the first.
- (id<FNXTraversable>)fnx_tail
{
    @throw [[NSException alloc] initWithName:@"FNXUnsupportedOperation"
                                      reason:NSLocalizedString(@"Tail of empty list", @"Message when [ADFNXNone tail] is called")
                                    userInfo:nil];
}

#pragma mark - FNXOption

// Returns the option's value.
// Abstract
- (id)fnx_get
{
    @throw [[NSException alloc] initWithName:@"ADFNXNoSuchElement"
                                      reason:NSLocalizedString(@"No such element", @"Message when [None get] is called")
                                    userInfo:nil];
}

// Returns the option's value if the option is nonempty, otherwise return the result of evaluating defaultValue.
- (id)fnx_getOrElse:(id)defaultValue
{
    return defaultValue;
}

// Returns YES if the option is an instance of ADFNXSome, NO otherwise.
// Abstract
- (BOOL)fnx_isDefined
{
    return NO;
}

// Returns this FNXOption if it is nonempty, otherwise return the result of evaluating alternative.
- (id<FNXOption>)fnx_orElse:(id<FNXOption>(^)(void))alternative
{
    return alternative();
}

// Builds a new collection by applying a function to all elements of this collection.
- (id<FNXOption>)fnx_mapAsOption:(id (^)(id obj))fn
{
    return self;
}

- (id<FNXIterable>)fnx_toIterable
{
    return [FNXOptionAsIterable optionAsIterableWithOption:self];
}

// Returns the result of applying fn to this Option's value if this Option is nonempty.
- (id<FNXOption>)fnx_flatMap:(id<FNXOption> (^)(id obj))fn
{
    return self;
}

#pragma mark - FNXNone

// Returns the singleton instance of None.
+ (id<FNXNone>)fnx_none
{
    return [NSNull null];
}

@end
