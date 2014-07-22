//
//  BLCAwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Jeanne on 7/21/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

#import "BLCAwesomeFloatingToolbar.h"

@interface BLCAwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
/*
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;
*/
@property (nonatomic, weak) UIButton *currentButton;

//@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation BLCAwesomeFloatingToolbar

- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        /*
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 labels
        for (NSString *currentTitle in self.currentTitles) {
            UILabel *label = [[UILabel alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
        }
        
        self.labels = labelsArray;
        
        for (UILabel *thisLabel in self.labels) {
            [self addSubview:thisLabel];
        }
        */
        
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 buttons
        for (NSString *currentTitle in self.currentTitles) {
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled = NO;
            button.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            [button.titleLabel setTextAlignment: NSTextAlignmentCenter];
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            [button setTitle:titleForThisLabel forState:UIControlStateNormal];
            button.backgroundColor = colorForThisLabel;
            [button setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            
            [buttonsArray addObject:button];
        }
        
        self.buttons = buttonsArray;
        
        for (UIButton *thisButton in self.buttons) {
            [self addSubview:thisButton];
        }
        
        /*
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        [self addGestureRecognizer:self.tapGesture];
         */
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    return self;
}

- (void) layoutSubviews {
    NSLog(@"layoutSubviews");
    // set the frames for the 4 labels
    
    //for (UILabel *thisLabel in self.labels) {
        //NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
    for (UIButton *thisLabel in self.buttons) {
        NSUInteger currentLabelIndex = [self.buttons indexOfObject:thisLabel];
            
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        // adjust labelX and labelY for each label
        if (currentLabelIndex < 2) {
            // 0 or 1, so on top
            labelY = 0;
        } else {
            // 2 or 3, so on bottom
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            labelX = 0;
        } else {
            // 1 or 3, so on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}

#pragma mark - Touch Handling
/*
- (UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    return (UILabel *)subview;
}

- (void) tapFired:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [recognizer locationInView:self];
        UIView *tappedView = [self hitTest:location withEvent:nil];
        
        if ([self.labels containsObject:tappedView]) {
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
            }
        }
    }
}
*/

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Pinch fired - changed - Scale @%.1f", recognizer.scale);
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToScaleWithPercent:)]) {
            [self.delegate floatingToolbar:self didTryToScaleWithPercent:recognizer.scale];
        }
        //[recognizer setScale:1.0];
    }
    /*
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Pinch fired 3 - Scale @%.1f", recognizer.scale);
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToScaleWithPercent:)]) {
            [self.delegate floatingToolbar:self didTryToScaleWithPercent:recognizer.scale];
        }
        [recognizer setScale:1.0];
    }
    */
}

- (void) longPressFired:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        /*
        UIColor *tempColor = ((UILabel *)self.labels[0]).backgroundColor;
        
        for (int i = 0; i < self.labels.count; i++) {
            UILabel *label = ((UILabel *)self.labels[i]);
            int next = i + 1;
            if(next < self.labels.count)
            {
                label.backgroundColor = ((UILabel *)self.labels[next]).backgroundColor;
            }
            else
            {
                label.backgroundColor = tempColor;
            }
        }
        */
        UIColor *tempColor = ((UIButton *)self.buttons[0]).backgroundColor;
        
        for (int i = 0; i < self.buttons.count; i++) {
            UIButton *button = ((UIButton *)self.buttons[i]);
            int next = i + 1;
            if(next < self.buttons.count)
            {
                button.backgroundColor = ((UIButton *)self.buttons[next]).backgroundColor;
            }
            else
            {
                button.backgroundColor = tempColor;
            }
        }
    }
}

#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        /*
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
        */
        UIButton *button = [self.buttons objectAtIndex:index];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
    }
}

@end
