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


@protocol FNXOption <FNXTraversable>

// Returns the option's value.
// Abstract
- (id)fnx_get;

// Returns the option's value if the option is nonempty, otherwise return the result of evaluating defaultValue.
- (id)fnx_getOrElse:(id)defaultValue;

// Returns YES if the option is an instance of ADFNXSome, NO otherwise.
// Abstract
- (BOOL)fnx_isDefined;

// Returns YES if the option is ADFNXNone, NO otherwise.
// Abstract
- (BOOL)fnx_isEmpty;

// Returns NO if the option is ADNFXNone, YES otherwise.
// Abstract
- (BOOL)fnx_nonEmpty;

// Returns this ADFNXOption if it is nonempty, otherwise return the result of evaluating alternative.
- (id<FNXOption>)fnx_orElse:(id<FNXOption>(^)(void))alternative;

@end
