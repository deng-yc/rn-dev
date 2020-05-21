FROM ubuntu:20.04

#set default build arguments
ARG SDK_VERSION=sdk-tools-linux-4333796.zip
ARG NDK_VERSION=20.0.5594570
ARG NODE_VERSION=12.x

# set default environment variables
ENV ADB_INSTALL_TIMEOUT=10
ENV ANDROID_HOME=/opt/android
ENV ANDROID_SDK_HOME=${ANDROID_HOME}
ENV ANDROID_NDK=${ANDROID_HOME}/ndk/$NDK_VERSION

ENV PATH=${ANDROID_NDK}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:/opt/buck/bin/:${PATH}

# Install system dependencies
RUN apt update -qq && apt install -qq -y --no-install-recommends \
    apt-transport-https \
    curl \
    build-essential \
    file \
    git \
    openjdk-8-jdk \
    gnupg2 \
    python \
    openssh-client \
    unzip \
    && rm -rf /var/lib/apt/lists/*;


# install nodejs and yarn packages from nodesource and yarn apt sources
RUN echo "deb https://deb.nodesource.com/node_${NODE_VERSION} stretch main" > /etc/apt/sources.list.d/nodesource.list \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && apt-get update -qq \
    && apt-get install -qq -y --no-install-recommends nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

# Full reference at https://dl.google.com/android/repository/repository2-1.xml
# download and unpack android
RUN curl -sS https://dl.google.com/android/repository/${SDK_VERSION} -o /tmp/sdk.zip \
    && mkdir ${ANDROID_HOME} \
    && unzip -q -d ${ANDROID_HOME} /tmp/sdk.zip
