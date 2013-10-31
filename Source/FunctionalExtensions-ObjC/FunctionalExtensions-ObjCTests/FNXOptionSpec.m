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

#import <Kiwi/Kiwi.h>
#import <FunctionalExtensions-ObjC/FunctionalExtensions.h>


SPEC_BEGIN(FNXOptionSpec)

describe(@"FNXOption", ^{
    
    context(@"FNXNone", ^{
        it(@"Should return 0 for the number of items that satisfy a predicate", ^{
            FNXNone *input = [FNXNone none];
            NSUInteger result = [input count:^BOOL(NSNumber *n) {
                return n.intValue < 5;
            }];
            [[theValue(result) should] equal:@(0)];
        });
        
    });

    context(@"FNXSome", ^{
        context(@"Should be able to count the number of elements that satisfy a predicate", ^{
            it(@"Where the predicate is satisfied", ^{
                FNXSome *input = [FNXSome someWithValue:@(10)];
                NSUInteger result = [input count:^BOOL(NSNumber *n) {
                    return n.intValue > 5;
                }];
                [[theValue(result) should] equal:@(1)];
            });
            
            it(@"Where the predicate isn't satisfied", ^{
                FNXSome *input = [FNXSome someWithValue:@(10)];
                NSUInteger result = [input count:^BOOL(NSNumber *n) {
                    return n.intValue < 5;
                }];
                [[theValue(result) should] equal:@(0)];
            });
        });
    });

    context(@"<FNXTraversable>", ^{
    });
    
});

SPEC_END
