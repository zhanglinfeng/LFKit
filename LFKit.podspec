Pod::Spec.new do |s|
  s.name             = 'LFKit'
  s.version          = '1.0.2'
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
  ss.public_header_files  = 'LFKit/LFKit/Category/*.h'
  end

  s.subspec 'Util' do |ss|
  ss.dependency 'LFKit/LFKit/Category'
  ss.source_files         = 'LFKit/LFKit/Util/*'
  ss.public_header_files  = 'LFKit/LFKit/Util/*.h'
  end

  s.subspec 'Component' do |ss|
  ss.dependency 'LFKit/LFKit/Category'
  ss.source_files         = 'LFKit/LFKit/Component/**/*'
  ss.public_header_files  = 'LFKit/LFKit/Component/**/*.h'
  end

  # s.source_files = 'LFKit/LFKit/**/*'
  # s.resources = 'xxx/Resources/**/*.{png}'

  s.dependency 'YYWebImage'
  
end
