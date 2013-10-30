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


@interface FNXOption : NSObject

// Counts the number of elements in the collection which satisfy a predicate.
- (NSUInteger)count:(BOOL (^)(id obj))pred;

// Returns this ADFNXOption if it is nonempty and applying the predicate pred to
// this ADFNXOption's value returns YES. Otherwise, return ADFNXNone.
- (FNXOption *)filter:(BOOL (^)(id obj))pred;

// Returns this ADFNXOption if it is nonempty and applying the predicate pred
// to this option's value returns NO.
- (FNXOption *)filterNot:(BOOL (^)(id obj))pred;

// Returns the result of applying fn to this ADFNXOption's value if this ADFNXOption is nonempty.
- (FNXOption *)flatMap:(FNXOption *(^)(id obj))fn;

// Returns YES if this option is empty or the predicate pred returns YES when applied
// to this ADFNXOption's value.
- (BOOL)forall:(BOOL (^)(id obj))pred;

// Apply the given procedure fn to the option's value, if it is nonempty.
- (void)foreach:(void (^)(id obj))fn;

// Returns the option's value.
// Abstract
- (id)get;

// Returns the option's value if the option is nonempty, otherwise return the result of evaluating defaultValue.
- (id)getOrElse:(id)defaultValue;

// Returns YES if the option is an instance of ADFNXSome, NO otherwise.
// Abstract
- (BOOL)isDefined;

// Returns YES if the option is ADFNXNone, NO otherwise.
// Abstract
- (BOOL)isEmpty;

// Returns a ADFNXSome containing the result of applying fn to this option's value if this option is nonempty.
- (FNXOption *)map:(id (^)(id obj))fn;

// Returns NO if the option is ADNFXNone, YES otherwise.
// Abstract
- (BOOL)nonEmpty;

// Returns this ADFNXOption if it is nonempty, otherwise return the result of evaluating alternative.
- (FNXOption *)orElse:(FNXOption *(^)(void))alternative;

@end


@interface FNXOption (FNXTraversable) <FNXTraversable>
@end
