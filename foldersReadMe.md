## 前言
我希望在此文档中能够对该目录下的文件夹等有一个整体性的定义与说明，方便我或者更多人日后阅读，能理清整体框架与文档、脚本关系等，并在此基础上添砖加瓦。
## Preface 
I will give a detailed description about folders, what's their functions and features.
In this way, others and I will get the whole-map to decide which script should be read firstly or later.

### 文件夹 `MATLAB`
该文件夹内，主要是使用`MATLAB`编程语言实现了对传感器数据获取、特征提取、基本分类模型，以及控制器与执行器的连接的基本模块。
对，本文件夹内，强调“功能模块”。它们是我在后面构建工程项目中根据经验打造的一些“轮子”，也是为了方面日后在 `Examples` 文件夹内，能够快速利用这些“轮子”或“功能模块”快速搭建出具体目的的项目，比如功能演示，实验执行等。
本身而言，这些只是散落的零件，想要搭建出能够运行的系统，可参考`Examples`里面的例程。
### MATLAB
basic and fundamental scripts that were implemented by MATLAB

### 文件夹 `Python`
与`MATLAB`文件夹内容相似，也主要是一些“轮子”或“功能模块”。
一方面，我基本上会使用Python语言实现`MATLAB`中所有功能，并尽量保证这些Python的“功能模块”可以运行在更多平台上（比如，一直想打通Linux平台，但是一直都懒得没能够好好动手下去干）；另一方面，当我实现了目前阶段所能够想到的“功能模块”外，我打算以后“远离”MATLAB，并会持续、长期维护、打造更多基于Python的功能模块。
基于这些“功能模块”， 我会继续深入学习、挖掘开源社区与当前主流针对数据的处理思路与一般方法，构建对数据处理的Pipeline。

### Python
Like scripts or functions in folder `MATLAB`, there are similar files in this `Python` folder implementing basic and fundamental blocks. 

### 文件夹 `Examples`
该目录下的任何一个文件夹都代表着一个 __独立的Project__，为了运行或演示当前Project的功能，仅需要阅读其内的`readme.md`文档就能够正确运行——当然，为了实现该Project的功能，一定会借助前面所提到 `MATLAB`或`Python` 功能模块，只需要将根目录切换到当前路径下，根据`readme.md` 步骤说明，能够很快完成该Project。
### Examples
To do some specific or implement experiments purposes

### 另外
关于实验数据。
每次实验过程中的实验数据，包括照片、图片、实验视频，以及更重要的实验传感器数据，我都会进行“二次整理”。为了不干扰本repository的两大主题：功能模块与独立可运行的Project， 我在 `.gitignore` 对比较大的相关数据文档进行了“忽略”。同时，我也会创建单独的`Dataset`相关repository对数据进行整理与积累。

### Additions

> BTW
目前来看直接用英语表达还不是非常习惯，但我会强迫自己这样去做；
当前为了能够快速搭建出来原来已经实现功能的平台等级，我先尝试着重新整理一遍整体性的思路，为了保证思路的流畅性，我只能考虑先用中文表达。但我保证，我会强迫自己慢慢用全英文的方式进行表达与梳理；前期的中文部分，我也会慢慢整理出对应的英文部分。
