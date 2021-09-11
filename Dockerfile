FROM centos:latest
MAINTAINER Tony_Hsu

USER root

ENV ANDROID_SDK_TOOLS_VERSION="6858069" \
    ANDROID_SDK_ROOT="/opt/android-sdk-linux" \
    ANDROID_HOME="/opt/android-sdk-linux" \
    JAVA_HOME="/usr/lib/jvm/jre-1.8.0-openjdk" \
    JRE_HOME="/usr/lib/jvm/jre" \
    CLASSPATH="/usr/lib/jvm/jre-1.8.0-openjdk/lib/tools.jar"



# 安装常用命令
RUN yum install -y curl \
    && yum install -y wget \
    && yum install -y zip \
    && yum install -y unzip \
    && yum install -y tar \
    && yum install -y lsof \
    && yum install -y java-1.8.0-openjdk \
    && yum install -y java-1.8.0-openjdk-devel \
    && yum install -y git \
    && yum install -y tzdata

#设置工作目录
WORKDIR /home


RUN java -version


RUN cd /opt \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip -O android-commandline-tools.zip \
    && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && unzip -q android-commandline-tools.zip -d /tmp/ \
    && mv /tmp/cmdline-tools/ ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm android-commandline-tools.zip && ls -la ${ANDROID_SDK_ROOT}/cmdline-tools/latest/

ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/



# 安装需要的platforms和build-tools版本
RUN yes | sdkmanager --licenses

RUN touch /root/.android/repositories.cfg

# Emulator and Platform tools
RUN yes | sdkmanager "emulator" "platform-tools"


RUN yes | sdkmanager --update --channel=3

RUN yes | sdkmanager "platforms;android-30"
RUN yes | sdkmanager "platforms;android-29"
RUN yes | sdkmanager "build-tools;30.0.3"
RUN yes | sdkmanager "build-tools;29.0.3"



#Time
ENV TW=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TW /etc/localtime && echo $TW > /etc/timezone

RUN mkdir -p /tmp 
WORKDIR /tmp

#ENTRYPOINT ["./entrypoint.sh"]
#CMD ["./gradlew assembleRelease"]


