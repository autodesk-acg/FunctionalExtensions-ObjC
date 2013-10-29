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

#import "FNXOption.h"
#import "FNXSome.h"
#import "FNXNone.h"
#import "NSArray+ADFNXFunctionalExtensions.h"


@implementation FNXOption

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)count:(BOOL (^)(id obj))pred
{
    if (self.isEmpty) {
        return 0;
    } else {
        return pred(self.get) ? 1 : 0;
    }
}

// Selects all elements except first n ones.
- (id<FNXTraversable>)drop:(NSUInteger)n
{
    if (self.nonEmpty && 0 == n) {
        return [NSArray arrayWithObject:self.get];
    } else {
        return [NSArray array];
    }
}

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)exists:(BOOL (^)(id obj))pred
{
    return self.nonEmpty && pred(self.get);
}

// Returns this ADFNXOption if it is nonempty and applying the predicate pred to
// this ADFNXOption's value returns YES. Otherwise, return ADFNXNone.
- (FNXOption *)filter:(BOOL (^)(id obj))pred
{
    return (self.nonEmpty && pred(self.get)) ? self : [FNXNone none];
}

// Returns this ADFNXOption if it is nonempty and applying the predicate pred
// to this option's value returns NO.
- (FNXOption *)filterNot:(BOOL (^)(id obj))pred
{
    return (self.nonEmpty && !pred(self.get)) ? self : [FNXNone none];
}

// Finds the first element of the collection satisfying a predicate, if any.
- (FNXOption *)find:(BOOL (^)(id obj))pred
{
    return (self.nonEmpty && pred(self.get)) ? self : [FNXNone none];
}

// Returns the result of applying fn to this ADFNXOption's value if this ADFNXOption is nonempty.
- (FNXOption *)flatMap:(FNXOption *(^)(id obj))fn
{
    return self.nonEmpty ? fn(self.get) : [FNXNone none];
}

// Applies a binary operator to a start value and all elements of this collection, going left to right.
// op(...op(startValue, x_1), x_2, ..., x_n)
- (id)foldLeftWithStartValue:(id)startValue op:(id (^)(id accumulator, id obj))op
{
    return self.isEmpty ? startValue : op(startValue, self.get);
}

// Applies a binary operator to all elements of this iterable collection and a start value, going right to left.
// op(x_1, op(x_2, ... op(x_n, z)...))
- (id)foldRightWithStartValue:(id)startValue op:(id (^)(id obj, id accumulator))op
{
    return self.isEmpty ? startValue : op(self.get, startValue);
}

// Returns YES if this option is empty or the predicate pred returns YES when applied
// to this ADFNXOption's value.
- (BOOL)forall:(BOOL (^)(id obj))pred
{
    return self.isEmpty ? YES : pred(self.get);
}

// Apply the given procedure fn to the option's value, if it is nonempty.
- (void)foreach:(void (^)(id obj))fn
{
    if (self.nonEmpty) {
        fn(self.get);
    }
}

// Returns the option's value.
// Abstract
- (id)get
{
    NSAssert(NO, @"Abstract method called");
    return nil;
}

// Returns the option's value if the option is nonempty, otherwise return the result of evaluating defaultValue.
- (id)getOrElse:(id)defaultValue
{
    return self.nonEmpty ? self.get : defaultValue;
}

// Selects the first element of this collection.
// Abstract
- (id)head
{
    NSAssert(NO, @"Abstract method called");
    return nil;
}

// Optionally selects the first element of this collection.
- (FNXOption *)headOption
{
    return self;
}

// Selects the last element.
// Abstract
- (id)last
{
    NSAssert(NO, @"Abstract method called");
    return nil;
}

// Optionally selects the last element.
- (FNXOption *)lastOption
{
    return self;
}

// Selects all elements except the last.
// Abstract
- (id<FNXTraversable>)initial
{
    NSAssert(NO, @"Abstract method called");
    return nil;
}

// Returns YES if the option is an instance of ADFNXSome, NO otherwise.
// Abstract
- (BOOL)isDefined
{
    NSAssert(NO, @"Abstract method called");
    return NO;
}

// Returns YES if the option is ADFNXNone, NO otherwise.
// Abstract
- (BOOL)isEmpty
{
    NSAssert(NO, @"Abstract method called");
    return NO;
}

// Returns a ADFNXSome containing the result of applying fn to this option's value if this option is nonempty.
- (FNXOption *)map:(id (^)(id obj))fn
{
    return self.nonEmpty ? [FNXSome someWithValue:fn(self.get)] : [FNXNone none];
}

// Returns NO if the option is ADNFXNone, YES otherwise.
// Abstract
- (BOOL)nonEmpty
{
    NSAssert(NO, @"Abstract method called");
    return NO;
}

// Returns this ADFNXOption if it is nonempty, otherwise return the result of evaluating alternative.
- (FNXOption *)orElse:(FNXOption *(^)(void))alternative
{
    return self.nonEmpty ? self : alternative();
}

// Selects all elements except the first.
// Abstract
- (id<FNXTraversable>)tail
{
    NSAssert(NO, @"Abstract method called");
    return nil;
}

@end


@implementation FNXOption (ADFNXTraversable)

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)fnx_count:(BOOL (^)(id obj))pred
{
    return [self count:pred];
}

// Selects all elements except first n ones.
- (id<FNXTraversable>)fnx_drop:(NSUInteger)n
{
    return [self drop:n];
}

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)fnx_exists:(BOOL (^)(id obj))pred
{
    return [self exists:pred];
}

// Selects all elements of this collection which satisfy a predicate.
- (id<FNXTraversable>)fnx_filter:(BOOL (^)(id obj))pred
{
    return [self filter:pred];
}

// Selects all elements of this collection which do not satisfy a predicate.
- (id<FNXTraversable>)fnx_filterNot:(BOOL (^)(id obj))pred
{
    return [self filterNot:pred];
}

// Finds the first element of the collection satisfying a predicate, if any.
- (FNXOption *)fnx_find:(BOOL (^)(id obj))pred
{
    return [self find:pred];
}

// Applies a binary operator to a start value and all elements of this collection, going left to right.
// op(...op(startValue, x_1), x_2, ..., x_n)
- (id)fnx_foldLeftWithStartValue:(id)startValue op:(id (^)(id accumulator, id obj))op
{
    return [self foldLeftWithStartValue:startValue op:op];
}

// Applies a binary operator to all elements of this iterable collection and a start value, going right to left.
// op(x_1, op(x_2, ... op(x_n, z)...))
- (id)fnx_foldRightWithStartValue:(id)startValue op:(id (^)(id obj, id accumulator))op
{
    return [self foldRightWithStartValue:startValue op:op];
}

// Tests whether a predicate holds for all elements of this collection.
- (BOOL)fnx_forall:(BOOL (^)(id obj))pred
{
    return [self forall:pred];
}

// Apply the given procedure fn to every element in the collection.
- (void)fnx_foreach:(void (^)(id obj))fn
{
    [self foreach:fn];
}

// Selects the first element of this collection.
- (id)fnx_head
{
    return [self head];
}

// Optionally selects the first element of this collection.
- (FNXOption *)fnx_headOption
{
    return [self headOption];
}

// Selects the last element.
- (id)fnx_last
{
    return [self last];
}

// Optionally selects the last element.
- (FNXOption *)fnx_lastOption
{
    return [self lastOption];
}

// Selects all elements except the last.
- (id<FNXTraversable>)fnx_init
{
    return [self initial];
}

// Tests whether this collection is empty.
- (BOOL)fnx_isEmpty
{
    return self.isEmpty;
}

// Builds a new collection by applying a function to all elements of this collection.
- (id)fnx_map:(id (^)(id obj))fn
{
    return [self map:fn];
}

// Tests whether the collection is not empty.
- (BOOL)fnx_nonEmpty
{
    return self.nonEmpty;
}

// The size of this collection.
- (NSUInteger)fnx_size
{
    return self.nonEmpty ? 1 : 0;
}

// Selects all elements except the first.
- (id<FNXTraversable>)fnx_tail
{
    return [self tail];
}

@end
