//
//  GameConfig.h
//  KawazBuster
//
//  Created by giginet on 11/05/27.
//  Copyright Kawaz 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2
#define FPS 60 // FPS
#define SKIPTITLE NO // タイトル画面をスキップするか（デバッグ用）
#define SHOW_FPS NO // FPSを表示するか（デバッグ用）

/* Kawaz-tan tataki! Local Settings */
#define BOMB_RATE 0.2 // 爆弾の出現率
#define KAWAZTAN_SCORE 100 // かわずたんを叩いたときのスコア
#define BOMB_SCORE -500 // 爆弾を叩いたときのスコア
#define INITIAL_HIGHSCORE 2000 // 初期ハイスコア
#define HURRY_UP_TIME 20 // 残り何秒で急げ！モードになるか

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

#endif // __GAME_CONFIG_H

