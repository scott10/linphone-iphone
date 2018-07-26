//
//  UIRecordingCell.m
//  linphone
//
//  Created by benjamin_verdier on 25/07/2018.
//

#import "UIRecordingCell.h"
#import "PhoneMainView.h"
#import "UILabel+Boldify.h"
#import "Utils.h"
#import "UILinphoneAudioPlayer.h"

@implementation UIRecordingCell

static UILinphoneAudioPlayer *player;

#pragma mark - Lifecycle Functions

- (id)initWithIdentifier:(NSString *)identifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier])) {
        NSArray *arrayOfViews =
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
        
        // resize cell to match .nib size. It is needed when resized the cell to
        // correctly adapt its height too
        UIRecordingCell *sub = [arrayOfViews objectAtIndex:0];
        [self setFrame:CGRectMake(0, 0, sub.frame.size.width, 40)];
        self = sub;
        self.recording = NULL;
    }
    return self;
}

- (void)dealloc {
    self.recording = NULL;
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Property Functions

- (void)setRecording:(NSString *)arecording {
    _recording = arecording;
    if(_recording) {
        //TODO: Parse file name to get name of contact and date
        NSArray *parsedRecording = [LinphoneUtils parseRecordingName:_recording];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm:ss"];
        _nameLabel.text = [[[parsedRecording objectAtIndex:0] stringByAppendingString:@" @ "] stringByAppendingString:[dateFormat stringFromDate:[parsedRecording objectAtIndex:1]]];
    }
}

#pragma mark -

- (NSString *)accessibilityLabel {
    return _nameLabel.text;
}

- (void)setEditing:(BOOL)editing {
    [self setEditing:editing animated:FALSE];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateFrame {
    CGRect frame = self.frame;
    if (!self.selected) {
        frame.size.height = 40;
    } else {
        frame.size.height = 150;
    }
    [self setFrame:frame];
}

- (void)setSelected:(BOOL)selected {
    if (!selected)
        return;
    if (!player)
        player = [UILinphoneAudioPlayer audioPlayerWithFilePath:[self recording]];
    else
        [player setFile:[self recording]];
    
    UILinphoneAudioPlayer *p = player;
    [p.view removeFromSuperview];
    [self addSubview:p.view];
    [self bringSubviewToFront:p.view];
    p.view.frame = _playerView.frame;
    p.view.bounds = _playerView.bounds;
}


@end
