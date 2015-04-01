

#import <MapKit/MapKit.h>

@interface YHAnimatedCircleView : MKCircleView
{    
    UIImageView* imageView;
}

-(void)start;
-(void)stop;

@end
