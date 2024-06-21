//
//  NFCRWViewController.m
//  NFC读写工具
//
//  Created by facilityone on 2021/12/31.
//

#import "NFCRWViewController.h"
#import "XSNFCFramework.framework/Headers/NFCManager.h"
#import <CoreNFC/CoreNFC.h>
#import "SVProgressHUD/SVProgressHUD.h"
#import "QRCode/HMScannerController.h"
#import <PgyUpdate/PgyUpdateManager.h>

#define ScrWidth [UIScreen mainScreen].bounds.size.width
#define ScrHeight [UIScreen mainScreen].bounds.size.height

@interface NFCRWViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UILabel *scanLabel;
@property(nonatomic,strong)UILabel *nfcLabel;

@property(nonatomic,strong)UITextView *scanTextView;
@property(nonatomic,strong)UITextView *nfcTextView;

@property(nonatomic,strong)UIButton *scanClearButton;
@property(nonatomic,strong)UIButton *nfcClearButton;

@property(nonatomic,strong)UIButton *scanButton;
@property(nonatomic,strong)UIButton *nfcButton;

@end

@implementation NFCRWViewController


-(UILabel *)scanLabel{
    if (!_scanLabel) {
        _scanLabel = [UILabel new];
        _scanLabel.text = @"扫码获取到的数据:";
        _scanLabel.textColor = [UIColor blackColor];
    }
    return _scanLabel;
}

-(UILabel *)nfcLabel{
    if (!_nfcLabel) {
        _nfcLabel = [UILabel new];
        _nfcLabel.text = @"NFC读取到的数据:";
        _nfcLabel.textColor = [UIColor blackColor];
    }
    return _nfcLabel;
}

-(UITextView *)scanTextView{
    if (!_scanTextView) {
        _scanTextView = [UITextView new];
        _scanTextView.backgroundColor = [UIColor lightGrayColor];
        _scanTextView.font = [UIFont systemFontOfSize:15];
        _scanTextView.textColor = [UIColor blackColor];
        _scanTextView.layer.borderColor = [UIColor brownColor].CGColor;
        _scanTextView.layer.borderWidth = 3;
    }
    return  _scanTextView;
}

-(UITextView *)nfcTextView{
    if (!_nfcTextView) {
        _nfcTextView = [UITextView new];
        _nfcTextView.backgroundColor = [UIColor lightGrayColor];
        _nfcTextView.font = [UIFont systemFontOfSize:15];
        _nfcTextView.textColor = [UIColor blackColor];
        _nfcTextView.layer.borderColor = [UIColor brownColor].CGColor;
        _nfcTextView.layer.borderWidth = 3;
    }
    return  _nfcTextView;
}

-(UIButton *)scanButton{
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setTitle:@"写入扫码获取的数据" forState:UIControlStateNormal];
        [_scanButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _scanButton.backgroundColor = [UIColor orangeColor];
        [_scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _scanButton;
}

-(UIButton *)nfcButton{
    if (!_nfcButton) {
        _nfcButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nfcButton setTitle:@"写入NFC读取的数据" forState:UIControlStateNormal];
        [_nfcButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _nfcButton.backgroundColor = [UIColor orangeColor];
        [_nfcButton addTarget:self action:@selector(nfcAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _nfcButton;
}

-(UIButton *)scanClearButton{
    if (!_scanClearButton) {
        _scanClearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanClearButton setTitle:@"清除数据" forState:UIControlStateNormal];
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"XSNFCFramework.framework/Pictures" ofType:@"bundle"];
        NSString *imgPath = [bundlePath stringByAppendingPathComponent:@"icon28.png"];
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
//        [_scanClearButton setImage:[UIImage imageWithContentsOfFile:imgPath] forState:UIControlStateNormal];
        [_scanClearButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _scanClearButton.backgroundColor = [UIColor orangeColor];
        [_scanClearButton addTarget:self action:@selector(scanClearAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _scanClearButton;
}

-(UIButton *)nfcClearButton{
    if (!_nfcClearButton) {
        _nfcClearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nfcClearButton setTitle:@"清除数据" forState:UIControlStateNormal];
        [_nfcClearButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _nfcClearButton.backgroundColor = [UIColor orangeColor];
        [_nfcClearButton addTarget:self action:@selector(nfcClearAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _nfcClearButton;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navBarApperance = [UINavigationBarAppearance new];
       // 颜色
        navBarApperance.backgroundColor = [UIColor orangeColor];
        
        NSDictionary *dictM = @{ NSForegroundColorAttributeName:[UIColor blackColor]};
        navBarApperance.titleTextAttributes = dictM;
        
        self.navigationController.navigationBar.standardAppearance = navBarApperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = navBarApperance;
    }else{
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
        
    }
    
    self.navigationItem.title = @"NFC读写";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBtnitem = [[UIBarButtonItem alloc] initWithTitle:@"获取数据" style:UIBarButtonItemStyleDone target:self action:@selector(getDataAction)];
    self.navigationItem.rightBarButtonItem = rightBtnitem;    
    
    CGFloat originY = 0;
    
    if ((ScrWidth>=375&&ScrHeight>=812) || (ScrWidth>=360&&ScrHeight>=780)) {
        originY = 88;
    }else{
        originY = 64;
    }
    
    self.scanLabel.frame =CGRectMake(5, originY + 10, ScrWidth-10, 15);
    [self.view addSubview:self.scanLabel];
    
    self.scanTextView.frame = CGRectMake(5, originY + 30, ScrWidth-10, ScrHeight/4);
    [self.view addSubview:self.scanTextView];
    
    originY = originY + 30 + ScrHeight/4;
    
    self.scanClearButton.frame = CGRectMake(30, originY + 20, 100, 50);
    self.scanButton.frame = CGRectMake(30+130, originY + 20, ScrWidth-190, 50);
    [self.view addSubview:self.scanClearButton];
    [self.view addSubview:self.scanButton];

    originY = originY + 20 + 50;

    self.nfcLabel.frame =CGRectMake(5, originY + 50, ScrWidth-10, 15);
    [self.view addSubview:self.nfcLabel];

    self.nfcTextView.frame = CGRectMake(5, originY + 70, ScrWidth-10, ScrHeight/4);
    [self.view addSubview:self.nfcTextView];
    
    originY = originY + 70 + ScrHeight/4;
    
    self.nfcClearButton.frame = CGRectMake(30, originY + 20, 100, 50);
    self.nfcButton.frame = CGRectMake(30+130, originY + 20, ScrWidth-190, 50);
    [self.view addSubview:self.nfcClearButton];
    [self.view addSubview:self.nfcButton];
   
    
    [self checkVision];
}

-(void)scanClearAction{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    self.scanTextView.text = @"";
}

-(void)nfcClearAction{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    self.nfcTextView.text = @"";
}

-(void)scanAction {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    if (self.scanTextView.text.length>0) {
        [self writeDataAction:self.scanTextView.text];
    }else{
        [SVProgressHUD showInfoWithStatus:@"数据为空"];
    }
}


-(void)nfcAction {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    if (self.nfcTextView.text.length>0) {
        [self writeDataAction:self.nfcTextView.text];
    }else{
        [SVProgressHUD showInfoWithStatus:@"数据为空"];
    }
}

//写入
-(void)writeDataAction:(NSString *)dataStr {
    
    NFCSupportsStatus status = [NFCManager isSupportsNFCReading];
    if (status == NFCSupportStatusYes) {
        NFCNDEFMessage *msg = [NFCManager createAMessage:dataStr];
        if (msg!=nil) {
            [[NFCManager sharedInstance] writeMessage:msg ToTagWithSuccessBlock:^{
                NSLog(@"写入成功");
            } andErrorBlock:^(NSError * _Nonnull error) {
                NSLog(@"写入失败");
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:@"信息创建失败"];
        }
    }else if (status == NFCSupportStatusDeviceNo) {
        [SVProgressHUD showInfoWithStatus:@"您的设备不支持NFC功能"];
    }else if (status == NFCSupportStatusnSystemNo) {
        [SVProgressHUD showInfoWithStatus:@"您的系统低于iOS 13，请升级后再试"];
    }
 
}



//读取
-(void)getDataAction{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取数据" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *scanAlertAction = [UIAlertAction actionWithTitle:@"扫码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          
            HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
                
                self.scanTextView.text = stringValue;
                
                NSLog(@"扫描出来的字符串是：%@",stringValue);
            }];
            
            // 设置导航栏样式
            [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor orangeColor]];
            scanner.modalPresentationStyle = UIModalPresentationFullScreen;
            // 展现扫描控制器
            [self showDetailViewController:scanner sender:nil];
        
        });
        
    }];
    UIAlertAction *nfcAlertAction = [UIAlertAction actionWithTitle:@"读取NFC设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NFCSupportsStatus status = [NFCManager isSupportsNFCReading];
        if (status == NFCSupportStatusYes) {
            [[NFCManager sharedInstance] scanTagWithSuccessBlock:^(NFCNDEFMessage * _Nonnull message) {
                NSMutableArray *tmp = [NSMutableArray array];
                for (NFCNDEFPayload *payd in message.records) {
                    NSData *data = payd.payload;
                    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [tmp addObject:str];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.nfcTextView.text = [tmp componentsJoinedByString:@","];
                });
            } andErrorBlock:^(NSError * _Nonnull error) {
                NSLog(@"读取失败");
            }];
        }else if (status == NFCSupportStatusDeviceNo){
            [SVProgressHUD showInfoWithStatus:@"您的设备不支持NFC功能"];
        }else if (status == NFCSupportStatusnSystemNo){
            [SVProgressHUD showInfoWithStatus:@"您的系统低于iOS 11，请升级后再试"];
        }
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:scanAlertAction];
    [alert addAction:nfcAlertAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}



-(void)checkVision{
    
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"96b49ad918affd5457b9a32810c61a80"];   // 请将 PGY_APP_ID 换成应用的 App Key
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}

@end
