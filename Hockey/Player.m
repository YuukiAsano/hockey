//
//  Player.m
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/05.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Beam.h"
#import "Heart.h"
#import "Bomb.h"
#import "GameScene.h"
#import "Enemy.h"

@interface Player ()
//弾を発射するメソッド
//-(void)fire:(int)player_num;
//敵が地面に衝突したイベントを扱うメソッド
//-(void)gotHit:(CGPoint)position;
@end

@implementation Player
@synthesize sprite, cartridge, life, radius;

-(id)init {
    self = [super init];
    if(self){
        radius = PLAYER_DEFAULT_RADIUS;
        started = NO;
        life = 5;
        
        //画像データを読み込みスプライトとして配置します。
        self.sprite = [CCSprite spriteWithFile:@"player.png"];
        self.sprite.anchorPoint = ccp(0, 0);
        [self addChild:self.sprite];
        
        //playerの持ってるプロパティstateを設定
        state = kPlayerIsStopped;
        
        //弾を先に作成しておき、配列(弾倉)に保存しておきます。
        //発射する際には、この配列内の弾をつかいます。
        self.cartridge = [NSMutableArray arrayWithCapacity:10];
        for(int i=0; i<10; i++){
            float rand = CCRANDOM_0_1();
            if(0 < rand && 0.2 > rand ){
                Heart *heart = [Heart node];
                [self.cartridge addObject:heart];
            }else if(0.2 <= rand && 0.4 >= rand){
                Bomb *bomb = [Bomb node];
                [self.cartridge addObject:bomb];
            }else{
                Beam *beam = [Beam node];
                [self.cartridge addObject:beam];
            }
        }
        cartridgePos = 0;
        
        //手持ちのEnemyたちを作っとく
        self.enemies = [NSMutableArray arrayWithCapacity:2];
        for(int i=0; i<2; i++){
            Enemy *enemy = [Enemy node];
            [self.enemies addObject:enemy];
        }
        enemyPos = 0;
    }
    return self;
}
-(void)start:(int)player_num{
    float rand = CCRANDOM_0_1();
    if(player_num == 1){
        NSString *player_name;
        if(rand > 0.5){
           player_name = @"player1.png";
        }else{
           player_name = @"player3.png";
        }
      [self.sprite setTexture:[[CCTextureCache sharedTextureCache] addImage: player_name]];
    }else if(player_num == 2){
        NSString *player_name;
        if(rand > 0.5){
           player_name = @"player2.png";
        }else{
           player_name = @"player4.png";
        }
      [self.sprite setTexture:[[CCTextureCache sharedTextureCache] addImage: player_name]];
    }
    //移動するためのイベントを動かし始めます
    [self scheduleUpdate];
    
    started = YES;
}

-(void)stop {
    started = NO;
    //startとは逆にイベントをスケジューラーから解除します
    [self unscheduleUpdate];
}

-(void)dealloc{
    self.sprite = nil;
    self.cartridge = nil;
    
    //スケジューリングしていたイベントを全て停止してから終了します
    [self unscheduleAllSelectors];
    [self unscheduleUpdate];
    
    [super dealloc];
}

#pragma mark 移動イベント
//移動の指示をクラスから受け取ります。
//指示があったらすぐに動くのではなく、状態だけを変更しておき、
//実際の位置変更は更新メソッドupdate:で行うのがポイントです。
-(void)moveLeft{
    state = kPlayerIsMovingToLeft;
}

-(void)moveRight{
    state = kPlayerIsMovingToRight;
}

-(void)stopMoving{
    state = kPlayerIsStopped;
}

//状態を確認しどうするか処理を分岐 デフォルトで1/60秒に一回呼ばれる
-(void)update:(ccTime)dt {
	CGSize size = [[CCDirector sharedDirector] winSize];
    float dx = 0; //横方向への移動ポイント量
    //プレイヤーの操作状態によって移動方向を変化させます。
    switch(state){
        case kPlayerIsMovingToLeft:
            dx = -240 * dt;
            break;
        case kPlayerIsMovingToRight:
            dx = 240 * dt;
            break;
        default:
            break;
    }
    
    float newX = self.position.x + dx;
    
    if(newX<0.0f){
        newX = 0;
    }else if(newX>(size.width - self.sprite.contentSize.width)){
        newX = (size.width - self.sprite.contentSize.width);
    }
    
    if(dx != 0.0f){
      self.position = ccp(newX, self.position.y);
    }
}

-(void)fire:(int)player_num {
    
    id *b = [self.cartridge objectAtIndex:cartridgePos];
    
    //砲塔の先端から弾が発射されるように、初期位置を調整した上で発射します
    CGPoint position = ccp(self.position.x, self.position.y);
    [b goFrom:position layer:[GameScene sharedInstance].beamLayer player_num:player_num];
    cartridgePos = (cartridgePos + 1)%10;
}

-(BOOL)hitIfCollided:(CGPoint)position player_num:(int)player_num item_num:(int)item_num{
    BOOL isHit = ccpDistance(self.position, position) < radius;
    if(isHit){
        [self gotHit:position player_num:player_num item_num:item_num];
    }
    return isHit;
}

-(void)gotHit:(CGPoint)position player_num:(int)player_num item_num:(int)item_num{
    if(item_num == 0){
        life--;
        //画面を揺らして、ダメージを受けたことを表示します
        id action = [CCShaky3D actionWithRange:5 shakeZ:YES grid:ccg(10,15) duration:0.5];
        id reset = [CCCallBlock actionWithBlock:^{
            //CCShaky3Dの動作が終了したときに、画面の揺れを元に戻します
            [GameScene sharedInstance].baseLayer.grid = nil;
        }];
        [[GameScene sharedInstance].baseLayer runAction:[CCSequence actions:action, reset, nil]];
    }else if (item_num == 1) {
        life+=3;
    }else if (item_num == 2){
        life-=3;
        //画面を揺らして、ダメージを受けたことを表示します
        id action = [CCShaky3D actionWithRange:5 shakeZ:YES grid:ccg(10,15) duration:0.5];
        id reset = [CCCallBlock actionWithBlock:^{
            //CCShaky3Dの動作が終了したときに、画面の揺れを元に戻します
            [GameScene sharedInstance].baseLayer.grid = nil;
        }];
        [[GameScene sharedInstance].baseLayer runAction:[CCSequence actions:action, reset, nil]];
    }
    [[GameScene sharedInstance] ChangeScore:player_num];
    
    if(life <= 0 && started == YES){
        [[GameScene sharedInstance] gameover];
    }
}

//enemyの処理(EnemyController的役割)
-(void)stageEnemy:(int)player_num {
    //敵の種類(このゲームでは大きさや耐久力)をこの時点で決定し、
    //ストックしておいた敵キャラクターの一つを個性付けした上で、
    //レイヤーに配置します。
    Enemy *e = [self.enemies objectAtIndex:enemyPos];
    
    //オブジェクトが既に配置されている場合は、何もせず次のタイミングを待ちます。
    if(!e.isStaged){
        float velocity = 50;
        
        //画面に唐突に表示されないよう、画面外に少し余裕を持たせて配置します。
        CGPoint position = ccp(self.position.x, self.position.y);
        [e moveFrom:position velocity:velocity layer:[GameScene sharedInstance].enemyLayer player_num:player_num];
        enemyPos = (enemyPos + 1)%2;
    }
    
}

-(BOOL)checkCollision:(CGPoint)position {
    BOOL isHit = NO;
    for(Enemy *e in self.enemies) {
        //画面に配置されていなければチェックしないようにして、無駄な処理を省きます。
        if(e.isStaged){
            isHit = [e hitIfCollided:position]; //相手の敵に当たり判定のチェックを依頼
            //当たっていればチェック終了
            if(isHit){
                break;
            }
        }
    }
    return isHit;
}

@end
