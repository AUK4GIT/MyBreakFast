//
//  HVDOverlay.m
//
//  Created by Harshad on 01/08/14.
//

#import "HVDOverlay.h"

typedef NS_ENUM(NSInteger, HVDOverlayType) {
    HVDOverlayTypeIcon,
    HVDOverlayTypeSpinner
};

@interface HVDOverlayView : UIView

@property (strong, nonatomic) UIImage *iconImage;
@property (nonatomic, readonly) HVDOverlayType type;


- (void)show;
- (void)dismiss;

@property (strong, nonatomic) UIColor *overlayColor;
@property (strong, nonatomic) UIColor *tintColor;

@end

@implementation HVDOverlayView {
    __weak UIImageView *_iconImageView;
    __weak UIActivityIndicatorView *_spinner;
}

- (instancetype)initWithType:(HVDOverlayType)type {
    self = [super init];
    if (self != nil) {
        _overlayColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
        _type = type;
        [self setBackgroundColor:[UIColor clearColor]];

        switch (_type) {
            case HVDOverlayTypeIcon: {
                UIImageView *iconImageView = [UIImageView new];
                [iconImageView setContentMode:UIViewContentModeCenter];
                [iconImageView setBackgroundColor:[UIColor clearColor]];
                [self addSubview:iconImageView];
                _iconImageView = iconImageView;

                NSDictionary *views = NSDictionaryOfVariableBindings(_iconImageView);
                [_iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_iconImageView]-|" options:0 metrics:nil views:views]];
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_iconImageView]-|" options:0 metrics:nil views:views]];
            }

                break;

            case HVDOverlayTypeSpinner: {
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                [spinner setHidesWhenStopped:YES];
                [spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
                [self addSubview:spinner];
                _spinner = spinner;

                [self addConstraint:[NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
                [self addConstraint:[NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
            }
                break;

            default:
                break;
        }
    }

    return self;
}

- (UIActivityIndicatorView *)spinner {
    return _spinner;
}

- (void)setOverlayColor:(UIColor *)overlayColor {
    _overlayColor = overlayColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [_spinner setColor:tintColor];
}

- (void)show {
    if (self.superview == nil) {
        [_spinner setColor:_tintColor];
        [_spinner startAnimating];

        UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [backgroundView setBackgroundColor:_overlayColor];
        [backgroundView addSubview:self];
        [self setFrame:backgroundView.bounds];

        [self setTransform:CGAffineTransformMakeScale(0.1f, 0.1f)];

        [[[UIApplication sharedApplication] keyWindow] addSubview:backgroundView];

        [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            [self setTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.superview setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [_spinner stopAnimating];
        [self.superview removeFromSuperview];
    }];
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    [_iconImageView setImage:iconImage];
}

@end

@implementation HVDOverlay {
    HVDOverlayView *_overlayView;
}

+ (instancetype)overlayWithImage:(UIImage *)image {
    HVDOverlay *overlay = [[[self class] alloc] init];
    overlay->_overlayView = [[HVDOverlayView alloc] initWithType:HVDOverlayTypeIcon];
    [overlay->_overlayView setIconImage:image];
    return overlay;
}

+ (instancetype)spinnerOverlay {
    HVDOverlay *overlay = [[[self class] alloc] init];
    HVDOverlayView *overlayView = [[HVDOverlayView alloc] initWithType:HVDOverlayTypeSpinner];
    overlay->_overlayView = overlayView;
    return overlay;
}

- (void)show {
    [_overlayView show];
}
- (void)dismiss {
    [_overlayView dismiss];
}

- (void)setOverlayColor:(UIColor *)overlayColor {
    [_overlayView setOverlayColor:overlayColor];
}

- (void)setTintColor:(UIColor *)tintColor {
    [_overlayView setTintColor:tintColor];
}

@end
