---
layout: post
title: 语音情感识别- 特征提取工具和相关特征集
date: 2020-04-11 20:47:00 +08:00
categories: speech
tags: speech
---

<!-- 抑制 markdownlint 对没有大标题的警告 -->
<!-- markdownlint-disable MD002 -->
<!-- markdownlint-disable MD041 -->

## 写在前面

本文部分内容来源于 [PilgrimHui的CSDN博客](https://www.cnblogs.com/liaohuiqiang/p/10161033.html)，笔者补充了一部分内容。
感谢PilgrimHui博主，在我做实验时，他的博客给了我很多启发。

笔者开源了调用 OpenSMILE 提取这些特征的脚本，读者可以从我的Github上获取。
脚本地址：<https://github.com/hellolzc/SpeechEmotionRecognition-emodb/tree/master/opensmile/scripts>

## OpenSMILE工具和相关特征

### 一：LLDs特征和HSFs特征

这两个概念广泛出现于OpenSMILE工具和相关的文章。<br>
（1）首先区分一下frame和utterance，frame就是一帧语音。utterance是一段语音，是比帧高一级的语音单位，通常指一句话，一个语音样本。utterance由多帧语音组成，通常对一个utterance做分帧来得到多帧信号。<br>
（2）LLDs（low level descriptors）LLDs指的是手工设计的一些低水平特征，一般是在一帧语音上进行的计算，是用来表示一帧语音的特征。<br>
（3）HSFs（high level statistics functions）是在LLDs的基础上做一些统计而得到的特征，比如均值，最大值等等。HSFs是对utterance上的多帧语音做统计，所以是用来表示一个utterance的特征。<br>
（4）后面讲的一些特征集，是由一些专家设计的一些特征，包括了LLDs和HSFs。

### 二：GeMAPS特征集和eGeMAPS特征集

#### GeMAPS特征集

（1）GeMAPS特征集总共62个特征，这62个都是HSF特征，是由18个LLD特征计算得到。下面先介绍18个LLD特征，然后介绍62个HSF特征。这里只简单介绍每个特征的概念，不涉及具体计算细节。<br>
（2）18个LLD特征包括6个频率相关特征，3个能量/振幅相关特征，9个谱特征。<br>
（3）基音F0的概念：先理解一个常用的概念，基音，通常记作F0（F0一般也指基音频率），一般的声音都是由发音体发出的一系列频率、振幅各不相同的振动复合而成的。这些振动中有一个频率最低的振动，由它发出的音就是基音，其余为泛音。<br>
（4）6个频率相关特征包括：Pitch（log F0，在半音频率尺度上计算，从27.5Hz开始）；Jitter（看论文中写的是基音周期变化，即音调变化，在这里还根据基音周期长度做了归一化 ~~单个连续基音周期内的偏差，偏差衡量的是观测变量与特定值的差，如果没有指明特定值通常使用的是变量的均值~~）；前三个共振峰的中心频率，第一个共振峰的带宽。<br>
（5）3个能量/振幅的特征包括：Shimmer（相邻基音周期间振幅峰值之差），Loudness（从频谱中得到的声音强度的估计，可以根据能量来计算），HNR（Harmonics-to-noise）信噪比。<br>
（6）9个谱特征包括，Alpha Ratio（50-1000Hz的能量和除以1-5kHz的能量和），Hammarberg Index（0-2kHz的最强能量峰除以2-5kHz的最强能量峰），Spectral Slope 0-500 Hz and 500-1500 Hz（对线性功率谱的两个区域0-500 Hz和500-1500 Hz做线性回归得到的两个斜率），Formant 1, 2, and 3 relative energy（前三个共振峰的中心频率除以基音的谱峰能量），Harmonic difference H1-H2（第一个基音谐波H1的能量除以第二个基音谐波的能量），Harmonic difference H1-A3（第一个基音谐波H1的能量除以第三个共振峰范围内的最高谐波能量）。<br>
（7）对18个LLD做统计，计算的时候是对3帧语音做symmetric moving average。首先计算算术平均和coefficient of variation（计算标准差然后用算术平均规范化），得到36个统计特征。然后对loudness和pitch运算8个函数，20百分位，50百分位，80百分位，20到80百分位之间的range，上升/下降语音信号的斜率的均值和标准差。这样就得到16个统计特征。上面的函数都是对voiced regions（非零的F0）做的。对Alpha Ratio，Hammarberg Index，Spectral Slope 0-500 Hz and 500-1500 Hz做算术平均得到4个统计特征。另外还有6个时间特征，每秒loudness峰的个数，连续voiced regions（F0>0）的平均长度和标准差，unvoiced regions（F0=0）的平均长度和标准差，每秒voiced regions的个数。36+16+4+6得到62个特征。

#### eGeMAPS特征集

（1）eGeMAPS是GeMAPS的扩展，在18个LLDs的基础上加了一些特征，包括5个谱特征：MFCC1-4和Spectral flux（两个相邻帧的频谱差异）和2个频率相关特征：第二个共振峰和第三个共振峰的带宽。<br>
（2）对这扩展的7个LLDs做算术平均和coefficient of variation（计算标准差然后用算术平均规范化）可以得到14个统计特征。对于共振峰带宽只在voiced region做，对于5个谱特征在voiced region和unvoiced region一起做。<br>
（3）另外，只在unvoiced region计算spectral flux的算术平均，然后只在voiced region计算5个谱特征的算术平均和coefficient of variation，得到11个统计特征。<br>
（4）另外，还加多一个equivalent sound level 。<br>
（5）所以总共得到14+11+1=26个扩展特征，加上原GeMAPS的62个特征，得到88个特征，这88个特征就是eGeMAPS的特征集。

### 三：ComParE特征集

（1）ComParE，Computational Paralinguistics ChallengE，是InterSpeech上的一个挑战赛，从13年至今（2018年），每年都举办，每年有不一样的挑战任务。<br>
（2）从13年开始至今（2018年），ComParE的挑战都会要求使用一个设计好的特征集，这个特征集包含了6373个静态特征，是在LLD上计算各种函数得到的，称为ComParE特征集。<br>


### 四：2009-2013 InterSpeech挑战赛特征

#### IS09
（1）前面说的6373维特征集ComparE是13年至今InterSpeech挑战赛中用的。有论文还用了09年InterSpeech上Emotion Challenge提到的特征，总共有384个特征，计算方法如下。<br>
（2）首先计算16个LLD，过零率，能量平方根，F0，HNR（信噪比，有些论文也叫vp，voice probability 人声概率），MFCC1-12，然后计算这16个LLD的一阶差分，可以得到32个LLD。<br>
（3）对这32个LLD应用12个统计函数，最后得到32x12 = 384个特征。<br>

#### IS10 
相比IS09额外添加了PCM响度、8个log Mel frequency band (0-7)、8个线谱对（LSP）频率（0-7）、F0的包络、发音概率、jitter和shimmer相关特征、额外的两个MFCC系数。
最终有76个LLD，统计后有1582个特征。


#### IS11 
相比IS10，加入derived loudness measure 和 Relative Spectral Analysis (RASTA)-style filtered auditory spectra


#### IS12
相比IS11，加入harmonic-to-noise ratio (HNR), spectral harmonicity, 和psychoacoustic spectral sharpness

#### IS13

InterSpeech ComparE挑战赛使用的特征集，后来经过一些数值上小修订成为了前面所说的ComParE特征集，一共6373个feature，130维的LLD。

详细的描述建议看文献：

F. Weninger, F. Eyben, B. W. Schuller, M. Mortillaro, and K. R. Scherer, “On the acoustics of emotion in audio: What speech, music, and sound have in common,” Front. Psychol., vol. 4, no. MAY, pp. 1–12, 2013


### 五：小结

| 配置文件 名称           | 全局特征(HSF)维度 | 时序特征 (LLD)维度 | 描述                                               |
| ----------------------- | ----------------- | ------------------ | ---------------------------------------------------- |
| IS09_emotion.conf       | 384               | timestep X 32      | INTERSPEECH 2009情感挑战赛特征集             |
| IS10_paraling.conf      | 1582              | timestep x 76      | INTERSPEECH 2010 Paralinguistic挑战赛特征集    |
| IS11_speaker_state.conf | 4368              | timestep x 120     | INTERSPEECH 2011说话人状态挑战赛特征集    |
| IS12_speaker_trait.conf | 5757              | timestep x 120     | INTERSPEECH 2012说话人特征挑战赛特征集    |
| IS13_ComParE.conf       | 6373              | timestep x 130     | Interspeech 2013 ComParE emotion sub-challenge       |
| ComParE_2016.conf       | 6373              | timestep x 130     | ComParE 2013特征集更新版, numerical fixes |

上述几个特征都包含在了我的脚本中:
- <https://github.com/hellolzc/SpeechEmotionRecognition-emodb/tree/master/opensmile/scripts>


## BoAW
（1）BoAW，bag-of-audio-words，是特征的进一步组织表示，是根据一个codebook对LLDs做计算得到的。这个codebook可以是k-means的结果，也可以是对LLDs的随机采样。<br>
（2）在论文会看到BoAW特征集的说法，指的是某个特征集的BoAW形式。比如根据上下文“使用特征集有ComparE和BoAW”，可以知道，这样的说法其实是指原来的特征集ComparE，和ComparE经过计算后得到的BoAW表示。<br>
（3）可以通过openXBOW开源包来获得BoAW表示。

## 其他特征和特征提取工具
（1）YAAFE特征: Yet Another Audio Feature Extractor, 支持Python和MATLAB。使用YAAFE库，具体特征见YAAFE主页。
（2）COVAREP特征: MATLAB开发的工具包。详见他们发表的论文。
（3）其他常见的语音特征工具如librosa，kaldi有时也会用在语音情感分类中，它们不是针对语音情感分类设计的，但有时也会使用。

## 参考资料

* [1] [论文：eGeMAPS特征集（2016 IEEE trans on Affective Computing）](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7160715)
* [2] [论文：2013 InterSpeech ComparE挑战赛（2013 InterSpeech）](https://www.isca-speech.org/archive/archive_papers/interspeech_2013/i13_0148.pdf)
* [3] [论文：2009 InterSpeech情感挑战（2009 InterSpeech）](https://www.isca-speech.org/archive/archive_papers/interspeech_2009/papers/i09_0312.pdf)
* [4] [论文：BoAW用于语音情感识别（2016 InterSpeech）](https://www.isca-speech.org/archive/Interspeech_2016/pdfs/1124.PDF)
* [5] [论文：COVAREP工具](https://ieeexplore.ieee.org/document/6853739)
* [6] [YAAFE主页](http://yaafe.sourceforge.net/)
