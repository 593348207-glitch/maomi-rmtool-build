items.json 是功能区1物品表；presets.json 是功能区2套餐表。
替换 JSON 后重启游戏即可热更新，不需要重新安装 DEB。
套餐 rewards 会在运行时每3项自动拆成一封邮件。
clothes.json: one-click all-clothing local-mail catalog (generated from config/all-clothes.txt).
Version 1.2.2: package filter plist is emitted as binary to restore reliable tweak injection.
Version 1.2.3: constructor/install diagnostics are written to the unified log with active-window retry.
Version 1.2.4: device-compatible arm64 diagnostic build; avoids selecting the local arm64e slice.
Version 1.2.5: final build is intended for macOS/GitHub Actions Theos output; local Linux linker output is not used for release.
