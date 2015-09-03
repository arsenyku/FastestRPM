//
//  ViewController.m
//  FastestRPM
//
//  Created by asu on 2015-09-03.
//  Copyright (c) 2015 asu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *pointerContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *pointerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *dialImageView;
@property (assign, nonatomic) float currentAngle;
@end

@implementation ViewController

static float const MinAngle = 230.0f;  // -130 deg


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    self.pointerImageView.alpha = 1.0;
    self.pointerImageView.translatesAutoresizingMaskIntoConstraints = NO;

    self.pointerContainerView = [[UIView alloc] initWithFrame:self.dialImageView.frame];
    self.pointerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.pointerContainerView addSubview:self.pointerImageView];
    
    [self.view addSubview:self.pointerContainerView];
    
    [self.view addConstraints:[self createDialConstraints] ];
    [self.view addConstraints:[self createPointerConstraints] ];
    
    [self resetMeter];
}


- (IBAction)panGesture:(id)sender{
    
    UIPanGestureRecognizer *panGestureRecognizer = sender;

    NSLog(@"Pan event: State=%ld", (long)panGestureRecognizer.state);
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateChanged:
            [self panningMotionDetected:panGestureRecognizer];
            break;
            
//        case UIGestureRecognizerStateEnded:
//            [self panningMotionEnded:panGestureRecognizer];
//            break;
            
        default:
            [self panningMotionEnded:panGestureRecognizer];
            break;
    }
}

-(void)panningMotionDetected:(UIPanGestureRecognizer*)panGestureRecognizer{
    CGPoint velocityVector = [panGestureRecognizer velocityInView:self.view];
    float velocity = sqrt( pow( velocityVector.x, 2 ) + pow( velocityVector.y, 2 ) );
    float angle = [self angleFromVelocity:velocity];
    
    //NSLog(@"pan detected: velocity = %f, angle = %f", velocity, angle);
    
    self.currentAngle = angle;
    [self rotateView:self.pointerContainerView byDegrees:self.currentAngle];
    
}

-(void)panningMotionEnded:(UIPanGestureRecognizer*)panGestureRecognizer{
    
    NSLog(@"pan ended");

    
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(resetMeter)
                                   userInfo:nil
                                    repeats:NO];
};

-(void)resetMeter{
    NSLog(@"resetMeter");

    self.currentAngle = 130.0f;
    [self rotateView:self.pointerContainerView byDegrees:self.currentAngle];
}


-(float)angleFromVelocity:(float)velocity{
    float const minVelocity = 0;
    float const maxVelocity = 5000;
    
    float const maxAngle = -40;  // 320 deg
    
    float velocityRange = maxVelocity - minVelocity;
    float angleRange = fabs(maxAngle - MinAngle);
    
    float angle = (velocity / velocityRange) * angleRange;
    return angle - MinAngle;
    
}

#pragma mark - constraints

-(NSArray*)createDialConstraints{
    NSMutableArray* result = [NSMutableArray new];
    
    float sideLength = MIN(self.view.frame.size.height, self.view.frame.size.width) - 10;
    
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.dialImageView
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1.0
                                                    constant:sideLength]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.dialImageView
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1.0
                                                    constant:sideLength]];
    
    return result;

}

-(NSArray*)createPointerConstraints{
	NSMutableArray* result = [NSMutableArray new];

    float horizontalOffset = -25;
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerImageView
                                                   attribute:NSLayoutAttributeRight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeRight
                                                  multiplier:1.0
                                                    constant:horizontalOffset]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerImageView
                                                   attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:horizontalOffset]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerImageView
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.0
                                                    constant:+8]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerImageView
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1.0
                                                    constant:50.0]];
    

    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.dialImageView
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:0.0]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.dialImageView
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.0
                                                    constant:0.0]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.dialImageView
                                                   attribute:NSLayoutAttributeHeight
                                                  multiplier:1.0
                                                    constant:0.0]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.dialImageView
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]];
    
    
    return [result copy];
}

-(void)matchView:(UIView*)view dimensionsAndPositionWithSourceView:(UIView*)sourceView{
    view.frame = CGRectMake(sourceView.frame.origin.x, sourceView.frame.origin.y,
                            sourceView.frame.size.width, sourceView.frame.size.height);
};

- (IBAction)addTenDegrees:(id)sender {
    self.currentAngle += 10.0;
//    self.pointerImageView.image = [self imageFromImage:self.pointerImageView.image
//                                      rotatedByDegrees:self.currentAngle];
    [self rotateView:self.pointerContainerView byDegrees:self.currentAngle];
}


-(void)rotateView:(UIView*)view byDegrees:(float)angle{
    float radians = [self radiansFromDegrees:self.currentAngle];
    //NSLog(@"%f rad == %f deg", radians, self.currentAngle);
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians);
    view.transform = transform;
}


-(float)radiansFromDegrees:(float)degrees{
    return ((degrees) * (M_PI / 180.0));
    
}


-(UIImage*)image:(UIImage*)original drawnIntoRect:(CGRect)rectangle xOffset:(float)xOffset yOffset:(float)yOffset{

    
    UIGraphicsBeginImageContext(rectangle.size);
    
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGRect targetRectangle = CGRectMake(xOffset, yOffset, original.size.width, original.size.height);
    
    //CGContextRotateCTM (context, [self radiansFromDegrees:angle]);
    //CGContextTranslateCTM (context, -10, 0);
    //[original drawInRect:rectangle];
    CGContextDrawImage(bitmap, targetRectangle, [original CGImage]);
    
    // Retrieve the image and end the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
    
}


- (UIImage *)imageFromImage:(UIImage*)original rotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,original.size.width, original.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation([self radiansFromDegrees:degrees]);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    //[rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, [self radiansFromDegrees:degrees]);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-original.size.width / 2,
                                          -original.size.height / 2,
                                          original.size.width,
                                          original.size.height),
                       			[original CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}



-(UIImage*)rotateImage:(UIImage*)image
      byAngleInDegrees:(float)angle

{
    
    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0.0f);
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextRotateCTM (context, [self radiansFromDegrees:angle]);
    //CGContextTranslateCTM (context, -10, 0);
    
    
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)
            blendMode:kCGBlendModeScreen
                alpha:1.0f];
    
    // Retrieve the image and end the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


@end
