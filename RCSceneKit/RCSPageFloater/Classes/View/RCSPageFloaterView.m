//
//  RCSPageFloaterView.m
//  RCSceneKit
//
//  Created by 彭蕾 on 2022/7/27.
//

#import "RCSPageFloaterView.h"
#import <SDWebImage/SDWebImage.h>

@interface RCSPageFloaterView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) Pulsator *radarLayer;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *controlView;

@end

@implementation RCSPageFloaterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.cornerRadius = self.width * 0.5;

    self.avatarImageView.frame = CGRectMake(5, 5, self.width - 10, self.height - 10);
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.height * 0.5;
    self.radarLayer.position = self.avatarImageView.center;

    self.controlView.frame = self.bounds;
}

- (void)setUpSubViews {
    [self.layer addSublayer:self.gradientLayer];
    [self.layer addSublayer:self.radarLayer];

    [self addSubview:self.avatarImageView];

    [self addSubview:self.controlView];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.controlView addGestureRecognizer:pan];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self.controlView addGestureRecognizer:tap];
}

- (void)tapGesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickInFloater:)]) {
        [self.delegate didClickInFloater:self];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)pan {
    if (pan.state != UIGestureRecognizerStateChanged) {
        return;
    }

    CGPoint translationPoint = [pan translationInView:self];
    [pan setTranslation:CGPointZero inView:self];
    CGPoint position = CGPointMake(self.centerX + translationPoint.x, self.centerY + translationPoint.y);

    if (position.x + self.width / 2.0 > kScreen_WIDTH) {
        position.x = kScreen_WIDTH - self.width / 2.0;
    }
    if (position.x - self.width / 2.0 < 0) {
        position.x = self.width / 2.0;
    }

    if (position.y + self.height / 2.0 > kScreen_HEIGHT) {
        position.y = kScreen_HEIGHT - self.height / 2.0;
    }
    if (position.y - self.height / 2.0 < 0) {
        position.y = self.height / 2.0;
    }

    self.center = position;
}

#pragma mark - public method
- (void)updateAvatarWithImgUrl:(NSString *)imgUrl {
    if (imgUrl.length == 0) {
        return;
    }

    NSURL *url = [NSURL URLWithString:imgUrl];
    UIImage *placeholderImg = RCSFloaterImageNamed(@"room_background_image1");
    [self.avatarImageView sd_setImageWithURL:url placeholderImage:placeholderImg];
}

- (void)setCustomContentView:(UIView *)customContentView {
    if (_customContentView) {
        [_customContentView removeFromSuperview];
    }

    if (customContentView) {
        self.width = customContentView.width;
        self.height = customContentView.height;
        [self insertSubview:customContentView belowSubview:self.controlView];
        customContentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.size.mas_equalTo([UIScreen mainScreen].bounds.size);
        }];
        customContentView.backgroundColor = [UIColor colorWithRed:3 / 255.0 green:6 / 255.0 blue:47 / 255.0 alpha:1.0];
    }

    _customContentView = customContentView;
}

#pragma mark - lazy load

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer new];
        _gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:105 / 255.0 blue:253 / 255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:42 / 255.0 green:38 / 255.0 blue:242 / 255.0 alpha:1.0].CGColor
        ];
        _gradientLayer.startPoint = CGPointMake(0.25, 0.5);
        _gradientLayer.endPoint = CGPointMake(0.75, 0.5);
        _gradientLayer.borderWidth = 0.5;
        _gradientLayer.borderColor =
            [UIColor colorWithRed:225 / 255.0 green:222 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor;
        _gradientLayer.masksToBounds = YES;
        _gradientLayer.opacity = 0.3;
    }
    return _gradientLayer;
}

- (Pulsator *)radarLayer {
    if (!_radarLayer) {
        _radarLayer = [Pulsator new];
        _radarLayer.numPulse = 4;
        _radarLayer.radius = 60;
        _radarLayer.animationDuration = 1.5;
        _radarLayer.backgroundColor = [UIColor rcs_colorWithHex:0xFF69FD].CGColor;
        _radarLayer.repeatCount = 2;
    }
    return _radarLayer;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.image = RCSFloaterImageNamed(@"page_floater_icon");
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UIView *)controlView {
    if (!_controlView) {
        _controlView = [UIView new];
    }
    return _controlView;
}

@end
