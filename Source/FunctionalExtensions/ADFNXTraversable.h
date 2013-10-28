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


@protocol ADFNXTraversable <NSObject>

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)adfnx_count:(BOOL (^)(id obj))pred;

// Selects all elements of this collection which satisfy a predicate.
- (id<ADFNXTraversable>)adfnx_filter:(BOOL (^)(id obj))pred;

// Selects all elements of this collection which do not satisfy a predicate.
- (id<ADFNXTraversable>)adfnx_filterNot:(BOOL (^)(id obj))pred;

// Tests whether a predicate holds for all elements of this collection.
- (BOOL)adfnx_forall:(BOOL (^)(id obj))pred;

// Apply the given procedure fn to every element in the collection.
- (void)adfnx_foreach:(void (^)(id obj))fn;

// Tests whether this collection is empty.
- (BOOL)adfnx_isEmpty;

// Builds a new collection by applying a function to all elements of this collection.
- (id)adfnx_map:(id (^)(id obj))fn;

// Tests whether the collection is not empty.
- (BOOL)adfnx_nonEmpty;

@end
