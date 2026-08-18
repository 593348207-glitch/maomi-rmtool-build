#!/bin/sh
set -u

PACKAGE_ID="com.rmtool.magicrecipe"
PROCESS_NAME="MagicRecipe"

pass() { printf '\033[32m[PASS]\033[0m %s\n' "$*"; }
fail() { printf '\033[31m[FAIL]\033[0m %s\n' "$*"; failures=$((failures + 1)); }
info() { printf '\033[36m[INFO]\033[0m %s\n' "$*"; }

failures=0
if [ "$(id -u)" -ne 0 ]; then
  info "建议通过 root shell 运行，以便读取全部路径和进程信息。"
fi

if [ -d /var/jb ]; then
  scheme="rootless"
  prefix="/var/jb"
else
  scheme="rootful"
  prefix=""
fi
info "检测到越狱布局: $scheme"

if command -v dpkg >/dev/null 2>&1 && dpkg -s "$PACKAGE_ID" >/dev/null 2>&1; then
  pass "dpkg 已登记 $PACKAGE_ID"
  dpkg -s "$PACKAGE_ID" | grep -E '^(Package|Version|Architecture|Status):' || true
else
  fail "dpkg 未发现 $PACKAGE_ID"
fi

dylib="$prefix/Library/MobileSubstrate/DynamicLibraries/RMTool.dylib"
plist="$prefix/Library/MobileSubstrate/DynamicLibraries/RMTool.plist"
data_dir="$prefix/Library/Application Support/RMTool"

for path in "$dylib" "$plist" "$data_dir/items.json" "$data_dir/presets.json"; do
  if [ -f "$path" ]; then pass "存在: $path"; else fail "缺失: $path"; fi
done

if command -v plutil >/dev/null 2>&1; then
  if plutil -lint "$plist" >/dev/null 2>&1; then pass "过滤 plist 可解析"; else fail "过滤 plist 无法解析"; fi
fi

if command -v file >/dev/null 2>&1; then
  info "dylib 架构: $(file "$dylib" 2>/dev/null || echo unknown)"
fi

if pgrep -x "$PROCESS_NAME" >/dev/null 2>&1; then
  pass "$PROCESS_NAME 正在运行"
else
  info "$PROCESS_NAME 未运行；启动游戏后再次执行可检查进程状态。"
fi

if command -v launchctl >/dev/null 2>&1; then
  info "若刚安装或替换 JSON，请执行: killall -9 $PROCESS_NAME"
fi

if [ "$failures" -eq 0 ]; then
  pass "静态设备检查全部通过"
  exit 0
fi

fail "$failures 项检查未通过"
info "回滚卸载: dpkg -r $PACKAGE_ID"
exit 1
