//
//  ViewController.m
//  MyMapOverlay
//
//  Created by Hao Zheng on 3/27/15.
//  Copyright (c) 2015 Alarm.com. All rights reserved.
//

#import "ViewController.h"
#import "WildcardGestureRecognizer.h"

/* Default Location */
#define ADC_LATITUDE 38.916440
#define ADC_LONGITUDE -77.226710
#define ZOOM_DISTANCE 500
#define DEFAULT_RADIUS 100

/* Default radius size in PX */
double const circleRadius = 0;

double oldoffset;
double setRadius = DEFAULT_RADIUS;

bool panEnabled = YES;

@interface ViewController ()
{
    CLLocationCoordinate2D droppedAt;
    
    MKMapPoint lastPoint;
    
    CustomMKCircleOverlay *circleView;
}

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    //init location
    droppedAt = CLLocationCoordinate2DMake(ADC_LATITUDE, ADC_LONGITUDE);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(droppedAt, ZOOM_DISTANCE, ZOOM_DISTANCE);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    /* Add Custom MKCircle with Annotation*/
    [self addCircle];
    
    [self addOverlayGesture];
}

- (void)addOverlayGesture
{
    /* Setup Touch listener for custom circle */
    WildcardGestureRecognizer * tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
        
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView:self.mapView];
        
        CLLocationCoordinate2D coord = [self.mapView convertPoint:p toCoordinateFromView:self.mapView];
        MKMapPoint mapPoint = MKMapPointForCoordinate(coord);
        
        MKMapRect mapRect = [circleView circlebounds];
        
        double xPath = mapPoint.x - (mapRect.origin.x - (mapRect.size.width/2));
        double yPath = mapPoint.y - (mapRect.origin.y - (mapRect.size.height/2));
        
        /* Test if the touch was within the bounds of the circle */
        if(xPath >= 0 && yPath >= 0 && xPath < mapRect.size.width && yPath < mapRect.size.height){
            NSLog(@"Disable Map Panning");
            
            /*
             This block is to ensure scrollEnabled = NO happens before the any move event.
             */
            __block int t = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                t = 1;
                self.mapView.scrollEnabled = NO;
                panEnabled = NO;
                oldoffset = [circleView getCircleRadius];
            });
            
        }else{
            self.mapView.scrollEnabled = YES;
        }
        lastPoint = mapPoint;
    };
    
    tapInterceptor.touchesMovedCallback = ^(NSSet * touches, UIEvent * event) {
        if(!panEnabled && [event allTouches].count == 1){
            UITouch *touch = [touches anyObject];
            CGPoint p = [touch locationInView:self.mapView];
            
            CLLocationCoordinate2D coord = [self.mapView convertPoint:p toCoordinateFromView:self.mapView];
            MKMapPoint mapPoint = MKMapPointForCoordinate(coord);
            
            MKMapRect mRect = self.mapView.visibleMapRect;
            MKMapRect circleRect = [circleView circlebounds];
            //NSLog(@"radius: %f", [circleView getCircleRadius]);
            
            /* Check if the map needs to zoom */
            if(circleRect.size.width > mRect.size.width * 0.9){
                MKCoordinateRegion region;
                //Set Zoom level using Span
                MKCoordinateSpan span;
                region.center=droppedAt;
                span.latitudeDelta=self.mapView.region.span.latitudeDelta * 2.2;
                span.longitudeDelta=self.mapView.region.span.longitudeDelta * 2.2;
                region.span=span;
                [_mapView setRegion:region animated:TRUE];
            }
            if(circleRect.size.width < mRect.size.width *.35){
                MKCoordinateRegion region;
                //Set Zoom level using Span
                MKCoordinateSpan span;
                region.center=droppedAt;
                span.latitudeDelta=_mapView.region.span.latitudeDelta /3.0002;
                span.longitudeDelta=_mapView.region.span.longitudeDelta /3.0002;
                region.span=span;
                [_mapView setRegion:region animated:TRUE];
            }
            
            
            double meterDistance = (mapPoint.y - lastPoint.y) / MKMapPointsPerMeterAtLatitude(self.mapView.centerCoordinate.latitude)+oldoffset;
            if(meterDistance > 0){
                [circleView setCircleRadius:meterDistance];
            }
            setRadius = circleView.getCircleRadius;
            
            NSString *distance;
            if(setRadius > 1000){
                distance = [NSString stringWithFormat:@"%.02f km", setRadius / 1000];
            }else{
                distance = [NSString stringWithFormat:@"%.f m", setRadius];
            }
            [self.distanceLabel setText:distance];
            
        }
    };
    
    tapInterceptor.touchesEndedCallback = ^(NSSet * touches, UIEvent * event) {
        panEnabled = YES;
        //NSLog(@"Enable Map Panning");
        
        self.mapView.zoomEnabled = YES;
        self.mapView.scrollEnabled = YES;
        self.mapView.userInteractionEnabled = YES;
    };
    
    [self.mapView addGestureRecognizer:tapInterceptor];
}

- (void)addCircle
{
    if(circle != nil)
        [self.mapView removeOverlay:circle];
    circle = [MKCircle circleWithCenterCoordinate:droppedAt radius:circleRadius];
    
    //will then call the delegate method
    [self.mapView addOverlay: circle];
    
    [circleView setCircleRadius:setRadius];
    
    if(point == nil){
        point = [[MKPointAnnotation alloc] init];
        
        point.coordinate = droppedAt;
        [self.mapView addAnnotation:point];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapView delegate

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if(newState == MKAnnotationViewDragStateStarting){
        panEnabled = YES;
    }
    if (newState == MKAnnotationViewDragStateEnding) {
        droppedAt = annotationView.annotation.coordinate;
        //NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        [self addCircle];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    [annotationView setDraggable:YES];
    annotationView.pinColor = MKPinAnnotationColorPurple;
    
    [annotationView setSelected:YES animated:YES];
    return [annotationView init];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    circleView = [[CustomMKCircleOverlay alloc] initWithCircle:overlay];
    circleView.fillColor = [UIColor greenColor];
    circleView.delegate = self;
    
    return circleView;
}

#pragma mark - CustomMKCircleOverlay delegate

- (void)onRadiusChange:(CGFloat)radius
{
    NSLog(@"on radius change: %f", radius);
}

@end
