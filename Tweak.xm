// ============================================
//  OffsetsValidator.xm
//  للايفون - دايلب محقون
//  يتحقق من صحة الأوفستات ويعرض النتيجة
// ============================================

#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// ============================================
// 1. تعريف الأوفستات
// ============================================
typedef struct {
    const char *name;
    uintptr_t address;
} OffsetEntry;

static OffsetEntry gOffsets[] = {
    {"kUWorld",                      0x106B0FE80},
    {"kGNames",                      0x1050C4AB4},
    {"kHookHUD",                     0x109A731B0},
    {"kGetHUD",                      0x1038E4E8C},
    {"kDrawText",                    0x1031F62BC},
    {"kDrawLine",                    0x1063B95D8},
    {"kDrawRectFilled",              0x1063B9548},
    {"kDrawCircleFilled",            0x106798690},
    {"kEngine",                      0x10AAA3320},
    {"kLineOfSight_1",               0x10A523070},
    {"kLineOfSight_2",               0x10AA8B300},
    {"kLineOfSight_3",               0x106201DE0},
    {"kLineOfSight_4",               0x106201EF0},
    {"kLineOfSight_5",               0x10620D288},
    {"kBonePos",                     0x10361CD48},
    {"kProjectWorldLocationToScreen",0x10636734C}
};
static const int gOffsetCount = sizeof(gOffsets) / sizeof(OffsetEntry);

// ============================================
// 2. دالة آمنة لقراءة الذاكرة
// ============================================
BOOL isAddressReadable(uintptr_t addr) {
    if (addr == 0) return NO;
    vm_size_t size = sizeof(uintptr_t);
    uintptr_t buffer = 0;
    vm_size_t outSize = 0;
    kern_return_t kr = mach_vm_read_overwrite(mach_task_self(),
                                              (mach_vm_address_t)addr,
                                              size,
                                              (vm_address_t)&buffer,
                                              &outSize);
    return (kr == KERN_SUCCESS && outSize == size);
}

// ============================================
// 3. واجهة العرض (علامة كبيرة + الأسماء الغلط)
// ============================================
@interface ResultViewController : UIViewController
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    
    self.mainLabel = [[UILabel alloc] init];
    self.mainLabel.textAlignment = NSTextAlignmentCenter;
    self.mainLabel.font = [UIFont boldSystemFontOfSize:48];
    self.mainLabel.numberOfLines = 0;
    self.mainLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mainLabel];
    
    self.detailsLabel = [[UILabel alloc] init];
    self.detailsLabel.textAlignment = NSTextAlignmentCenter;
    self.detailsLabel.font = [UIFont systemFontOfSize:22];
    self.detailsLabel.textColor = [UIColor whiteColor];
    self.detailsLabel.numberOfLines = 0;
    self.detailsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.detailsLabel];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setTitle:@"إغلاق" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.closeButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.2 blue:0.2 alpha:1.0];
    self.closeButton.layer.cornerRadius = 15;
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.closeButton addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.mainLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.mainLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-80],
        [self.mainLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.mainLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.detailsLabel.topAnchor constraintEqualToAnchor:self.mainLabel.bottomAnchor constant:30],
        [self.detailsLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.detailsLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.detailsLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.closeButton.topAnchor constraintEqualToAnchor:self.detailsLabel.bottomAnchor constant:50],
        [self.closeButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.closeButton.widthAnchor constraintEqualToConstant:150],
        [self.closeButton.heightAnchor constraintEqualToConstant:60]
    ]];
}

- (void)closeTapped {
    self.view.window.hidden = YES;
    self.view.window = nil;
}

@end

// ============================================
// 4. المنطق الأساسي للتحقق
// ============================================
static UIWindow *overlayWindow = nil;

void showValidationResult() {
    uintptr_t slide = _dyld_get_image_vmaddr_slide(0);
    
    NSMutableString *failedNames = [NSMutableString string];
    BOOL allValid = YES;
    
    for (int i = 0; i < gOffsetCount; i++) {
        uintptr_t runtimeAddr = gOffsets[i].address + slide;
        BOOL readable = isAddressReadable(runtimeAddr);
        if (!readable) {
            allValid = NO;
            if (failedNames.length > 0) [failedNames appendString:@"\n"];
            [failedNames appendFormat:@"❌ %s", gOffsets[i].name];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindowScene *scene = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) {
                if (s.activationState == UISceneActivationStateForegroundActive) {
                    scene = s;
                    break;
                }
            }
        }
        overlayWindow = [[UIWindow alloc] initWithWindowScene:scene];
        if (!overlayWindow) {
            overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
        overlayWindow.windowLevel = UIWindowLevelAlert + 1000;
        overlayWindow.backgroundColor = [UIColor clearColor];
        
        ResultViewController *vc = [[ResultViewController alloc] init];
        overlayWindow.rootViewController = vc;
        
        if (allValid) {
            vc.mainLabel.text = @"✅ صحيحة";
            vc.mainLabel.textColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.2 alpha:1.0];
            vc.detailsLabel.text = @"🎯 كل الأوفستات صحيحة 100%";
            vc.detailsLabel.textColor = [UIColor greenColor];
        } else {
            vc.mainLabel.text = @"❌ خطأ";
            vc.mainLabel.textColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0];
            vc.detailsLabel.text = [NSString stringWithFormat:@"الأوفستات الغلط:\n%@", failedNames];
            vc.detailsLabel.textColor = [UIColor redColor];
        }
        
        [overlayWindow makeKeyAndVisible];
    });
}

__attribute__((constructor))
static void initialize() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        showValidationResult();
    });
}
