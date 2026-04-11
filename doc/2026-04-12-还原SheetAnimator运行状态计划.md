1. 保留 Inspector 的动画和方向预览下拉框。
2. 将编辑器预览与运行时状态隔离，避免修改 `current_animation/current_direction/current_frame`。
3. 用独立的预览帧计数刷新场景视图，恢复运行时状态的原始默认语义。
4. 运行 Godot headless 检查、提交并推送到 GitHub。
