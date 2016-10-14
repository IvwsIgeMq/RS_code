# 下面的变量可以在shell 的环境变量里面指定。
# 也可以象下面这样在 Makefile 里面指定。
 CC=gcc                                          # 编译器
 CFLAGS=-Wall  -g           # 编译器参数
 LD=gcc                                          # 连接器参数
  LDFLAGS= $(LIBS)        # 连接器参数
 # DEPENDFLAG=-MM                   # 生成依赖关系文件的参数
 # INCLUDES=-Idir1 -Idir2               # 指明包含外部头文件的目录
 # LIBS=-lrt  -lm -lpthread                        # 指明引用外部的库文件

CFLAGS:=$(CFLAGS) $(INCLUDES)
LDFLAGS:=$(LDFLAGS) $(LIBS)


#指明项目中,包含源程序的所有的子目录。
SRCDIRS=.
#指明最终生成的可执行文件的名称
PROGRAMS=test


#下面的部分一般不用改动
#从所有子目录中得到源代码的列表
SRCS=$(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.c))


#得到源代码对应的目标文件的列表
OBJS=$(SRCS:.c=.o)

#得到源代码对应的依赖关系文件的列表
#依赖关系文件就是一个目标文件依赖于
#哪些头文件和源程序，依赖关系是自动
#生成的，并且用include语句包含在Makefile中
# DEPENDS=$(SRCS:.c=.d)


#指明默认目标是生成最终可执行文件。
all: $(PROGRAMS)


#生成依赖关系文件
%.d:%.c
	$(CC) $(DEPENDFLAG) $(CFLAGS)  $< |\
	sed "s?\\(.*\\):?$(basename $<).o $(basename $<).d :?g" \
	> $@ || $(RM) $@

$(PROGRAMS): $(OBJS)
		$(CC) $(LDFLAGS) -o $@ $(filter %.o ,$+)


# 包含入依赖关系文件
include $(DEPENDS)


# 删除生成的中间文件
clean:
	rm $(OBJS) $(DEPENDS) $(PROGRAMS)
