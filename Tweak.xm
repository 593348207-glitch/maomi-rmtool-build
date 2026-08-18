#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <dlfcn.h>
#include <string.h>

typedef void Il2CppDomain; typedef void Il2CppAssembly; typedef void Il2CppImage;
typedef void Il2CppClass; typedef void MethodInfo; typedef void Il2CppObject;
typedef void Il2CppArray; typedef void Il2CppString;

struct API {
  Il2CppDomain* (*domain_get)();
  const Il2CppAssembly** (*domain_get_assemblies)(Il2CppDomain*, size_t*);
  const Il2CppImage* (*assembly_get_image)(const Il2CppAssembly*);
  Il2CppClass* (*class_from_name)(const Il2CppImage*, const char*, const char*);
  const MethodInfo* (*class_get_method_from_name)(Il2CppClass*, const char*, int);
  const MethodInfo* (*class_get_methods)(Il2CppClass*, void**);
  uint32_t (*method_get_param_count)(const MethodInfo*);
  const void* (*method_get_param)(const MethodInfo*, uint32_t);
  char* (*type_get_name)(const void*);
  Il2CppObject* (*object_new)(Il2CppClass*);
  Il2CppObject* (*runtime_invoke)(const MethodInfo*, void*, void**, Il2CppObject**);
  Il2CppArray* (*array_new)(Il2CppClass*, uintptr_t);
  Il2CppString* (*string_new)(const char*);
} g;

static void *sym(const char *n) { return dlsym(RTLD_DEFAULT,n); }
static BOOL LoadAPI() {
  g.domain_get=(decltype(g.domain_get))sym("il2cpp_domain_get");
  g.domain_get_assemblies=(decltype(g.domain_get_assemblies))sym("il2cpp_domain_get_assemblies");
  g.assembly_get_image=(decltype(g.assembly_get_image))sym("il2cpp_assembly_get_image");
  g.class_from_name=(decltype(g.class_from_name))sym("il2cpp_class_from_name");
  g.class_get_method_from_name=(decltype(g.class_get_method_from_name))sym("il2cpp_class_get_method_from_name");
  g.class_get_methods=(decltype(g.class_get_methods))sym("il2cpp_class_get_methods");
  g.method_get_param_count=(decltype(g.method_get_param_count))sym("il2cpp_method_get_param_count");
  g.method_get_param=(decltype(g.method_get_param))sym("il2cpp_method_get_param");
  g.type_get_name=(decltype(g.type_get_name))sym("il2cpp_type_get_name");
  g.object_new=(decltype(g.object_new))sym("il2cpp_object_new");
  g.runtime_invoke=(decltype(g.runtime_invoke))sym("il2cpp_runtime_invoke");
  g.array_new=(decltype(g.array_new))sym("il2cpp_array_new");
  g.string_new=(decltype(g.string_new))sym("il2cpp_string_new");
  return g.domain_get&&g.domain_get_assemblies&&g.assembly_get_image&&g.class_from_name&&g.class_get_method_from_name&&g.object_new&&g.runtime_invoke&&g.array_new&&g.string_new;
}
static const MethodInfo *IntCtor4(Il2CppClass *klass) {
  if(!g.class_get_methods||!g.method_get_param_count||!g.method_get_param||!g.type_get_name) return g.class_get_method_from_name(klass,".ctor",4);
  void *it=nullptr; const MethodInfo *m;
  while((m=g.class_get_methods(klass,&it))){
    if(g.method_get_param_count(m)!=4)continue; BOOL ok=YES;
    for(uint32_t i=0;i<4;i++){ char *n=g.type_get_name(g.method_get_param(m,i)); if(!n||strcmp(n,"System.Int32"))ok=NO; }
    if(ok)return m;
  }
  return nullptr;
}
static const Il2CppImage *GameImage() {
  size_t n=0; auto as=g.domain_get_assemblies(g.domain_get(),&n);
  for(size_t i=0;i<n;i++){ auto im=g.assembly_get_image(as[i]);
    if(g.class_from_name(im,"Currency","CurrencyData") && g.class_from_name(im,"","CencySave")) return im; }
  return nullptr;
}
static NSDictionary *ReadJSON(NSString *name) {
  NSArray *paths=@[[NSHomeDirectory() stringByAppendingPathComponent:[@"Documents/RMTool/" stringByAppendingString:name]],
    [@"/Library/Application Support/RMTool/" stringByAppendingString:name],
    [@"/var/jb/Library/Application Support/RMTool/" stringByAppendingString:name]];
  for(NSString *p in paths){ NSData *d=[NSData dataWithContentsOfFile:p]; if(d){ id x=[NSJSONSerialization JSONObjectWithData:d options:0 error:nil]; if(x)return x; }}
  return nil;
}
static BOOL AddMail(NSArray<NSDictionary*> *rewards, NSString *title, NSString **error) {
  if(!LoadAPI()){if(error)*error=@"IL2CPP API\u672A\u5C31\u7EEA";return NO;} auto image=GameImage();
  if(!image){if(error)*error=@"\u627E\u4E0D\u5230\u6E38\u620F\u7C7B";return NO;}
  auto cd=g.class_from_name(image,"Currency","CurrencyData"); auto cs=g.class_from_name(image,"","CencySave");
  auto ctor=IntCtor4(cd); auto getter=g.class_get_method_from_name(cs,"get_LocalMailData",0);
  if(!ctor||!getter){if(error)*error=@"\u65B9\u6CD5\u7B7E\u540D\u4E0D\u5339\u914D";return NO;}
  Il2CppObject *exc=nullptr; auto local=g.runtime_invoke(getter,nullptr,nullptr,&exc); if(!local||exc){if(error)*error=@"\u5B58\u6863\u5C1A\u672A\u521D\u59CB\u5316";return NO;}
  auto array=g.array_new(cd,rewards.count); void **elements=(void**)((uint8_t*)array+0x20);
  for(NSUInteger i=0;i<rewards.count;i++){ NSDictionary *r=rewards[i]; int type=[r[@"type"] intValue],value=[r[@"value"] intValue],count=[r[@"count"] intValue],sub=[r[@"subType"] intValue];
    auto obj=g.object_new(cd); void *args[]={&type,&value,&count,&sub}; g.runtime_invoke(ctor,obj,args,&exc); if(exc){if(error)*error=@"\u5956\u52B1\u6784\u9020\u5931\u8D25";return NO;} elements[i]=obj; }
  auto lm=(Il2CppClass*)*(void**)((uint8_t*)local); auto add=g.class_get_method_from_name(lm,"AddLocalMail",3);
  auto str=g.string_new(title.UTF8String); int64_t ticks=(int64_t)(([[NSDate dateWithTimeIntervalSinceNow:30*86400] timeIntervalSince1970]*10000000.0)+621355968000000000LL);
  void *args[]={str,&ticks,array}; g.runtime_invoke(add,local,args,&exc); if(exc){if(error)*error=@"\u6295\u9012\u5931\u8D25";return NO;} return YES;
}

@interface RMController:NSObject
@property(nonatomic,strong) UIButton *bubble;
@property(nonatomic,strong) UIView *menuOverlay;
@property(nonatomic,strong) UIView *menuCard;
@property(nonatomic,strong) NSDictionary *items;
@property(nonatomic,strong) NSDictionary *presets;
@property(nonatomic,strong) NSDictionary *clothes;
@property(nonatomic,assign) BOOL bubbleMoved;
@end

@implementation RMController
+(instancetype)shared { static id x; static dispatch_once_t once; dispatch_once(&once,^{ x=[self new]; }); return x; }

-(UIWindow*)activeWindow {
  UIWindow *fallback=nil;
  for(UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
    if(scene.activationState != UISceneActivationStateUnattached && [scene isKindOfClass:UIWindowScene.class]) {
      for(UIWindow *w in ((UIWindowScene*)scene).windows) {
        if(!fallback) fallback=w;
        if(w.isKeyWindow) return w;
      }
    }
  }
  return fallback;
}

-(void)install {
  NSLog(@"[RMTool] install begin");
  if(self.bubble.superview){NSLog(@"[RMTool] bubble already installed");return;}
  self.items=ReadJSON(@"items.json");
  self.presets=ReadJSON(@"presets.json");
  self.clothes=ReadJSON(@"clothes.json");
  UIWindow *w=[self activeWindow];
  if(!w){
    NSLog(@"[RMTool] no active window; retrying");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,2*NSEC_PER_SEC),dispatch_get_main_queue(),^{[[RMController shared] install];});
    return;
  }
  UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
  CGFloat x=[[NSUserDefaults standardUserDefaults] doubleForKey:@"RMToolBubbleX"];
  CGFloat y=[[NSUserDefaults standardUserDefaults] doubleForKey:@"RMToolBubbleY"];
  if(x<=0||y<=0){x=18;y=180;}
  b.frame=CGRectMake(x,y,56,56);
  b.layer.cornerRadius=28;
  b.layer.masksToBounds=NO;
  b.backgroundColor=[UIColor colorWithWhite:0.04 alpha:0.96];
  b.layer.borderColor=UIColor.whiteColor.CGColor;
  b.layer.borderWidth=1.5;
  b.layer.shadowColor=UIColor.blackColor.CGColor;
  b.layer.shadowOpacity=0.45;
  b.layer.shadowRadius=9;
  b.layer.shadowOffset=CGSizeMake(0,4);
  [b setTitle:@"RM" forState:UIControlStateNormal];
  [b setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
  b.titleLabel.font=[UIFont systemFontOfSize:16 weight:UIFontWeightBlack];
  [b addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
  [b addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bubblePan:)]];
  [w addSubview:b]; self.bubble=b;
  NSLog(@"[RMTool] bubble installed window=%@",w);
  [self clampBubbleAnimated:NO];
}

-(void)bubblePan:(UIPanGestureRecognizer*)g {
  UIView *v=g.view; UIWindow *w=[self activeWindow]; if(!v||!w)return;
  CGPoint d=[g translationInView:w];
  if(g.state==UIGestureRecognizerStateBegan) self.bubbleMoved=NO;
  if(fabs(d.x)>2||fabs(d.y)>2) self.bubbleMoved=YES;
  v.center=CGPointMake(v.center.x+d.x,v.center.y+d.y);
  [g setTranslation:CGPointZero inView:w];
  if(g.state==UIGestureRecognizerStateEnded||g.state==UIGestureRecognizerStateCancelled){
    [self clampBubbleAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setDouble:v.frame.origin.x forKey:@"RMToolBubbleX"];
    [[NSUserDefaults standardUserDefaults] setDouble:v.frame.origin.y forKey:@"RMToolBubbleY"];
  }
}

-(void)clampBubbleAnimated:(BOOL)animated {
  UIWindow *w=[self activeWindow]; if(!w||!self.bubble)return;
  UIEdgeInsets safe=w.safeAreaInsets; CGFloat pad=10;
  CGRect f=self.bubble.frame;
  CGFloat minX=safe.left+pad,maxX=w.bounds.size.width-safe.right-pad-f.size.width;
  CGFloat minY=safe.top+pad,maxY=w.bounds.size.height-safe.bottom-pad-f.size.height;
  f.origin.x=MAX(minX,MIN(f.origin.x,maxX)); f.origin.y=MAX(minY,MIN(f.origin.y,maxY));
  CGFloat mid=CGRectGetMidX(f); f.origin.x=(mid<CGRectGetMidX(w.bounds))?minX:maxX;
  void(^changes)(void)=^{self.bubble.frame=f;};
  if(animated)[UIView animateWithDuration:.22 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:changes completion:nil];else changes();
}

-(UIViewController*)top { UIViewController *v=[self activeWindow].rootViewController; while(v.presentedViewController)v=v.presentedViewController; return v; }

-(UIButton*)menuButton:(NSString*)title tag:(NSInteger)tag primary:(BOOL)primary {
  UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
  b.tag=tag; b.layer.cornerRadius=10; b.layer.borderWidth=1.2;
  b.layer.borderColor=(primary?UIColor.whiteColor:[UIColor colorWithWhite:.72 alpha:1]).CGColor;
  b.backgroundColor=primary?UIColor.whiteColor:[UIColor colorWithWhite:.08 alpha:.98];
  [b setTitleColor:primary?UIColor.blackColor:UIColor.whiteColor forState:UIControlStateNormal];
  [b setTitle:title forState:UIControlStateNormal];
  b.titleLabel.font=[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
  b.titleLabel.adjustsFontSizeToFitWidth=YES; b.titleLabel.minimumScaleFactor=.72;
  [b addTarget:self action:@selector(onMenuButton:) forControlEvents:UIControlEventTouchUpInside];
  return b;
}

-(void)open {
  if(self.bubbleMoved){self.bubbleMoved=NO;return;}
  if(self.menuOverlay)return;
  UIWindow *w=[self activeWindow]; if(!w)return;
  UIView *overlay=[[UIView alloc] initWithFrame:w.bounds]; overlay.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  overlay.backgroundColor=[UIColor colorWithWhite:0 alpha:.58];
  UIButton *dismiss=[UIButton buttonWithType:UIButtonTypeCustom]; dismiss.frame=overlay.bounds; dismiss.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [dismiss addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside]; [overlay addSubview:dismiss];
  CGFloat width=MIN(w.bounds.size.width-28,370),height=MIN(w.bounds.size.height-w.safeAreaInsets.top-w.safeAreaInsets.bottom-38,540);
  UIView *card=[[UIView alloc] initWithFrame:CGRectMake((w.bounds.size.width-width)/2,(w.bounds.size.height-height)/2,width,height)];
  card.backgroundColor=[UIColor colorWithWhite:.025 alpha:.98]; card.layer.cornerRadius=22; card.layer.borderWidth=1.2; card.layer.borderColor=[UIColor colorWithWhite:.8 alpha:1].CGColor;
  card.layer.shadowColor=UIColor.blackColor.CGColor;card.layer.shadowOpacity=.65;card.layer.shadowRadius=22;card.layer.shadowOffset=CGSizeMake(0,10);
  [overlay addSubview:card]; self.menuCard=card;
  UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(22,18,width-44,34)]; title.text=@"RM \u529F\u80FD\u83DC\u5355"; title.textColor=UIColor.whiteColor; title.textAlignment=NSTextAlignmentCenter; title.font=[UIFont systemFontOfSize:25 weight:UIFontWeightBlack]; [card addSubview:title];
  UILabel *sub=[[UILabel alloc] initWithFrame:CGRectMake(22,51,width-44,22)]; sub.text=@"\u652F\u6301 RM\u7C7B\u578B-\u7D22\u5F15  \u00B7  \u4F8B RM16-0"; sub.textColor=[UIColor colorWithWhite:.62 alpha:1]; sub.textAlignment=NSTextAlignmentCenter; sub.font=[UIFont monospacedSystemFontOfSize:11 weight:UIFontWeightMedium]; [card addSubview:sub];
  UIView *line=[[UIView alloc] initWithFrame:CGRectMake(24,82,width-48,1)];line.backgroundColor=[UIColor colorWithWhite:.35 alpha:1];[card addSubview:line];
  UIScrollView *scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(14,94,width-28,height-160)];scroll.showsVerticalScrollIndicator=NO;[card addSubview:scroll];
  CGFloat y=0,bh=48,gap=10;
  UIButton *custom=[self menuButton:@"\u81EA\u5B9A\u4E49\u7269\u54C1" tag:1 primary:YES];custom.frame=CGRectMake(0,y,scroll.bounds.size.width,bh);[scroll addSubview:custom];y+=bh+gap;
  NSArray *clothes=[self.clothes[@"items"] isKindOfClass:NSArray.class]?self.clothes[@"items"]:@[];
  if(clothes.count){
    NSString *allTitle=[NSString stringWithFormat:@"\u4E00\u952E\u53D1\u9001\u5168\u90E8\u670D\u9970\uFF08%lu\u4EF6\uFF09",(unsigned long)clothes.count];
    UIButton *all=[self menuButton:allTitle tag:3 primary:NO];all.frame=CGRectMake(0,y,scroll.bounds.size.width,bh);[scroll addSubview:all];y+=bh+gap;
  }
  NSInteger idx=0;for(NSDictionary *p in self.presets[@"packages"]){NSString *t=p[@"buttonTitle"]?:[NSString stringWithFormat:@"?? %ld",(long)idx+1];UIButton *b=[self menuButton:t tag:1000+idx primary:NO];b.frame=CGRectMake(0,y,scroll.bounds.size.width,bh);[scroll addSubview:b];y+=bh+gap;idx++;}
  scroll.contentSize=CGSizeMake(scroll.bounds.size.width,MAX(y,scroll.bounds.size.height+1));
  UIButton *close=[self menuButton:@"\u5173\u95ED\u83DC\u5355" tag:2 primary:NO];close.frame=CGRectMake(14,height-56,width-28,44);close.layer.borderColor=UIColor.whiteColor.CGColor;[card addSubview:close];
  card.transform=CGAffineTransformMakeScale(.9,.9);card.alpha=0;overlay.alpha=0;[w addSubview:overlay];self.menuOverlay=overlay;
  [UIView animateWithDuration:.22 delay:0 usingSpringWithDamping:.82 initialSpringVelocity:.4 options:0 animations:^{overlay.alpha=1;card.alpha=1;card.transform=CGAffineTransformIdentity;} completion:nil];
}

-(void)closeMenu { if(!self.menuOverlay)return;UIView *o=self.menuOverlay,*c=self.menuCard;self.menuOverlay=nil;self.menuCard=nil;[UIView animateWithDuration:.17 animations:^{o.alpha=0;c.transform=CGAffineTransformMakeScale(.94,.94);} completion:^(__unused BOOL done){[o removeFromSuperview];}]; }

-(void)onMenuButton:(UIButton*)b {
  if(b.tag==2){[self closeMenu];return;}
  if(b.tag==1){[self closeMenu];[self custom];return;}
  if(b.tag==3){[self closeMenu];[self sendAllClothes];return;}
  NSInteger idx=b.tag-1000;NSArray *packs=self.presets[@"packages"];
  if(idx>=0&&idx<(NSInteger)packs.count){NSDictionary *p=packs[idx];[self closeMenu];[self sendPack:p];}
}

-(void)toast:(NSString*)s { UIAlertController *a=[UIAlertController alertControllerWithTitle:@"RMTool" message:s preferredStyle:UIAlertControllerStyleAlert];[[self top] presentViewController:a animated:YES completion:nil];dispatch_after(dispatch_time(DISPATCH_TIME_NOW,1.25*NSEC_PER_SEC),dispatch_get_main_queue(),^{[a dismissViewControllerAnimated:YES completion:nil];}); }

-(void)custom {
  UIAlertController *a=[UIAlertController alertControllerWithTitle:@"\u81EA\u5B9A\u4E49\u7269\u54C1" message:@"\u65B0\u7269\u54C1\u53EF\u8F93\u5165 RM\u7C7B\u578B-\u7D22\u5F15\uFF0C\u4F8B RM16-0\uFF1B\u65E7 RM0002 \u4ECD\u53EF\u7528" preferredStyle:UIAlertControllerStyleAlert];
  [a addTextFieldWithConfigurationHandler:^(UITextField *f){f.placeholder=@"RM16-0 / RM16-0-0 / RM0002";f.autocapitalizationType=UITextAutocapitalizationTypeAllCharacters;}];
  [a addTextFieldWithConfigurationHandler:^(UITextField *f){f.placeholder=@"\u6570\u91CF";f.keyboardType=UIKeyboardTypeNumberPad;}];
  [a addAction:[UIAlertAction actionWithTitle:@"\u53D6\u6D88" style:UIAlertActionStyleCancel handler:nil]];
  [a addAction:[UIAlertAction actionWithTitle:@"\u53D1\u9001" style:UIAlertActionStyleDefault handler:^(__unused id x){
    NSString *raw=[[a.textFields[0].text uppercaseString] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    int count=a.textFields[1].text.intValue; NSDictionary *hit=nil; NSString *shown=raw;
    if([raw hasPrefix:@"RM"]&&[raw containsString:@"-"]){
      NSArray *parts=[[raw substringFromIndex:2] componentsSeparatedByString:@"-"];
      NSCharacterSet *nonDigits=[[NSCharacterSet decimalDigitCharacterSet] invertedSet]; BOOL valid=parts.count==2||parts.count==3;
      for(NSString *part in parts)if(part.length==0||[part rangeOfCharacterFromSet:nonDigits].location!=NSNotFound)valid=NO;
      if(valid){int type=[parts[0] intValue],value=[parts[1] intValue],sub=parts.count==3?[parts[2] intValue]:0;hit=@{@"code":raw,@"name":@"Direct RM",@"type":@(type),@"value":@(value),@"subType":@(sub),@"count":@(count)};shown=[NSString stringWithFormat:@"RM%d-%d-%d",type,value,sub];}
    } else {
      NSString *digits=[raw hasPrefix:@"RM"]?[raw substringFromIndex:2]:raw; NSCharacterSet *nonDigits=[[NSCharacterSet decimalDigitCharacterSet] invertedSet]; NSString *code=raw;
      if(digits.length>0&&[digits rangeOfCharacterFromSet:nonDigits].location==NSNotFound)code=[NSString stringWithFormat:@"RM%04d",digits.intValue];
      for(NSDictionary *v in self.items[@"items"])if([v[@"code"] isEqual:code]){hit=v;break;} shown=code;
    }
    if(!hit||count<1){[self toast:@"RM \u683C\u5F0F\u3001\u7C7B\u578B\u3001\u7D22\u5F15\u6216\u6570\u91CF\u65E0\u6548"];return;}
    NSMutableDictionary *reward=[hit mutableCopy];reward[@"count"]=@(count);NSString *e=nil;
    [self toast:AddMail(@[reward],@"\u5F85\u9886\u53D6\u7269\u54C1",&e)?[NSString stringWithFormat:@"%@  \u2713",shown]:e];
  }]];
  [[self top] presentViewController:a animated:YES completion:nil];
}

-(void)sendRewards:(NSArray<NSDictionary*>*)rewards title:(NSString*)title label:(NSString*)label {
  if(!rewards.count){[self toast:@"\u5956\u52B1\u76EE\u5F55\u4E3A\u7A7A"];return;}
  NSUInteger total=(rewards.count+2)/3,ok=0;NSString *err=nil;
  for(NSUInteger i=0;i<rewards.count;i+=3){
    NSArray *part=[rewards subarrayWithRange:NSMakeRange(i,MIN((NSUInteger)3,rewards.count-i))];
    if(AddMail(part,title,&err))ok++;else break;
  }
  if(err){[self toast:[NSString stringWithFormat:@"%@\uFF08\u5DF2\u53D1\u9001 %lu/%lu \u5C01\uFF09",err,(unsigned long)ok,(unsigned long)total]];return;}
  [self toast:[NSString stringWithFormat:@"%@\uFF1A\u5DF2\u53D1\u9001 %lu \u5C01\u90AE\u4EF6\uFF08%lu \u4EF6\uFF09",label,(unsigned long)ok,(unsigned long)rewards.count]];
}

-(void)sendAllClothes {
  NSArray *rewards=[self.clothes[@"items"] isKindOfClass:NSArray.class]?self.clothes[@"items"]:@[];
  NSString *title=[self.clothes[@"title"] isKindOfClass:NSString.class]?self.clothes[@"title"]:@"\u5F85\u9886\u53D6\u7269\u54C1";
  [self sendRewards:rewards title:title label:@"\u5168\u90E8\u670D\u9970"];
}

-(void)sendPack:(NSDictionary*)p {
  NSArray *rewards=[p[@"rewards"] isKindOfClass:NSArray.class]?p[@"rewards"]:@[];
  NSString *title=[p[@"title"] isKindOfClass:NSString.class]?p[@"title"]:@"\u5F85\u9886\u53D6\u7269\u54C1";
  NSString *label=[p[@"buttonTitle"] isKindOfClass:NSString.class]?p[@"buttonTitle"]:@"\u793C\u5305";
  [self sendRewards:rewards title:title label:label];
}
@end

%ctor {
  NSLog(@"[RMTool] constructor reached");
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW,6*NSEC_PER_SEC),dispatch_get_main_queue(),^{[[RMController shared] install];});
}
