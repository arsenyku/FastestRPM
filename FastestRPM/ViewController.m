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
@property (weak, nonatomic) IBOutlet UIButton *calibrationButton;
@end

@implementation ViewController

static float const AngleForMinPosition = 222.0f;  // degrees
static float const AngleForMaxPosition = 43.0;    // degrees


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    BOOL calibrationMode = NO;
	self.calibrationButton.hidden = !calibrationMode ;
    self.calibrationButton.alpha = calibrationMode ? 1.0 : 0.0;

    self.pointerImageView.alpha = 1.0;

    self.pointerContainerView = [[UIView alloc] initWithFrame:self.dialImageView.frame];
    
    self.pointerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pointerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dialImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.pointerContainerView addSubview:self.pointerImageView];
    
    [self.view addSubview:self.pointerContainerView];
    
    [self.view addConstraints:[self createDialConstraints] ];
    [self.view addConstraints:[self createPointerConstraints] ];

    [self resetMeter:nil];

}


- (IBAction)panGesture:(id)sender{
    
    UIPanGestureRecognizer *panGestureRecognizer = sender;

    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateChanged:
            [self panningMotionDetected:panGestureRecognizer];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self panningMotionEnded:panGestureRecognizer];
            break;
            
        default:
            break;
    }
}

-(void)panningMotionDetected:(UIPanGestureRecognizer*)panGestureRecognizer{
    CGPoint velocityVector = [panGestureRecognizer velocityInView:self.view];
    float velocity = sqrt( pow( velocityVector.x, 2 ) + pow( velocityVector.y, 2 ) );
    float angle = [self angleFromVelocity:velocity];

    self.currentAngle = angle;
    [self rotateView:self.pointerContainerView byDegrees:self.currentAngle];
    
}

-(void)panningMotionEnded:(UIPanGestureRecognizer*)panGestureRecognizer{
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(resetMeter:)
                                   userInfo:nil
                                    repeats:NO];
};

-(void)resetMeter:(id)sender{

    self.currentAngle = 360 - AngleForMinPosition;

    if (sender == nil){
        [self rotateView:self.pointerContainerView byDegrees:self.currentAngle];
        
    } else {
        [self animateRotationForView:self.pointerContainerView
                           byDegrees:self.currentAngle
                       animationTime:0.5];
    }
}

-(float)angleFromVelocity:(float)velocity{
    float const minVelocity = 0;
    float const maxVelocity = 5000;
    
    
    float velocityRange = maxVelocity - minVelocity;
    float angleRange = fabs(AngleForMaxPosition - AngleForMinPosition);
    
    float angle = (velocity / velocityRange) * angleRange;
    return angle - AngleForMinPosition;
    
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
   
    [result addObject:[NSLayoutConstraint constraintWithItem:self.dialImageView
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.view
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:0.0]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.dialImageView
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.view
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.0
                                                    constant:0.0]];
    
    return result;

}

-(NSArray*)createPointerConstraints{
	NSMutableArray* result = [NSMutableArray new];

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
                                                    constant:8.0]];
    
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
    

    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerImageView
                                                   attribute:NSLayoutAttributeRight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeRight
                                                  multiplier:1.0
                                                    constant:0]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerImageView
                                                   attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:-25.0]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerImageView
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.pointerContainerView
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.0
                                                    constant:0.0]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.pointerImageView
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1.0
                                                    constant:50.0]];
    
    return [result copy];
}


- (IBAction)addTenDegrees:(id)sender {
    self.currentAngle += 10;
    [self rotateView:self.pointerContainerView byDegrees:self.currentAngle];
    NSLog(@"angle: %f", self.currentAngle);
}


-(void)rotateView:(UIView*)view byDegrees:(float)angle{
    float radians = [self radiansFromDegrees:self.currentAngle];
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians);
    view.transform = transform;

}

-(void)animateRotationForView:(UIView*)view byDegrees:(float)angle animationTime:(float)animationTime{
    [UIView animateWithDuration:animationTime animations:^{
        [self rotateView:view byDegrees:angle];
    }];

}


-(float)radiansFromDegrees:(float)degrees{
    return ((degrees) * (M_PI / 180.0));
    
}

@end
