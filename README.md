# enladder_mobile

## Epub 阅读器选型

- epub_viewer: https://github.com/fayis672/epub_viewer 低版本手机有问题，使用 epub.js webview 实现
- vocsy_epub_viewer 通过原生封装，安卓和IOS 都有，缺点是需要弹出一个独立的 App

## 特性清单

- 首页书籍清单 ✅
- 详情页 ✅
- 搜索页 ✅
- 书架 ✅
- 设置页 ✅
- 离线下载阅读 ✅
- Epub 阅读器 ✅
- 章节列表 ✅
- Logo ✅
- 阅读位置记忆 ✅
- 上下文菜单：发音 ✅
- 字体大小设置 ✅
- 阅读器主题 ✅
- 单词闪记 ✅
- 清理书架 ✅
- 上下文菜单：查单词 ✅
- 阅读器查单词 ✅
- 攻略中心：内嵌小红书的学习经验 ✅ 
- 文章梯子
- 登录和个人中心


## Bugs

- 下载进度提示优化 ✅
- 5000 单词清单错误

## Debug 

> flutter pub get 
> flutter run 

## Release 

> flutter clean
> flutter build apk --release --no-tree-shake-icons