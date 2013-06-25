//
//  GameScene.h
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/05.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InterfaceLayer.h"
#import "Player.h"

@interface GameScene : CCScene {
    CCLayer *baseLayer; //ベースとなるレイヤー 背景以外のオブジェクトを配置するレイヤー
    Player *player1;
    Player *player2;
    CCLayer *playerLayer; //playerを配置するレイヤー
    CCLayer *beamLayer;  //弾を配置するレイヤー
    CCLayer *enemyLayer;  //弾を配置するレイヤー
    InterfaceLayer *interfaceLayer; //インターフェースレイヤー
}

//ここのプロパティで宣言することが大事(ここに書くことでプロパティがあることが見える)
@property (nonatomic, retain)CCLayer *baseLayer;
@property (nonatomic, retain)CCLayer *beamLayer;
@property (nonatomic, retain)CCLayer *playerLayer;
@property (nonatomic, retain)CCLayer *enemyLayer;
@property (nonatomic, retain)Player *player1;
@property (nonatomic, retain)Player *player2;
@property (nonatomic, retain)InterfaceLayer *interfaceLayer;
@property (nonatomic, retain)CCLabelTTF *player1_life;
@property (nonatomic, retain)CCLabelTTF *player2_life;

-(void)startGame;
-(void)stopGame;
-(void)gameover;
-(void)ChangeScore:(int)player_num;
    
//シングルトンオブジェクトを返すメソッド
+(GameScene *)sharedInstance;
@end
