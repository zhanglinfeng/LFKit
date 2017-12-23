Pod::Spec.new do |s|
  s.name             = 'LFKit'
  s.version          = '1.0.5'
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

    s.subspec 'LFBadge' do |ss|
	  ss.source_files         = 'LFKit/LFKit/Component/LFBadge/*'
  	end

    s.subspec 'LFBubbleView' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/LFBubbleView/*'
    s.dependency 'YYWebImage'
    end

    s.subspec 'LFCycleScrollView' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/LFCycleScrollView/*'
    end

    s.subspec 'LFErrorView' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/LFErrorView/*'
    end

    s.subspec 'LFPickerView' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/LFPickerView/*'
    end

    s.subspec 'LFPopupMenu' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/LFPopupMenu/*'
    end

    s.subspec 'LFQRCode' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/LFQRCode/*'
    end

    s.subspec 'LFCamera' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/LFCamera/*'
    end

    s.subspec 'LFImagePicker' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/LFImagePicker/*'
    end

    s.subspec 'LFOptionTableView' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/LFOptionTableView/*'
    end

    s.subspec 'RotationMenu' do |ss|
    ss.source_files         = 'LFKit/LFKit/Component/RotationMenu/*'
    end

  end

  # s.source_files = 'LFKit/LFKit/**/*'
  # s.resources = 'xxx/Resources/**/*.{png}'

  
  
end
