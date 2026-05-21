# 快速开始：从下载到上板

本文档用于指导他人从零开始使用本仓库，在 Quartus Prime Lite 中完成编译、引脚导入和 DE2-115 上板烧录。

## 1. 下载工程

进入仓库首页，点击绿色按钮：

```text
Code → Download ZIP
```

下载完成后解压，例如得到：

```text
eda-digital-clock-main/
```

## 2. 新建 Quartus 工程

打开 Quartus Prime Lite，选择：

```text
File → New Project Wizard
```

建议工程目录和工程名：

```text
工程目录：D:/eda_digital_clock
工程名：eda_digital_clock
顶层实体：top_de2_115
```

如果一开始没有填对顶层实体，后面也可以在：

```text
Assignments → Settings → General → Top-level entity
```

把顶层实体改成：

```text
top_de2_115
```

## 3. 选择 FPGA 器件

DE2-115 开发板使用的 FPGA 是 Cyclone IV E 系列。器件选择：

```text
Family：Cyclone IV E
Device：EP4CE115F29C7
```

如果列表中找不到 Cyclone IV E，说明 Quartus 没有安装 Cyclone IV 器件支持包，需要补装 Device Support。

## 4. 添加 Verilog 文件

在 Quartus 中选择：

```text
Project → Add/Remove Files in Project...
```

加入仓库 `src/` 目录下所有 `.v` 文件：

```text
src/divider.v
src/counter10.v
src/counter6.v
src/counter60.v
src/counter24.v
src/bcd7seg.v
src/key_pulse.v
src/clock_core.v
src/top_de2_115.v
```

然后确认顶层实体为：

```text
top_de2_115
```

## 5. 第一次编译

点击：

```text
Processing → Start Compilation
```

或点击左侧任务栏：

```text
Compile Design
```

如果编译成功，报告中应看到：

```text
Full Compilation was successful.
0 errors
```

## 6. 导入 DE2-115 引脚约束

打开：

```text
Assignments → Import Assignments...
```

选择仓库中的：

```text
pin/de2_115_pin_assignment.qsf
```

导入后重新编译一次。

如果导入正确，Pin Planner 中应能看到类似内容：

```text
CLOCK_50    PIN_Y2
KEY[0]      PIN_M23
SW[0]       PIN_AB28
HEX0[0]     PIN_G18
LEDR[0]     PIN_G19
```

## 7. 烧录到 DE2-115

连接 DE2-115 开发板，打开电源。然后在 Quartus 中选择：

```text
Tools → Programmer
```

步骤如下：

1. 点击 `Hardware Setup...`；
2. 选择 `USB-Blaster`；
3. 点击 `Add File...`；
4. 选择工程目录下生成的 `.sof` 文件：

```text
output_files/eda_digital_clock.sof
```

5. 勾选 `Program/Configure`；
6. 点击 `Start`。

烧录进度到 100% 后，程序已经下载到 FPGA。

## 8. 开关和按键说明

| 输入 | 功能 |
|---|---|
| `KEY[0]` | 低电平复位 |
| `KEY[1]` | 小时加一 |
| `KEY[2]` | 分钟加一 |
| `KEY[3]` | 闹钟分钟加一 |
| `SW[0]` | 计时使能，1 为运行，0 为暂停 |
| `SW[1]` | 12/24 小时显示切换 |
| `SW[2]` | 闹钟小时加一 |
| `SW[3]` | 闹钟开关 |

## 9. 数码管和 LED 显示说明

| 输出 | 功能 |
|---|---|
| `HEX5 HEX4` | 小时显示 |
| `HEX3 HEX2` | 分钟显示 |
| `HEX1 HEX0` | 秒钟显示 |
| `LEDR[0]` | 闹钟匹配提示 |
| `LEDR[1]` | 整点闪烁提示 |
| `LEDR[9:2]` | 闹钟分钟 BCD 显示 |
| `LEDR[17:10]` | 闹钟小时 BCD 显示 |

## 10. 推荐验收流程

1. 复位后观察数码管是否显示 `00:00:00`；
2. 打开 `SW[0]`，观察秒是否开始递增；
3. 等待 `59 → 00`，观察分钟是否加一；
4. 按 `KEY[1]`，观察小时是否加一；
5. 按 `KEY[2]`，观察分钟是否加一；
6. 切换 `SW[1]`，观察 12/24 小时显示是否变化；
7. 设置闹钟并打开 `SW[3]`，观察 `LEDR[0]` 是否在匹配时亮起。
