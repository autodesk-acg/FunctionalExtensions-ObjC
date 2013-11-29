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
@interface NSArray (FNXFunctionalExtensions)

// Builds a new array from this collection without any duplicate elements.
- (NSArray *)fnx_distinct;

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
//
//// Builds a new collection by applying a function to all elements of this array in _parallel_.
//// If fn could return nil, it must return [FNXNone none] instead and the other values
//// should be mapped as FNXSome values.
//- (NSArray *)fnx_mapParallel:(id (^)(id obj))fn;

// Returns a new collection with the elements of this collection in reversed order.
- (NSArray *)fnx_reverse;

@end


@interface NSArray (FNXIterable) <FNXIterable>
@end
