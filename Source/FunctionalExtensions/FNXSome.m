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


@interface FNXSome ()

@property (nonatomic, strong) id value;

@end


@implementation FNXSome

- (instancetype)initWithValue:(id)value
{
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

// Returns the option's value.
// Abstract
- (id)get
{
    return _value;
}

// Selects all elements except the last.
// Abstract
- (id<FNXTraversable>)initial
{
    return [NSArray array];
}

// Selects the first element of this collection.
- (id)head
{
    return self.get;
}

// Returns YES if the option is an instance of ADFNXSome, NO otherwise.
// Abstract
- (BOOL)isDefined
{
    return YES;
}

// Returns YES if the option is ADFNXNone, NO otherwise.
// Abstract
- (BOOL)isEmpty
{
    return NO;
}

// Selects the last element.
- (id)last
{
    return self.get;
}

// Returns NO if the option is ADNFXNone, YES otherwise.
// Abstract
- (BOOL)nonEmpty
{
    return YES;
}

// Selects all elements except the first.
// Abstract
- (id<FNXTraversable>)tail
{
    return [NSArray array];
}

@end
