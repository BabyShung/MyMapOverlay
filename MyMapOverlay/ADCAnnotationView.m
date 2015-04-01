//
//  ADCAnnotationView.m
//  MyMapOverlay
//
//  Created by Hao Zheng on 4/1/15.
//  Copyright (c) 2015 Alarm.com. All rights reserved.
//

#import "ADCAnnotationView.h"

@implementation ADCAnnotationView

//- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated
//{
//    if (newDragState == MKAnnotationViewDragStateStarting)
//    {
//        // lift the pin and set the state to dragging
//        
//        CGPoint endPoint = CGPointMake(self.center.x,self.center.y-20);
//        [UIView animateWithDuration:0.2
//                         animations:^{ self.center = endPoint; }
//                         completion:^(BOOL finished)
//         { self.dragState = MKAnnotationViewDragStateDragging; }];
//    }
//    else if (newDragState == MKAnnotationViewDragStateEnding)
//    {
//        // save the new location, drop the pin, and set state to none
//        
//        /* my app specific code to save the new position
//         objectObservations[ACTIVE].latitude = pinAnnotation.coordinate.latitude;
//         objectObservations[ACTIVE].longitude = pinAnnotation.coordinate.longitude;
//         posChanged = TRUE;
//         */
//        
//        CGPoint endPoint = CGPointMake(self.center.x,self.center.y+20);
//        [UIView animateWithDuration:0.2
//                         animations:^{ self.center = endPoint; }
//                         completion:^(BOOL finished)
//         { self.dragState = MKAnnotationViewDragStateNone; }];
//    }
//    else if (newDragState == MKAnnotationViewDragStateCanceling)
//    {
//        // drop the pin and set the state to none
//        
//        CGPoint endPoint = CGPointMake(self.center.x,self.center.y+20);
//        [UIView animateWithDuration:0.2
//                         animations:^{ self.center = endPoint; }
//                         completion:^(BOOL finished)
//         { self.dragState = MKAnnotationViewDragStateNone; }];
//    }
//}

@end
