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

#import "NSDictionary+FNXFunctionalExtensions.h"
#import "NSArray+FNXFunctionalExtensions.h"
#import "FNXTuple2.h"


@implementation NSDictionary (FNXFunctionalExtensions)

// Selects all elements except the last.
- (id<FNXTraversable>)fnx_init
{
    // This should throw an exception if the collection is empty.
    NSArray *keysSelected = [[self.allKeys fnx_init] fnx_toArray];
    return [self objectsForKeys:keysSelected notFoundMarker:[NSNull null]];
}

// Tests whether this collection is empty.
- (BOOL)fnx_isEmpty
{
    return 0 == self.count;
}

// Builds a new collection by applying a function to all elements of this collection.
- (id)fnx_map:(id (^)(id obj))fn // <FNXTraversableOnce>
{
    // If all elements are FNXTuple2 objects, then an NSDictionary will be returned.
    // Otherwise, an NSArray will be returned.
    BOOL allTuple2s = NO;
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        id mapped = fn(obj);
        allTuple2s = allTuple2s && [mapped isKindOfClass:[FNXTuple2 class]];
        [result addObject:mapped];
    }
    if (allTuple2s) {
        NSMutableDictionary *dictionaryResult = [NSMutableDictionary dictionaryWithCapacity:self.count];
        [result enumerateObjectsUsingBlock:^(FNXTuple2 *obj, NSUInteger idx, BOOL *stop) {
            dictionaryResult[obj._1] = obj._2;
        }];
        return [dictionaryResult copy];
    } else {
        return [result copy];
    }
}

@end


//@implementation NSDictionary (FNXIterable)
//@end
