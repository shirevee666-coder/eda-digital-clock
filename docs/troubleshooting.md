# 常见问题与解决办法

本文档记录使用本工程时最容易遇到的问题，适合交给同学或后续复现实验时查阅。

## 1. Can't find design entity "eda_digital_clock"

### 现象

Quartus 弹窗提示：

```text
Can't find design entity "eda_digital_clock"
```

### 原因

工程名叫 `eda_digital_clock`，但 Verilog 顶层模块并不叫这个名字。本工程的顶层模块是：

```text
top_de2_115
```

### 解决办法

打开：

```text
Assignments → Settings → General
```

将 `Top-level entity` 改为：

```text
top_de2_115
```

或者在 Project Navigator 中右键 `top_de2_115.v`，选择：

```text
Set as Top-Level Entity
```

然后重新编译。

---

## 2. 找不到 Cyclone IV E 或 EP4CE115F29C7

### 现象

新建工程时，器件列表里没有：

```text
Cyclone IV E
EP4CE115F29C7
```

### 原因

当前 Quartus 没有安装 Cyclone IV 器件支持包。

### 解决办法

安装 Quartus 对应版本的 Cyclone IV Device Support。安装完成后重新打开 Quartus，再选择：

```text
Family：Cyclone IV E
Device：EP4CE115F29C7
```

---

## 3. 编译成功，但板子上数码管不亮或显示混乱

### 可能原因

1. 没有导入引脚约束文件；
2. 引脚约束导入到了错误工程；
3. 顶层实体不是 `top_de2_115`；
4. 开发板型号不是 DE2-115；
5. 复位按键 `KEY[0]` 被一直按下或接触异常；
6. `SW[0]` 没有打开，数字钟处于暂停状态。

### 检查步骤

1. 打开 Pin Planner，确认能看到类似分配：

```text
CLOCK_50    PIN_Y2
KEY[0]      PIN_M23
SW[0]       PIN_AB28
HEX0[0]     PIN_G18
LEDR[0]     PIN_G19
```

2. 确认已导入：

```text
pin/de2_115_pin_assignment.qsf
```

3. 重新完整编译，确认：

```text
Full Compilation was successful.
0 errors
```

4. 烧录后拨动 `SW[0]` 到 1，让数字钟运行。

---

## 4. 编译时提示找不到 divider、clock_core、bcd7seg 等模块

### 原因

只添加了 `top_de2_115.v`，没有把 `src/` 下其他 Verilog 文件加入工程。

### 解决办法

打开：

```text
Project → Add/Remove Files in Project...
```

加入 `src/` 下全部 `.v` 文件：

```text
divider.v
counter10.v
counter6.v
counter60.v
counter24.v
bcd7seg.v
key_pulse.v
clock_core.v
top_de2_115.v
```

然后重新编译。

---

## 5. 编译有 warnings，需要处理吗？

如果报告显示：

```text
0 errors
```

则一般可以继续进行上板实验。课程实验中常见 warnings 包括：

1. 未使用部分开关或 LED；
2. 没有写完整时序约束；
3. 部分信号被综合优化；
4. 未设置某些 I/O 电气标准。

只要没有红色 Error，且功能现象正常，通常可以继续完成实验报告。

---

## 6. 烧录时找不到 USB-Blaster

### 检查步骤

1. 确认 DE2-115 已接通电源；
2. 确认 USB 线连接到 Blaster 接口；
3. 打开：

```text
Tools → Programmer → Hardware Setup...
```

4. 选择：

```text
USB-Blaster
```

如果没有 USB-Blaster，通常是驱动没有安装或 USB 连接不正确。

---

## 7. 找不到 .sof 文件

### 原因

还没有完整编译，或者编译失败。

### 解决办法

先运行：

```text
Processing → Start Compilation
```

成功后在工程目录中查找：

```text
output_files/eda_digital_clock.sof
```

在 Programmer 中添加这个 `.sof` 文件进行烧录。

---

## 8. 按键调整不灵敏

本工程中 `KEY[1]`、`KEY[2]`、`KEY[3]` 通过消抖模块生成脉冲。若上板时感觉按键反应不明显，可以：

1. 稍微长按按键；
2. 确认 `KEY[0]` 没有处于复位状态；
3. 确认 `SW[0]` 已打开计时使能；
4. 后续可将按键调整逻辑改为系统时钟域下的更精细处理。

---

## 9. 建议截图内容

实验报告中建议保留以下截图：

1. Quartus 工程文件列表；
2. 器件选择界面，显示 `EP4CE115F29C7`；
3. 编译成功报告，显示 `0 errors`；
4. Pin Planner 中部分引脚分配；
5. Programmer 烧录成功界面；
6. 开发板运行现象照片；
7. ModelSim 或 Quartus 仿真波形截图。
