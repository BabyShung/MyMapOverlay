
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CustomMapDelegate <NSObject>
-(void)onRadiusChange:(double)radius;
@end

@interface CustomMKCircleOverlay : MKCircleRenderer

@property(nonatomic, weak) id<CustomMapDelegate> delegate;
@property(nonatomic, readonly) MKMapRect circlebounds;
@property(nonatomic, readonly) int MINDIS;
@property(nonatomic, readonly) int MAXDIS;
@property(nonatomic) CGFloat alpha;
@property(nonatomic) CGFloat border;

-(id)initWithCircle:(MKCircle *) circle withRadius:(CGFloat)radius withMin:(int) min withMax:(int) max;
-(id)initWithCircle:(MKCircle *) circle withRadius:(CGFloat)radius;
-(void)setCircleRadius:(CGFloat)radius;
-(CGFloat)getCircleRadius;

@end


