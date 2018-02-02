Pod::Spec.new do |s|
  s.name             = 'LFKit'
  s.version          = '1.1.0'
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
  ss.source_files         = 'LFKit/LFKit/Category/*'
  # ss.public_header_files  = 'LFKit/LFKit/Category/*.h'
  end

  s.subspec 'Util' do |ss|
  # ss.dependency 'LFKit/Category'
  ss.source_files         = 'LFKit/LFKit/Util/*'
  # ss.public_header_files  = 'LFKit/LFKit/Util/*.h'
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
    sss.dependency 'CocoaLumberjack'
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

    ss.subspec 'LFImagePicker' do |sss|
    sss.source_files         = 'LFKit/LFKit/Component/LFImagePicker/*'
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

  end

  # s.source_files = 'LFKit/LFKit/**/*'
  # s.resources = 'xxx/Resources/**/*.{png}'

  
  
end
