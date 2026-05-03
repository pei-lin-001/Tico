# Tico

一款多平台番茄时钟应用，基于 Flutter 开发。

## 功能

- 专注计时器（番茄钟 / 短休息 / 长休息）
- 任务列表管理
- 专注统计与历史
- 通知与提醒
- 可自定义时长
- 多主题支持（亮色 / 暗色 / 多种强调色）
- 账号同步（Firebase）

## 技术栈

- **UI**: Flutter 3.x + Material 3
- **状态管理**: Riverpod 2.x
- **路由**: GoRouter
- **本地存储**: Drift (SQLite)
- **云同步**: Firebase (Auth + Firestore)
- **图表**: fl_chart

## 开始

```bash
# 安装依赖
flutter pub get

# 生成代码 (Drift, Freezed, JSON Serializable)
dart run build_runner build --delete-conflicting-outputs

# 运行
flutter run

# 运行测试
flutter test
```

## 项目结构

```
lib/
├── main.dart          # 入口
├── app.dart           # MaterialApp 配置
├── core/              # 核心共享层
│   ├── theme/         # 主题
│   ├── router/        # 路由
│   ├── constants/     # 常量 & Providers
│   └── utils/         # 工具
├── data/              # 数据层
│   ├── database/      # Drift 数据库
│   ├── repositories/  # Repository 实现
│   └── services/      # 外部服务
├── domain/            # 领域层
│   ├── models/        # 领域模型
│   └── repositories/  # Repository 接口
├── features/          # 功能模块
│   ├── timer/         # 计时器
│   ├── tasks/         # 任务
│   ├── statistics/    # 统计
│   ├── settings/      # 设置
│   └── auth/          # 认证
└── shared/            # 共享组件
```