
# iOS 常用工具库LFKit功能介绍

简介：LFKit包含了平时常用的category，封装的常用组件，一些工具类。

需要LFKit中所有自定义控件的pod 'LFKit/Component'

需要LFKit中所有category的pod 'LFKit/Category'

需要LFKit中所有工具类的的pod 'LFKit/Util'

需要总库的 pod 'LFKit'

只需要某个控件的也可单独pod,比如pod 'LFKit/Component/LFBadge'或者pod 'LFKit/Category/UIButton+LF'

需要多个子库pod 'LFKit/Component',:subspecs=>['LFPopupMenu','LFBadge']

## 一、封装组件

### 1.环形进度条LFAnnulusProgress

可设置渐变色，设置方向

pod 'LFKit/Component/LFAnnulusProgress'

### 2.未读消息角标红点LFBadge

使用简单，省去加约束或计算位置、大小的麻烦，2行代码集成，支持xib 0代码集成，可设置是否拖拽清除（仿qq）

具体介绍见[http://www.cnblogs.com/zhanglinfeng/p/8093872.html](http://www.cnblogs.com/zhanglinfeng/p/8093872.html)

pod 'LFKit/Component/LFBadge'

### 3.带箭头选项窗LFPopupMenu

类似qq点+号弹出的加好友、扫一扫...弹窗。使用起来也是很简单。还可灵活设置样式。

具体介绍见[http://www.cnblogs.com/zhanglinfeng/p/8252798.html](http://www.cnblogs.com/zhanglinfeng/p/8252798.html)

pod 'LFKit/Component/LFPopupMenu'

### 4.气泡提示框LFBubbleView

具体介绍见[http://www.cnblogs.com/zhanglinfeng/p/5632114.html](http://www.cnblogs.com/zhanglinfeng/p/5632114.html)

pod 'LFKit/Component/LFBubbleView'

### 5.扫二维码生成二维码LFQRCode

使用简单、可灵活自定义UI、可扫相册图片，生成二维码可带logo、带阴影

具体介绍见[http://www.cnblogs.com/zhanglinfeng/p/6871670.html](http://www.cnblogs.com/zhanglinfeng/p/6871670.html)

pod 'LFKit/Component/LFQRCode'

### 6.自定义相机LFCamera

具体介绍见[http://www.cnblogs.com/zhanglinfeng/p/6763766.html](http://www.cnblogs.com/zhanglinfeng/p/6763766.html)

pod 'LFKit/Component/LFCamera'

7.旋转展开特效菜单按钮RotationMenu

pod 'LFKit/Component/RotationMenu'

### 8.轮播控件LFCycleScrollView

特点不仅可以轮播图片，还可以轮播任何视图

pod 'LFKit/Component/LFCycleScrollView'

### 9.滚轮选择器LFPickerView

将PickerView，DatePicker封装得更加简单易用，并可搭配UITextField使用，不需处理事件自动将内容显示到UITextField

pod 'LFKit/Component/LFPickerView'

### 10.星级评分控件LFStarsView

## 二、分类category

### 1.NSString+LF

功能：

根据文字数获取高度

根据文字数获取宽度度

截取字符串之间的字符串(如截取出#话题#)

汉字获取拼音

汉字获取拼音首字母

字符串提取数字

字符串关键字部分变高亮色

URL编码

URL解码

获取MD5

判断身份证号

判断邮箱

判断手机号

判断是不是纯数字

判断是否为浮点形

判断是否为数字

判断是否含中文

### 2.UIImage+LF

功能：

毛玻璃效果

生成纯色图片

生成渐变色图片

生成截屏图片

获取图片某位置的颜色

压缩图片到指定内存大小

压缩图片到指定尺寸

获取图片某位置的颜色

### 3.UIBarButtonItem+LF

生成导航上的图片按钮

生成导航上的文字按钮

生成导航上的图片+文字按钮

### 4.UIButton+LF

设置图文排列样式及间距，比如图上字下、图左字右、图右字左

按钮倒计时（重新获取验证码）

### 5.UITextField+LF

限制最大长度

抖动

### 6.UIView+LF

点击事件

### 7.UIView+LFXIB

在控制面板中给xib上的view加圆角，边框等属性

### 8.UIViewController+FullScreenScroll

上下滑动隐藏或显示导航、tabbar

### 9.NSLayoutConstraint+LFXIB

约束的值，单位px,比如设置xib上线的宽度为1px

### 10.UITabBarController+HideTabBar

设置是否隐藏TabBar

### 11.NSDate+LF

- (NSInteger)lf_year;

- (NSInteger)lf_month;

- (NSInteger)lf_day;

- (BOOL)lf_isToday;

- (BOOL)lf_isYesterday;


- (BOOL)lf_isSameYearAsDate:(NSDate \*)aDate;

- (NSDate \*)lf_dateByAddingDays:(NSInteger)days;

- (NSDate \*)lf_dateByAddingMonths:(NSInteger)months;

- (NSDate \*)lf_dateByAddingYears:(NSInteger)years;


### 12.NSTimer+LF

暂停、继续、过段时间再继续

## 二、工具类Util

### 1.LFEncryptDecryptUtil

+ (NSData *)AES256EncryptPlainData:(NSData *)plainData Key:(NSString *)key;//NSData AES加密
+ (NSData *)AES256DecryptCipherData:(NSData*)cipherData Key:(NSString *)key;//NSData AES解密
//NSData DES加密
+ (NSData *)DESEncryptPlainData:(NSData *)plainData Key:(NSString *)key;
//NSData DES解密
+ (NSData *)DESDecryptCipherData:(NSData*)cipherData Key:(NSString *)key;
//NSString AES加密
+ (NSString *)AES256EncryptPlainText:(NSString *)plainText Key:(NSString *)key;
//NSString AES解密
+ (NSString *)AES256DecryptCipherText:(NSString*)cipherText Key:(NSString *)key;
//字符串DES加密
+ (NSString *)DESEncryptPlainText:(NSString *)plainText key:(NSString *)key;
//字符串DES解密
+ (NSString *)DESDecryptCipherText:(NSString*)cipherText key:(NSString*)key;
//字符串DES加密用到Base64
+ (NSString *)DESEncryptBase64PlainText:(NSString *)plainText key:(NSString *)key;
//字符串DES解密用到Base64
+ (NSString *)DESDecryptBase64CipherText:(NSString*)cipherText key:(NSString*)key;
//字符串DES加密、解密
+(NSString*)encryptWithContent:(NSString*)content type:(uint32_t)type key:(NSString*)aKey
### 2.LFFileUtil
//获取Document文件路径
+ (NSString*)getDocumentFilePathWithName:(NSString*)name;
//获取Temp文件路径
+ (NSString*)getTempFilePathWithName:(NSString*)name;
//获取Home文件路径
+ (NSString*)getHomeFilePathWithName:(NSString*)name;
//获取Cache文件路径
+ (NSString*)getCacheFilePathWithName:(NSString*)name;
//创建目录(已判断是否存在，无脑用就行)
+ (BOOL)creatDirectory:(NSString *)path;
//删除目录或文件
+ (BOOL)deleteItemAtPath:(NSString *)path;
//移动文件
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString*)dstPath;

### 3.LFJsonUtil

//json字符串转dict或array
+ (id)objectFromJSONString:(NSString *)string;
//json的NSData转dict或array
+ (id)objectFromJSONData:(NSData *)data;
//json的NSData转dict或array,带编码参数
+ (id)objectFromJSONData:(NSData *)data UsingEncoding:(NSStringEncoding)encoding;
//dict或arrayz转json
+ (NSString \*)jsonFromObject:(id)object;

### 4.LFTimeUtil

//秒数转为时长字符串,format 格式如@"HH:mm:ss" @"mm分ss秒"
+ (NSString *)getTimeStringFromSecond:(NSInteger)second format:(NSString *)format;
//时间戳(毫秒)转时间字符串
+ (NSString *)getDateTimeStringFromTimestamp:(NSString *)timestamp formatter:(NSString *)formatter;
//Date转时间字符串
+ (NSString *)getDateTimeStringFromDate:(NSDate *)date formatter:(NSString *)formatter;
//时间字符串转时间戳（毫秒
+ (NSString *)getTimestampFromDateTimeString:(NSString *)string formatter:(NSString *)formatter;
//时间字符串转NSDate*/
+ (NSDate *)getDateFromDateTimeString:(NSString *)string formatter:(NSString *)formatter;
//NSDate 转 时间戳（毫秒）
+ (NSString *)getTimestampStringFromDate:(NSDate *)date;
//时间戳（毫秒）转n小时、分钟、秒前 或者yyyy-MM-dd HH:mm:ss
+ (NSString *)getBeforeTimeFromDate:(NSString*)strDate;
//时间戳根据格式返回数据 HH:mm、昨天 HH:mm、MM月dd日 HH:mm、yyyy年MM月dd日)
- (NSString *)getVariableFormatDateStringFromTimestamp:(NSString *)timestamp;