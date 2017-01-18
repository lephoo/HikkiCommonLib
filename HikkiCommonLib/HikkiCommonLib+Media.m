//
//  HikkiCommonLib+Media.m
//  HikkiCommonLib
//
//  Created by liupingpin on 2017/1/18.
//  Copyright © 2017年 Hikki. All rights reserved.
//

#import "HikkiCommonLib+Media.h"

@implementation HikkiCommonLib (Media)
/**
 path: no extension
 #import <AVFoundation/AVPlayerItem.h>
 #import <AVFoundation/AVPlayer.h>
 #import <AVKit/AVPlayerViewController.h>
 #import <MediaPlayer/MPVolumeView.h>
 **/
-(void)PlayVideo:(UIViewController*)uvc path:(NSString*)path ext:(NSString*)ext{
    
    //silent mode
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    
    NSURL* videoURL = [[NSBundle mainBundle]URLForResource:path withExtension:ext];
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    AVPlayer* player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    AVPlayerViewController* avc = [[AVPlayerViewController alloc]init];
    avc.player = player;
    avc.view.frame = uvc.view.frame;
    
    //sound off
    [player setVolume:0.0];
    //
    [[uvc view]addSubview:avc.view];
    [player play];
    //system sound
    MPVolumeView* vv = [[MPVolumeView alloc]init];
}
@end
