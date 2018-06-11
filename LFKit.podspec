Pod::Spec.new do |s|
  s.name             = 'LFKit'
  s.version          = '1.1.8'
  s.summary          = '常用工具组件'
  s.description      = '常用工具组件'

  s.homepage         = 'https://github.com/zhanglinfeng/LFKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '张林峰' => '1051034428@qq.com' }
  s.source           = { :git => 'https://github.com/zhanglinfeng/LFKit.git', :tag => s.version.to_s }
  s.requires_arc = true
  # s.prefix_header_file = "xxx/xxx-prefix.pch"
  s.ios.deployment_target = '8.0'

  s.subspec 'Category' do |ss|
  # ss.dependency 'CocoaLumberjack/Default'
  # ss.source_files         = 'LFKit/LFKit/Category/*'
  # ss.public_header_files  = 'LFKit/LFKit/Category/*.h'

    ss.subspec 'UIColor+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UIColor+LF/*'
    end

    ss.subspec 'NSLayoutConstraint+LFXIB' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/NSLayoutConstraint+LFXIB/*'
    end

    ss.subspec 'NSString+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/NSString+LF/*'
    end

    ss.subspec 'NSTimer+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/NSTimer+LF/*'
    end

    ss.subspec 'UIBarButtonItem+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UIBarButtonItem+LF/*'
    sss.dependency 'LFKit/Category/UIButton+LF'
    end

    ss.subspec 'UIButton+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UIButton+LF/*'
    end

    ss.subspec 'UIImage+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UIImage+LF/*'
    end

    ss.subspec 'UIImageView+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UIImageView+LF/*'
    end

    ss.subspec 'UILabel+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UILabel+LF/*'
    end

    ss.subspec 'UITabBarController+HideTabBar' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UITabBarController+HideTabBar/*'
    end

    ss.subspec 'UITextField+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UITextField+LF/*'
    end

    ss.subspec 'UIView+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UIView+LF/*'
    end

    ss.subspec 'UIView+LFXIB' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UIView+LFXIB/*'
    end

    ss.subspec 'UIViewController+FullScreenScroll' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/UIViewController+FullScreenScroll/*'
    sss.dependency 'LFKit/Category/UITabBarController+HideTabBar'
    end

    ss.subspec 'NSDate+LF' do |sss|
    sss.source_files         = 'LFKit/LFKit/Category/NSDate+LF/*'
    end

  end

  s.subspec 'Util' do |ss|
  # ss.dependency 'LFKit/Category'
  # ss.source_files         = 'LFKit/LFKit/Util/*'
  # ss.public_header_files  = 'LFKit/LFKit/Util/*.h'
    ss.subspec 'LFDeviceInfo' do |sss|
    sss.source_files         = 'LFKit/LFKit/Util/LFDeviceInfo/*'
    end

    ss.subspec 'LFEncryptDecryptUtil' do |sss|
    sss.source_files         = 'LFKit/LFKit/Util/LFEncryptDecryptUtil/*'
    end

    ss.subspec 'LFJsonUtil' do |sss|
    sss.source_files         = 'LFKit/LFKit/Util/LFJsonUtil/*'
    end

    ss.subspec 'LFTimeUtil' do |sss|
    sss.source_files         = 'LFKit/LFKit/Util/LFTimeUtil/*'
    end

    ss.subspec 'LFFileUtil' do |sss|
    sss.source_files         = 'LFKit/LFKit/Util/LFFileUtil/*'
    end

  end

  s.subspec 'Component' do |ss|
  # ss.dependency 'LFKit/Category'
  # ss.source_files         = 'LFKit/LFKit/Component/**/*'
  # ss.public_header_files  = 'LFKit/LFKit/Component/**/*.h'

    ss.subspec 'LFBadge' do |sss|
	  sss.source_files         = 'LFKit/LFKit/Component/LFBadge/*'
  	end

    ss.subspec 'LFBubbleView' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFBubbleView/*'
    end

    ss.subspec 'LFCycleScrollView' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFCycleScrollView/*'
    sss.dependency 'YYWebImage'
    end

    ss.subspec 'LFLogManager' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFLogManager/*'
    sss.dependency 'CocoaLumberjack', '~> 3.4.1'
    end

    ss.subspec 'LFErrorView' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFErrorView/*'
    end

    ss.subspec 'LFPickerView' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFPickerView/*'
    end

    ss.subspec 'LFPopupMenu' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFPopupMenu/*'
    end

    ss.subspec 'LFQRCode' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFQRCode/*'
    end

    ss.subspec 'LFCamera' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFCamera/*'
    end

    # ss.subspec 'LFImagePicker' do |sss|
    # sss.source_files         = 'LFKit/LFKit/Component/LFImagePicker/*.{h,m}'
    # sss.resources = 'LFKit/LFKit/Component/LFImagePicker/Images/*.{png}'
    # sss.dependency 'LFPhotoBrowser'
    # end

    ss.subspec 'LFLocalMusicPicker' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFLocalMusicPicker/*'
    end

    ss.subspec 'LFOptionTableView' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFOptionTableView/*'
    end

    ss.subspec 'RotationMenu' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/RotationMenu/*'
    end

    ss.subspec 'LFAnnulusProgress' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFAnnulusProgress/*'
    end

    ss.subspec 'LFStarsView' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFStarsView/*'
    end

    ss.subspec 'LFAlignCollectionViewFlowLayout' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFAlignCollectionViewFlowLayout/*'
    end

    ss.subspec 'LFSegment' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFSegment/*'
    end

    ss.subspec 'LFBaseCardView' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFBaseCardView/*'
    end

    ss.subspec 'LFFMDB' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFFMDB/*'
    sss.dependency 'FMDB'
    end

    ss.subspec 'LFPhotoBrowser' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFPhotoBrowser/*.{h,m}'
    sss.dependency 'YYWebImage'
    sss.dependency 'MBProgressHUD'
    end

  end

  # s.source_files = 'LFKit/LFKit/**/*'
  # s.resources = 'xxx/Resources/**/*.{png}'

  
  
end
