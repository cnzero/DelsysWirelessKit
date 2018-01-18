
### 说明
在没有完成 MATLAB 中的一些fundamental blocks之前，先尝试写这个最近需求的演示项目，为什么呢？

目前基本上已经完成了Delsys 设备的模型抽象，下一步按照MVC的思路想写一些View，但是脱离了实际项目需求，要我马上能抽象出来一些功能模块，说实话挺困难，也非常如空中楼阁。所以，此时，我给自己的建议是，去写这个实际需求的演示项目，在编程的过程中不断思考，发现其中某些可以作为fundamental blocks的再进行抽象与封装；并且此时，能够有更好的接口定义。


#### 关于 `figure`等的继承关系理解
_错误的理解_
需求场景，我在一个新开的figure内，创建了很多的控件，包括许多Edit，Buttons，以及Checkbox等等；中间也会使用panel用于布局层级摆放，而不是一下子把所有东西都直接摆放在母版figure上，这利于后期进行不同的调整。
所以，代码如下：
```
hFigure = figure();
hPanelParameters = uipanel('Parent', hFigure);
hPanelEMGAxes = uipanel('Parent', hFigure);
hPanelPictureBed = uipanel('Parent', hFigure);

hEditUserName = uicontrol('Parent', hPanelParameters)
```
然后为了能够对必要的控件进行直接控制，我以为需要把所有的控件都“绑定”到一个结构体上去，比如
```
hFigureRoot.hFigure = hFigure;
hFigureRoot.hPanelParameters = hPanelParameters;
hFigureRoot.hPanelEMGAxes = hPanelEMGAxes;
hFigureRoot.hPanelPictureBed = hPanelPictureBed;
% add all key widgets handles to hFigureRoot
hFigureRoot.hEditUserName = hEditUserName;
```

而实际上想想，这一步就是多余的，或者这样做强制“扁平化”再建立他们之间的关系。因为在最初定义过程中使用了`parent`属性，就已经明确了两者的继承关系。那么实际来理解就是，对于`hEditUserName`而言，有两种途径access：
1. 通过`parent`一步步继承的关系。
    `hFigureRoot.hFigure.hPanelParameters.hEditUserName` 路途看起来有点儿远；
    __此处出现严重错误__：
    以为是`Parent` 的属性，就属于正常的继承关系，然而并不是：
    1. `hPanelParameters.Parent` 将得到 `hFigure`；
    2. `hFigure.hPanelParameters` 这句话就是错误的，虽然看似是其子类，但无法想struct一样直接access，除非之前先用struct的方式进行绑定
2. 通过强制“扁平化”的关系。
    `hFigureRoot.hEditUserName`

将两者进行对比，第一种途径看似是有点儿远了，实际上非常符合在布局过程中的层级控制关系，不用担心因为继承关系层级较多无法对最终的句柄进行控制；而第二种方法，虽然看起来要简单很多，但是需要额外在程序里面强制添加内容，如果新填入了一个空间而忘了添加“强制”关系，那这个控件的属性就无法access，这条路很容易遇到自己给自己挖的坑。

所以，经比较，推荐使用第一种方法。 原来的许多代码都使用了第二种方法，从此后使用第一种更符合直觉的方法。

#### Insights
实际上为什么要做一个休息动作呢？没有必要，还是只做三个动作吧：
1. Rock
2. Paper
3. Scissor

这样的话，减少一个动作，也可以尽量减少一个电极通道。

#### Improvements
1. 调节对假肢手的指令发送，没必要对当前的样本得到分类结果后马上就发送控制指令，
    稍微降低下指令发送速度，也避免对假肢手快速反应引起的位置混乱；
2. 减少一个动作，仅仅使用三个有效动作；
3. 感觉使用TCPIP进行数据读取的方式与理解，还有待提高，目前处理起来总感觉非常吃力，为什么？