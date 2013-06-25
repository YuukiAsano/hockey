//
//  GameScene.m
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/05.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "InterfaceLayer.h"
#import "GameoverLayer.h"
#import "Beam.h"
#import "Player.h"

@implementation GameScene

@synthesize player1;
@synthesize player2;
@synthesize interfaceLayer;
@synthesize playerLayer;
@synthesize beamLayer;
@synthesize baseLayer; //self.baselayerっていう使い方じゃなくてbaselayerって呼べる

//自分自身を保持しておく変数を静的に持っておきます.
static GameScene *scene_ = nil;

//初回呼ばれた時のみインスタンス生成 Sceneはシングルトン生成で 他のクラスからとか使うとき
//以降はいってるのをそのまま返す シングルトン生成 (複数のオブジェクト)
+(GameScene *)sharedInstance{
    if(scene_ == nil){
        scene_ = [GameScene node];
    }
    return scene_;
}

//scene描画された時に呼ばれる処理
-(id)init {
    self = [super init];
    if(self){
        //乱数の種初期化
        [self initRandom];
        
	    CGSize size = [[CCDirector sharedDirector] winSize];
        
        //背景を配置する処理
        CCLayer *background = [CCLayer node];
        CCSprite *image = [CCSprite spriteWithFile:@"background-4s.png"];
	    image.position = ccp(size.width/2, size.height/2);
        [background addChild:image z:0];
        [self addChild:background z:-1];
        
        //背景以外のオブジェクトを配置するレイヤー
        self.baseLayer = [CCLayer node];
        [self addChild:baseLayer z:0];
        
        //playerを配置するLayer
        self.playerLayer = [CCLayer node];
        [self.baseLayer addChild:self.playerLayer z:20];
        
        //弾を表示するレイヤーをbaseLayer上に配置
        self.beamLayer = [CCLayer node]; //selfにあるプロパティを使ってる
        [self.baseLayer addChild:self.beamLayer z:30];
        
        self.enemyLayer = [CCLayer node];
        [self.baseLayer addChild:self.enemyLayer z:40];
        
        //player1を配置
        self.player1 = [Player node];
        [self.baseLayer addChild:self.player1 z:10];
        
        //player2を配置
        self.player2 = [Player node];
        [self.baseLayer addChild:self.player2 z:10];
        
        //HPのラベルを配置
        NSString *player1_hp = [NSString stringWithFormat:@"%01d", self.player1.life];
        NSString *player2_hp = [NSString stringWithFormat:@"%01d", self.player2.life];
        
        self.player1_life = [CCLabelTTF labelWithString:player1_hp
                                             fontName:@"Helvetica"
                                             fontSize:22];
        self.player2_life = [CCLabelTTF labelWithString:player2_hp
                                             fontName:@"Helvetica"
                                             fontSize:22];
        self.player1_life.position = ccp(size.width/2-20, size.height - 20);
        self.player2_life.position = ccp(size.width/2+20, size.height - 20);
        [self.baseLayer addChild:self.player1_life z:50];
        [self.baseLayer addChild:self.player2_life z:50];
        
        //インターフェースを追加
        self.interfaceLayer = [InterfaceLayer node];
        [self.baseLayer addChild:self.interfaceLayer z:100];
        
        [self startGame];
        
    }
    return self;
}

-(void)dealloc{
    //保持していたメンバー変数を解放します
    self.baseLayer = nil;
    self.playerLayer = nil;
    self.beamLayer = nil;
    
    scene_ = nil;
    [super dealloc];
}

//乱数の種を現在時刻で初期化
-(void)initRandom{
    struct timeval t;
    gettimeofday(&t, nil);
    unsigned int i;
    i = t.tv_sec;
    i += t.tv_usec;
    srandom(i);
}

-(void)ChangeScore:(int)player_num{
    NSString *lifeString;
    if(player_num == 1){
      lifeString = [NSString stringWithFormat:@"%01d", player2.life];
      [self.player2_life setString:lifeString];
    }else if (player_num == 2) {
      lifeString = [NSString stringWithFormat:@"%01d", player1.life];
      [self.player1_life setString:lifeString];
    }
}

/*
 場面の状態をすべて表している
 start, stop, pause, resume, gameover
 */

//ゲームスタート
-(void)startGame {
    [self ChangeScore:1];
    [self ChangeScore:2];
    
	CGSize size = [[CCDirector sharedDirector] winSize];
    //自機の位置をリセットして動作開始
    self.player1.position = ccp(size.width/2, 73.84);
    self.player2.position = ccp(size.width/2, size.height-73.84 - 28);
    
    [self.player1 start:1];
    [self.player2 start:2];
}

//ゲームストップ
-(void)stopGame {
    self.player1.life = 5;
    self.player2.life = 5;
}

-(void)gameover {
    //ゲームオーバー用のレイヤーを画面の最前面に追加します。
    [self addChild:[GameoverLayer node] z:100];
    
    [self.player1 stop];
    [self.player2 stop];
}

@end
