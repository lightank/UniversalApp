# Uncomment the next line to define a global platform for your project

# 下面 source 是指明依赖库 pod 的来源地址
source 'https://github.com/CocoaPods/Specs.git'

#指定具体平台和版本
platform :ios, '9.0'

# 忽略引入库的所有警告（强迫症者的福音啊）
inhibit_all_warnings!

# 通过指定use_frameworks!要求生成的是framework而不是静态库。
# 使用 use_frameworks! 命令会在Pods工程下的Frameworks目录下生成依赖库的framework
# 不使用use_frameworks!命令会在Pods工程下的Products目录下生成.a的静态库
use_frameworks!

target 'UniversalApp' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for UniversalApp

    # 网络
    pod 'Reachability', '3.2'
    pod 'YTKNetwork', '2.1.4'
    pod 'SDWebImage', '5.5.1'

    # Tools
    pod 'FCUUID', '1.3.1'
    #pod 'Aspects'
    #pod 'VCProfiler' #监测控制器加载耗时:https://github.com/panmingyang2009/VCProfiler
    
    # Debug Tool
    pod 'LookinServer', '1.0.0', :configurations => ['Debug']  #官网:https://lookin.work
    pod 'FLEX', '3.1.2', :configurations => ['Debug']
    #pod 'GodEye', '~> 1.1.2', :configurations => ['Debug']

    # 布局
    pod 'Masonry', '1.1.0'
    
    # UI
    pod 'IQKeyboardManager', '6.5.5'
    pod 'QMUIKit', '4.0.4'
    pod 'SDCycleScrollView', '1.80'
    pod 'YYKit', '1.0.9'
    pod 'CYLTabBarController', '1.28.5'
    pod 'MJRefresh', '3.3.1'
    pod 'HWPanModal', '~> 0.6.0' # 底部弹出控制器
    #pod 'FSCalendar', '2.8.1'
    #pod 'SVGKit', '2.1.1'
    #pod 'lottie-ios', '3.1.5'
    #pod 'MBProgressHUD'
    #pod 'iCarousel'
    #pod 'QMUIKit/QMUICore'  # 分类
    #pod 'QMUIKit/QMUIComponents'   # UI控件
    #pod 'QMUIKit/QMUIComponents/QMUITips'   # 弹窗
    #pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
    #pod 'HCSStarRatingView', '~> 1.5' # 星级视图

    # 数据库
    pod 'WCDB', '1.0.7.5'
    #pod 'FMDB'
    pod 'ReactiveObjC', '3.1.1'
    pod 'RTRootNavigationController', '0.7.2'
    pod 'FDFullscreenPopGesture', '1.1'
    #pod 'EBBannerView'   #前台时通知 https://github.com/pikacode/EBBannerView
    
    # 二维码
    #pod 'LBXScan'    #OC版:https://github.com/MxABC/LBXScan
    #pod 'EFQRCode'    #Swift版:https://github.com/EFPrefix/EFQRCode
    
    # UMeng Analytics iOS SDK Begin .......
    #依赖库
    pod 'UMCCommon', '2.1.1'
    pod 'UMCSecurityPlugins', '1.0.6'
    #统计 SDK
    pod 'UMCAnalytics', '6.0.5'
    # UMeng Analytics iOS SDK End .......
    
    #极光推送
    pod 'JPush', '3.2.8'

end

# pod - 指定项目的依赖项
#
# 特定的依赖库的版本，就需要在后面写上具体版本号，格式:
#     pod 'AFNetworking', '3.2.1'
# 也可以指定版本范围
#  '> 3.2.1'：高于 3.2.1 版本（不包含 3.2.1 版本）的任意一个版本
#  '>= 3.2.1'：高于 3.2.1 版本（包含 3.2.1 版本）的任意一个版本
#  '< 3.2.1'：低于 3.2.1 版本（不包含 3.2.1 版本）的任意一个
#  '<= 3.2.1'：低于 3.2.1 版本（包含 3.2.1 版本）的任意一个
#  '~> 3.2.1' 版本 3.2.1 的版本到 3.3，不包括 3.3.0。这个基于你指定的版本号的最后一个部分。这个例子等效于 >= 3.2.1 并且 < 3.3.0，并且始终是你指定范围内的最新版本
# 关于版本形式规范详情请参考链接：https://semver.org/lang/zh-CN/
#
# Build configurations（编译配置）
#
# 默认情况下， 依赖项会被安装在所有 target 的 build configuration 中。为了调试或者处于其他原因，依赖项只能在给定的 build configuration中 被启用
# 只在 Debug 和 Beta 模式下启用配置:
#  pod 'AFNetworking', :configurations => ['Debug', 'Beta']
# 也可以只指定一个 build configurations。以下两种写法均可
#  pod 'AFNetworking', :configuration => 'Debug'
#  pod 'AFNetworking', :configurations => ['Debug']
#
#
# Subspecs
#
# 一般情况我们会通过依赖库的名称来引入，cocoapods会默认安装依赖库的所有内容。我们也可以指定安装具体依赖库的某个子模块，例如：
# pod 'AFNetworking/NSURLSession' # 仅安装 AFNetworking 库下的 NSURLSession 模块
# pod 'AFNetworking', :subspecs => ['NSURLSession', 'UIKit'] # 仅安装 AFNetworking 下的 NSURLSession 和 UIKit 模块
#
# Using the files from a local path (使用本地文件)
#
# 指定依赖库的来源地址。如果我们想引入我们本地的一个库，可以这样写：
#  pod 'AFNetworking', :path => '~/Documents/AFNetworking'
# 使用这个选项后，Cocoapods会将给定的文件夹认为是Pod的源，并且在工程中直接引用这些文件。这就意味着你编辑的部分可以保留在CocoaPods安装中，如果我们更新本地AFNetworking里面的代码，cocoapods也会自动更新。
# 被引用的文件夹可以来自你喜爱的SCM，甚至当前仓库的一个git子模块
# 注意：Pod的podspec文件也应该被放在这个文件夹当中
#
#
# From a podspec in the root of a library repository (引用仓库根目录的podspec)
#
# 有时我们需要引入依赖库指定的分支或节点，写法如下。
# 引入master分支（默认）
#  pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git'
# 引入指定的分支
#  pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :branch => 'dev'
# 引入某个节点的代码
#  pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :tag => '0.7.0'
# 引入某个特殊的提交节点
#  pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :commit => '082f8319af'
# 需要特别注意的是，虽然这样将会满足任何在Pod中的依赖项通过其他Pods 但是 podspec 文件必须存在于仓库的根目录中。
#
#
#
#
#
#
#
#
#
#
#
# 参考链接
# Podfile文件用法详解：https://www.jianshu.com/p/b8b889610b7e
