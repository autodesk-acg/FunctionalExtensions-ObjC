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

#import "FNXSome.h"
#import "NSArray+FNXFunctionalExtensions.h"
#import "FNXNone.h"


@interface FNXSome ()

@property (nonatomic, strong) id value;

@end


@implementation FNXSome

#pragma mark - NSObject

- (NSUInteger)hash
{
    return [_value hash];
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (nil == object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToSome:object];
}

- (BOOL)isEqualToSome:(FNXSome *)some
{
    if (some == self) {
        return YES;
    }
    return [some.value isEqual:_value];
}

#pragma mark - FNXTraversableOnce

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)fnx_count:(BOOL (^)(id obj))pred
{
    return pred(_value) ? 1 : 0;
}

// Tests whether a predicate holds for some of the elements of this traversable.
- (BOOL)fnx_exists:(BOOL (^)(id obj))pred
{
    return pred(_value);
}

// Selects all elements of this collection which satisfy a predicate.
- (id<FNXTraversable>)fnx_filter:(BOOL (^)(id obj))pred
{
    if (pred(_value)) {
        return self;
    } else {
        return [NSNull fnx_none];
    }
}

// Finds the first element of the collection satisfying a predicate, if any.
- (id<FNXOption>)fnx_find:(BOOL (^)(id obj))pred
{
    if (pred(_value)) {
        return self;
    } else {
        return [NSNull fnx_none];
    }
}

// Applies a binary operator to a start value and all elements of this collection, going left to right.
// op(...op(startValue, x_1), x_2, ..., x_n)
- (id)fnx_foldLeftWithStartValue:(id)startValue op:(id (^)(id accumulator, id obj))op
{
    return op(startValue, _value);
}

// Applies a binary operator to all elements of this iterable collection and a start value, going right to left.
// op(x_1, op(x_2, ... op(x_n, z)...))
- (id)fnx_foldRightWithStartValue:(id)startValue op:(id (^)(id obj, id accumulator))op
{
    return op(_value, startValue);
}

// Tests whether a predicate holds for all elements of this collection.
- (BOOL)fnx_forall:(BOOL (^)(id obj))pred
{
    return pred(_value);
}

// Apply the given procedure fn to every element in the collection.
- (void)fnx_foreach:(void (^)(id obj))fn
{
    fn(_value);
}

// Tests whether this collection is empty.
- (BOOL)fnx_isEmpty
{
    return NO;
}

// Builds a new collection by applying a function to all elements of this collection.
- (id<FNXTraversable>)fnx_map:(id (^)(id obj))fn
{
    return [FNXSome someWithValue:fn(_value)];
}

// The size of this collection.
- (NSUInteger)fnx_size
{
    return 1;
}

// Converts this traversable to an array.
- (NSArray *)fnx_toArray
{
    return @[_value];
}

#pragma mark - FNXTraversable

// Selects all elements except first n ones.
- (id<FNXTraversable>)fnx_drop:(NSUInteger)n
{
    if (0 >= n) {
        return @[_value];
    } else {
        return [NSArray array];
    }
}

// Selects all elements of this collection which do not satisfy a predicate.
- (id<FNXTraversable>)fnx_filterNot:(BOOL (^)(id obj))pred
{
    if (!pred(_value)) {
        return self;
    } else {
        return [NSNull fnx_none];
    }
}

// Selects the first element of this collection.
- (id)fnx_head
{
    return _value;
}

// Optionally selects the first element of this collection.
- (id<FNXOption>)fnx_headOption
{
    return self;
}

// Selects the last element.
- (id)fnx_last
{
    return _value;
}

// Optionally selects the last element.
- (id<FNXOption>)fnx_lastOption
{
    return self;
}

// Selects all elements except the last.
- (id<FNXTraversable>)fnx_init
{
    return [NSArray array];
}

// Tests whether the collection is not empty.
- (BOOL)fnx_nonEmpty
{
    return YES;
}

// Selects all elements except the first.
- (id<FNXTraversable>)fnx_tail
{
    return [NSArray array];
}

#pragma mark - FNXOption

// Returns the option's value.
// Abstract
- (id)fnx_get
{
    return _value;
}

// Returns the option's value if the option is nonempty, otherwise return the result of evaluating defaultValue.
- (id)fnx_getOrElse:(id)defaultValue
{
    return _value;
}

// Returns YES if the option is an instance of ADFNXSome, NO otherwise.
// Abstract
- (BOOL)fnx_isDefined
{
    return YES;
}

// Returns this ADFNXOption if it is nonempty, otherwise return the result of evaluating alternative.
- (id<FNXOption>)fnx_orElse:(id<FNXOption>(^)(void))alternative
{
    return self;
}

#pragma mark - FNXSome

- (instancetype)initWithValue:(id)value
{
    // Use [NSNull fnx_none] instead of FNXSome if you really want nil.
    NSParameterAssert(nil != value);
    
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

+ (FNXSome *)someWithValue:(id)value
{
    return [[FNXSome alloc] initWithValue:value];
}

@end
