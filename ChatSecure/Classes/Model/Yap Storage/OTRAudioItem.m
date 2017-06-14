//
//  OTRAudioItem.m
//  ChatSecure
//
//  Created by David Chiles on 1/26/15.
//  Copyright (c) 2015 Chris Ballinger. All rights reserved.
//

#import "OTRAudioItem.h"
#import "OTRAudioControlsView.h"
@import JSQMessagesViewController;
#import "OTRPlayPauseProgressView.h"
@import AVFoundation;

@implementation OTRAudioItem

- (instancetype) initWithAudioURL:(NSURL*)url
                       isIncoming:(BOOL)isIncoming {
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url
                                                 options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @YES}];
    return [self initWithFilename:url.lastPathComponent timeLength:CMTimeGetSeconds(audioAsset.duration) mimeType:nil isIncoming:isIncoming];
}

- (instancetype) initWithFilename:(NSString *)filename timeLength:(NSTimeInterval)timeLength mimeType:(NSString *)mimeType isIncoming:(BOOL)isIncoming {
    if (self = [super initWithFilename:filename mimeType:mimeType isIncoming:isIncoming]) {
        _timeLength = timeLength;
    }
    return self;
}

+ (NSString *)collection
{
    return [OTRMediaItem collection];
}

- (CGSize)mediaViewDisplaySize
{
    return CGSizeMake(90, 38);
}

- (UIView *)mediaView
{
    UIView *errorView = [self errorView];
    if (errorView) { return errorView; }
    CGSize size = [self mediaViewDisplaySize];
    UIEdgeInsets bubbleInset = UIEdgeInsetsMake(5, 5, 5, 5);
    if (self.isIncoming) {
        bubbleInset.left = 9;
    } else {
        bubbleInset.right = 8;
    }
    
    CGRect viewRect = CGRectMake(0, 0, size.width, size.height);
    CGRect bubbleRect = UIEdgeInsetsInsetRect(viewRect, bubbleInset);
    
    OTRAudioControlsView *audioControls = [[OTRAudioControlsView alloc] initWithFrame:bubbleRect];
    [audioControls setTime:self.timeLength];
    
    
    UIView *view = [[UIView alloc] initWithFrame:viewRect];
    [view addSubview:audioControls];
    
    if (self.isIncoming) {
        view.backgroundColor = [UIColor jsq_messageBubbleLightGrayColor];
        audioControls.timeLabel.textColor = [UIColor blackColor];
        
        
        if (self.transferProgress < 1) {
            audioControls.playPuaseProgressView.userInteractionEnabled = NO;
            audioControls.playPuaseProgressView.color = [UIColor darkGrayColor];
        } else {
            audioControls.playPuaseProgressView.userInteractionEnabled = YES;
            audioControls.playPuaseProgressView.color = [UIColor blackColor];
        }
        
        
    }
    else {
        view.backgroundColor = [UIColor jsq_messageBubbleBlueColor];
        audioControls.timeLabel.textColor = [UIColor whiteColor];
        audioControls.playPuaseProgressView.color = [UIColor whiteColor];
    }
    
    [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:view isOutgoing:!self.isIncoming];
    
    return view;
}

@end
