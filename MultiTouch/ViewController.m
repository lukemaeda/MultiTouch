//
//  ViewController.m
//  MultiTouch
//
//  Created by MAEDA HAJIME on 2014/04/21.
//  Copyright (c) 2014年 HAJIME MAEDA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ivCanvas;
@property (weak, nonatomic) IBOutlet UILabel *lbTarget;

@property (weak, nonatomic) IBOutlet UITextView *teString;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 画面タッチ時
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
    
    // タッチ数のsyutoku
    NSLog(@"タッチ数：%ld",(long)touches.count);
    
    // タッチオブジェクトの取得
    NSArray *arr = [touches allObjects];
    
    for (UITouch *tch in arr) {
        // タッチ座標の取得
        CGPoint pnt = [tch locationInView:self.ivCanvas];
        
        // タッチ回数（タップ回数）の習得
        NSInteger cnt = [tch tapCount];
        
        // タッチの当たり判定
        CGRect rct = self.lbTarget.frame;
        BOOL ret = CGRectContainsPoint(rct, pnt);
        
        // タッチ情報表示
        NSLog(@"%@, %ld, %@", NSStringFromCGPoint(pnt), (long)cnt, ret ? @"当たり" : @"はずれ");
        
        self.teString.text = [self.teString.text stringByAppendingFormat:@"%@, %ld, %@\n", NSStringFromCGPoint(pnt), (long)cnt, ret ? @"当たり" : @"はずれ"];
        
//        self.view.backgroundColor =
//            ret ? [UIColor redColor] : [UIColor whiteColor];
        
        // タッチ地点への描画
        UIGraphicsBeginImageContext(self.ivCanvas.frame.size);
        [self.ivCanvas.image drawInRect:self.ivCanvas.frame];
        
        // 円描画
        {
            // グラフィックコンテキスト
            CGContextRef ct = UIGraphicsGetCurrentContext();
            
            // 設定（範囲）
            CGFloat rad = 15.0;  // 半径
            CGRect rct01 = CGRectMake(pnt.x - rad,
                                      pnt.y - rad,
                                      rad * 2.0,
                                      rad * 2.0);
            // 設定（色）
            CGContextSetRGBFillColor(ct, 1.0, 0.0, 0.0, 0.2);
            
            // 円描画
            CGContextFillEllipseInRect(ct, rct01);
            
        }
        
        // オフスクリーン内容を反映
        self.ivCanvas.image =
            UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

    }
    
}

// ファーストレスポンダ化可能の設定（シェイク検知に必要）
- (BOOL)canBecomeFirstResponder {
    
    return YES;
    
}

// シェイクモーション終了時にて点描画クリアー
- (void)motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event {
    
    // シェイクの判定
    if (event.type == UIEventTypeMotion &&
        motion == UIEventSubtypeMotionShake) {
        
        // 画像表示クリアー
        self.ivCanvas.image =nil;
    }
}
@end
