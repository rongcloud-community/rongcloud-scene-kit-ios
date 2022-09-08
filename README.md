# RCSceneKit

[![CI Status](https://img.shields.io/travis/彭蕾/RCSceneKit.svg?style=flat)](https://travis-ci.org/彭蕾/RCSceneKit)
[![Version](https://img.shields.io/cocoapods/v/RCSceneKit.svg?style=flat)](https://cocoapods.org/pods/RCSceneKit)
[![License](https://img.shields.io/cocoapods/l/RCSceneKit.svg?style=flat)](https://cocoapods.org/pods/RCSceneKit)
[![Platform](https://img.shields.io/cocoapods/p/RCSceneKit.svg?style=flat)](https://cocoapods.org/pods/RCSceneKit)

## 简介
本仓库为场景化基础模块，服务于场景化房间的kit。
解耦原有RTC工程的 容器&浮窗 功能，将kit组件代码下沉，房间引用Kit。

### 解耦方案

#### RCSceneKit
将 ContainerKit 和 FloaterKit 做为子组件放入 podspec 中
##### RCSPageContainer
RCSPageContainerController 将 数据源 和 操作进行回调给壳工程的roomList
##### RCSPageFloater
RCSPageFloaterManager 强持有 floatingVC & VC delegate，关闭浮窗需手动移除所有强引用
RCSPageFloatingView 将 数据源 和 操作进行回调

#### RCSceneRoom
移除浮窗、容器相关的抽象协议 RCRoomCycleProtocol

#### RCSceneGame/Voice/Video/RadioRoom 
分别依赖 容器 & 浮窗 kit
roomVC 弱引用 container/floater，内部调用 container/floater 接口

#### 壳工程
RCRoomListViewController 实例，持有 container，实现 container 的代理 RCSRContainerDelegate & RCSRContainerDataSource
全局单例 floaterManager，强持有 container/roomVC、以及 container/roomVC相关delegate对象

## 运行 Example

1. 终端 cd 至项目根目录
2. 执行 pod install
3. 双击打开 .xcworkspace

## 集成

```ruby
pod 'RCSceneKit'
```
## 其他
如有任何疑问请提交 issue

## Author

彭蕾, penglei1@rongcloud.cn

## License

RCSceneKit is available under the MIT license. See the LICENSE file for more info.
