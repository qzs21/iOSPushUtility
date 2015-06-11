[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](http://opensource.org/licenses/MIT)

![](../design/icon/128.png)
# iOSPushUtility 
这是一个`OSX`程序，用来测试iOS推送功能，依赖于[Houston](https://github.com/nomad/Houston)。如果你想脱离服务器程序，直接测试你写的iOS程序的推送功能，那你找对地方了！

# 特性
* 用最容易的方法发送一个推送。
* 不需要编写服务器程序。
* 自定义声音文件。
* 记住最后一次输入。

# 用法
1. 选择推送证书。
2. 输入用户设备获取到的Token。
3. 输入声音文件名字。（可选）
4. 输入推送消息内容。
5. 点击`Push`按钮。

# 注意⚠
* 如果你没有安装[Houston](https://github.com/nomad/Houston)在你的Mac上，`iOSPushUtility`将会检测到，并显示`Install Houston`按钮，请点击此按钮安装[Houston](https://github.com/nomad/Houston)。
* `Token`是从用户设备中获取而来的，在`AppDelegate`的`application:didRegisterForRemoteNotificationsWithDeviceToken`方法中，将`NSData`转成`16进制字符串`。( [0x01,0x02,0x0A,0x0B] => "01020A0B" )
* 国内用户访问`gem`默认源可能会速度缓慢，建议切换到淘宝源，切换方法如下
```shell
$ gem sources -l # 查看当前使用的源列表
$ gem sources --remove https://rubygems.org/ # 删除默认源
$ gem sources -a http://ruby.taobao.org/ # 添加淘宝源
```

# 截图
![](../doc/snapshot/UI.png)

# 图标
* 软件图标由`何岸`设计。
