# README

### AnotherMe for iOS 运行方式

1. 设备需求：

   macOS 12.0+

   Xcode 13.0+

   iOS 13.0+

2. 用 Xcode 打开 cocoaPods 工作区（即 *Browser.xcworkspace* 文件），该项目 pod 了第三方的  json 解析，在 *Browser.xcodeproj* 项目文件中无法运行。

3. 将 iPhone 通过数据线连接到 Mac，在调试中选择实机。

   ![截屏2022-06-20 18.40.07](https://s3.bmp.ovh/imgs/2022/06/20/93e47d0907a57790.png)

   ![截屏2022-06-20 18.40.07](https://s3.bmp.ovh/imgs/2022/06/20/8e4f8555dda1dcc4.png)

4. 编译完成后，在 iPhone 的设置 -> 通用 -> VPN 与设备管理中验证证书。

   <img src="https://s3.bmp.ovh/imgs/2022/06/20/5c363117b8997a91.jpeg" style="zoom: 33%;" />

   ### 关于无法导出安装包的问题

   鉴于中国大陆区 App Store 的相关政策，个人开发者需以 688¥/年的价格订阅 APPLE DEVELOPER PROGRAM，才能导出仅限用于上架 App Store 的 ipa 安装包。

   1. 关于上架 App Store：App Store 的审核较为严格。该 app 涉及较多的用户隐私信息，且向服务商发送虚拟的混淆信息可能会触及相关的法律法规，故上架 App Store 并不现实。
   2. 关于导出 ipa 安装包：在订阅了 APPLE DEVELOPER PROGRAM 后，从 Xcode 导出的安装包只能用于 App Store 的审核并委托上架，并不能直接导入到 iPhone 中。需要 iPhone 越狱并通过第三方的工具刷写证书导入 iPhone，过程冗杂且对 iPhone 有一定的安全隐患（造成黑苹果，白苹果，丢失所有数据等），故不考虑导出 ipa 安装包。

   敬请谅解。