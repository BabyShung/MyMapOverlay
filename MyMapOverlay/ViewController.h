//
//  ViewController.h
//  MyMapOverlay
//
//  Created by Hao Zheng on 3/27/15.
//  Copyright (c) 2015 Alarm.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomMapOverlay.h"

@interface ViewController : UIViewController<MKMapViewDelegate, CustomMapDelegate>
{
    MKCircle *circle;
    MKPointAnnotation *point;
}

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

