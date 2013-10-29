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

#import "ADFNXOption.h"
#import "ADFNXSome.h"
#import "ADFNXNone.h"


@implementation ADFNXOption

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)count:(BOOL (^)(id obj))pred
{
    if (self.isEmpty) {
        return 0;
    } else {
        return pred(self.get) ? 1 : 0;
    }
}

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)exists:(BOOL (^)(id obj))pred
{
    return self.nonEmpty && pred(self.get);
}

// Returns this ADFNXOption if it is nonempty and applying the predicate pred to
// this ADFNXOption's value returns YES. Otherwise, return ADFNXNone.
- (ADFNXOption *)filter:(BOOL (^)(id obj))pred
{
    return (self.nonEmpty && pred(self.get)) ? self : [ADFNXNone none];
}

// Returns this ADFNXOption if it is nonempty and applying the predicate pred
// to this option's value returns NO.
- (ADFNXOption *)filterNot:(BOOL (^)(id obj))pred
{
    return (self.nonEmpty && !pred(self.get)) ? self : [ADFNXNone none];
}

// Finds the first element of the collection satisfying a predicate, if any.
- (ADFNXOption *)find:(BOOL (^)(id obj))pred
{
    return (self.nonEmpty && pred(self.get)) ? self : [ADFNXNone none];
}

// Returns the result of applying fn to this ADFNXOption's value if this ADFNXOption is nonempty.
- (ADFNXOption *)flatMap:(ADFNXOption *(^)(id obj))fn
{
    return self.nonEmpty ? fn(self.get) : [ADFNXNone none];
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

// Selects all elements except the last.
// Abstract
- (id<ADFNXTraversable>)initial
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
- (ADFNXOption *)map:(id (^)(id obj))fn
{
    return self.nonEmpty ? [ADFNXSome someWithValue:fn(self.get)] : [ADFNXNone none];
}

// Returns NO if the option is ADNFXNone, YES otherwise.
// Abstract
- (BOOL)nonEmpty
{
    NSAssert(NO, @"Abstract method called");
    return NO;
}

// Returns this ADFNXOption if it is nonempty, otherwise return the result of evaluating alternative.
- (ADFNXOption *)orElse:(ADFNXOption *(^)(void))alternative
{
    return self.nonEmpty ? self : alternative();
}

// Selects all elements except the first.
// Abstract
- (id<ADFNXTraversable>)tail
{
    NSAssert(NO, @"Abstract method called");
    return nil;
}

@end


@implementation ADFNXOption (ADFNXTraversable)

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)fnx_count:(BOOL (^)(id obj))pred
{
    return [self count:pred];
}

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)fnx_exists:(BOOL (^)(id obj))pred
{
    return [self exists:pred];
}

// Selects all elements of this collection which satisfy a predicate.
- (id<ADFNXTraversable>)fnx_filter:(BOOL (^)(id obj))pred
{
    return [self filter:pred];
}

// Selects all elements of this collection which do not satisfy a predicate.
- (id<ADFNXTraversable>)fnx_filterNot:(BOOL (^)(id obj))pred
{
    return [self filterNot:pred];
}

// Finds the first element of the collection satisfying a predicate, if any.
- (ADFNXOption *)fnx_find:(BOOL (^)(id obj))pred
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

// Selects all elements except the last.
- (id<ADFNXTraversable>)fnx_init
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

// Selects all elements except the first.
- (id<ADFNXTraversable>)fnx_tail
{
    return [self tail];
}

@end
