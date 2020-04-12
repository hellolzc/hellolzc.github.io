---
layout: post
title: 多线程检索文件 - 生产者消费者模型
date: 2017-09-10 20:13:00 +08:00
categories: algorithm
tags: algorithm c parallel
---

<!-- 抑制 markdownlint 对没有大标题的警告 -->
<!-- markdownlint-disable MD002 -->
<!-- markdownlint-disable MD041 -->

我的CSDN博客是<https://blog.csdn.net/daodao0/>，但我感觉在CSDN上写限制很多，广告也很多，不甚满意。
所以github pages博客建立后，就渐渐不在CSDN上写了。一些我觉得有价值的博文我也搬运到了这里。
这篇是其中一篇。

------------------------ 分割线 ---------------------------

## 要求

请分别开发一个单线程和多线程的程序来完成下述功能，并对其性能进行比较分析。检索1个超大文本文件（不小于1G）或多个较小的文本文件（个数不小于100， 文件尺寸不小于2K）某个关键字（单词）的出现次数。比较两程序用时。


## 具体实现
测试环境：ubuntu  16.04，读取一个1.1GB的文本文档

编译方法：使用g++编译器。终端输入`g++ -Wall -o <目标文件> <源代码文件> -lpthread`


## 代码说明

* read_and_search.cpp：一次读取一行，单线程
* read_and_search_queue_pthread.cpp：一次读取一行，双线程，使用队列作为缓冲区
* read_and_search_pthread_mutex.c：一次读取1MB，注释USE_PTHREAD后是单线程，否则是双线程，使用互斥锁



## 结果分析


<table border="0" cellspacing="0" cellpadding="0" width="620"><tbody><tr><td nowrap="nowrap" rowspan="2">
<p align="center">说明</p>
</td>
<td width="318" nowrap="nowrap" colspan="3">
<p align="center">时间（us微秒）</p>
</td>
</tr><tr><td nowrap="nowrap">
<p align="left">第1次</p>
</td>
<td nowrap="nowrap">
<p align="left">第2次</p>
</td>
<td nowrap="nowrap">
<p align="left">第3次</p>
</td>
</tr><tr><td nowrap="nowrap">
<p align="left">单线程，不使用队列，一次读一行</p>
</td>
<td nowrap="nowrap">
<p align="right">9034083</p>
</td>
<td nowrap="nowrap">
<p align="right">1478871</p>
</td>
<td nowrap="nowrap">
<p align="right">1473323</p>
</td>
</tr><tr><td nowrap="nowrap">
<p align="left">2线程，使用队列缓冲，一次读一行</p>
</td>
<td nowrap="nowrap">
<p align="right">9014760</p>
</td>
<td nowrap="nowrap">
<p align="right">8947088</p>
</td>
<td nowrap="nowrap">
<p align="right">9109844</p>
</td>
</tr><tr><td nowrap="nowrap">
<p align="left">单线程，一次读1MB</p>
</td>
<td nowrap="nowrap">
<p align="right">8892822</p>
</td>
<td nowrap="nowrap">
<p align="right">3124941</p>
</td>
<td nowrap="nowrap">
<p align="right">3114100</p>
</td>
</tr><tr><td nowrap="nowrap">
<p align="left">使用双线程，互斥量和信号量，一次读1MB</p>
</td>
<td nowrap="nowrap">
<p align="right">8903740</p>
</td>
<td nowrap="nowrap">
<p align="right">3051904</p>
</td>
<td nowrap="nowrap">
<p align="right">2998314</p>
</td>
</tr></tbody></table>



开始的时候写的程序是一次读一行进行处理的，双线程程序较单线程的程序首次运行速度差不多，读取并查找一个1G的文档都需要9s左右，双线程的优势并没有体现出来，猜想原因可能是内存载入磁盘数据的时候一次性读的是一整块，由于程序的空间局部性较好，操作系统的页面调度算法发挥了很大作用。

一个较为奇怪的地方是，单线程的程序运行第二次后时间明显会变短，而双线程没有明显变化。原因可能是双线程频繁向队列插入和取出元素，每个元素创建时都要分配内存并复制数据，队列开销比较大。

学习了操作系统的线程通信问题后，发现这个题目可以使用生产者——消费者问题模型解决，于是重新编写了代码。这次改成一次读取1MB的数据，速度较一次读一行要快。多线程编程时使用与条件变量相关的pthread调用，如pthread_cond_wait，pthread_cond_signal等来实现互斥访问临界区。多线程读文件平均比单线程快0.1s左右。

总的来说，多线程读文件的效果还是较单线程好一点，但是当程序空间局部性很好的时候，多线程的优势不明显，反而使编程更复杂，出错概率更大，得不偿失。



## 部分代码
read_and_search_pthread_mutex.c：

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>
#include <pthread.h>

//#define USE_PTHREAD //注释掉该宏则是单线程

//------一次性读取的数据块----------------------------
#define MAXSIZE 1024*1024
typedef struct tag_datanode{
    char data[MAXSIZE];
    int size;
}datanode;
//生产者和消费者使用的缓冲区
datanode buff;

pthread_mutex_t the_mutex;
pthread_cond_t condc,condp;

int myglobal;//统计查找词出现的次数
int flag_reading;//表示主线程是否读完了文件


int fuzzymatch(const char *str,const char *what, int start_position, int end_position)
{//自定义函数模糊匹配
    //成功返回出现的位置
    //失败返回-1
    int base=start_position,j=0;
    while (( base+j < end_position)&&(what[j]!='\0')) {
        if (str[base+j]==what[j]) {
            j++;
        }else{
            base++;
            j=0;
        }
    }
    if (what[j]=='\0') return base;
    else return -1;
}

int num_of_word_in_cstring(char *str, char* findword, int str_len)
{//用来统计一个字符串里出现了多少次待查找的词
    int findnum=0;
    int found_place = fuzzymatch(str, findword, 0, str_len);
    int foundwordlen=strlen(findword);
    while (found_place!=-1){
    	findnum++;
    	found_place = fuzzymatch(str, findword, (found_place+foundwordlen), str_len);
    }
    return findnum;
}

void* consumer(void *arg)
{//消费数据 查找词的线程
    char findword[50];
    strcpy(findword,(char*)arg);

    datanode data_consumer;
    //printf("arg:%s  consumer start!\n",findword);
    int consumed_sum=0;
    while(flag_reading ){
        //printf("consumer try to enter critical region\n");
        pthread_mutex_lock(&the_mutex); //互斥使用缓冲区
        while(buff.size == 0) pthread_cond_wait(&condc,&the_mutex);
        //printf("consumer enter critical region\n");

        memcpy(&data_consumer,&buff,sizeof(datanode)); //从缓冲区中取出数据
        buff.size=0;
        pthread_cond_signal(&condp); //唤醒生产者
        pthread_mutex_unlock(&the_mutex); //释放缓冲区使用权

        //printf("consumer leave critical region | got data %d\n",data_consumer.size);
        consumed_sum += data_consumer.size;
        //消费数据
        myglobal += num_of_word_in_cstring(data_consumer.data,findword,data_consumer.size);
        //printf("%d ",myglobal);
    }
    if(buff.size!= 0){//生产者结束后，消费者处理剩余数据
        memcpy(&data_consumer,&buff,sizeof(datanode)); //从缓冲区中取出数据
        buff.size=0;
        //printf("consumer got the last data %d\n",data_consumer.size);
        consumed_sum += data_consumer.size;
        //消费数据
        myglobal += num_of_word_in_cstring(data_consumer.data,findword,data_consumer.size);
    }
    //printf("consumer end | consumed_sum:%d\n",consumed_sum);
    pthread_exit(0);
}

void* producer(void *arg)
{//生产数据  读文件线程
    FILE * in = (FILE *)arg;

    //printf("producer start!\n");
    datanode data_producer;
    int produced_sum=0;
    while(!feof(in)){
        //生产数据
        data_producer.size = fread(data_producer.data,1,MAXSIZE,in);

        //fprintf(stdout,"%*s",data_producer.size, data_producer.data);
        //printf("producer try to enter critical region\n");
        pthread_mutex_lock(&the_mutex); //互斥使用缓冲区
        while(buff.size != 0) pthread_cond_wait(&condp,&the_mutex);
        //printf("producer enter critical region | put data %d\n",data_producer.size);
        produced_sum+=data_producer.size;
        memcpy(&buff,&data_producer,sizeof(datanode));//向缓冲区中放数据
        pthread_cond_signal(&condc); //唤醒消费者
        pthread_mutex_unlock(&the_mutex); //释放缓冲区使用权
        //printf("producer leave critical region\n");
    }
    //printf("producer end | produced_sum:%d\n",produced_sum);
    flag_reading=0;
    pthread_exit(0);
}

int main(int argc, char **argv)
{
  //显示帮助信息
    if(argc < 2){
        printf("usage: read_and_search  filename findword\n");
        exit(-1);
    }

    //显示输入的参数
    printf("filename is %s\n findword is \"%s\"\n",argv[1],argv[2]);
#ifdef USE_PTHREAD
    printf("use pthread\n");
#endif // USE_PTHREAD
    printf("===============================\n");

    //创建变量，全局变量赋值
    //string filename=argv[1];
    //string findword=argv[2];
    memset((void*)&buff,0,sizeof(datanode));
    flag_reading = 1;
    myglobal=0;

#ifdef USE_PTHREAD
    pthread_t pro,con;
    pthread_mutex_init(&the_mutex,0);
    pthread_cond_init(&condc,0);
    pthread_cond_init(&condp,0);
#endif
    //--------------开始计时-------------------
    struct timeval start, end;
    gettimeofday( &start, NULL );

    //打开文件
    FILE *in;
    //ifstream in(argv[1]);
    in = fopen( argv[1] ,"r");
    if(in==NULL){
    	perror("Error opening file:");
    	exit(-2);
    }

#ifdef USE_PTHREAD
    //创建线程
    pthread_create(&con, NULL, consumer, (void*)argv[2]);
    pthread_create(&pro, NULL, producer, in);

    //等待线程结束
    pthread_join(pro, 0);
    pthread_join(con, 0);
#else
    while(!feof(in)){
        //生产数据
        buff.size = fread(buff.data,1,MAXSIZE,in);
        //消费数据
        myglobal += num_of_word_in_cstring(buff.data,argv[2],buff.size);

    }
#endif
    //-------------停止计时--------------------
    gettimeofday( &end, NULL );
    int timeuse = 1000000 * ( end.tv_sec - start.tv_sec ) + end.tv_usec -start.tv_usec;

#ifdef USE_PTHREAD
    pthread_cond_destroy(&condc);
    pthread_cond_destroy(&condp);
    pthread_mutex_destroy(&the_mutex);
#endif
    fclose(in);
    //输出统计结果
    printf("\"%s\" appears %d times.\n",argv[2],myglobal);
    //显示花费的时间
    printf("time: %d us\n\n",timeuse);

    return 0;
}
```





## 参考文献

- [1]   《现代操作系统（原书第3版）》 Andrew S.Tanenbaum著，陈向群 马洪兵等译：2.3.6 互斥量 P74-76
- [2]   Linux下多线程(pthread)编程实例 - 游手好弦 信步涂鸦 - 博客频道 -CSDN.NET http://blog.csdn.net/do2jiang/article/details/5527155