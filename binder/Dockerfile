
FROM jupyter/base-notebook:python-3.9.12

# Switch to root user
USER root
ENV DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC"
ENV ParaView_Version="v5.10.1"

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install --no-install-recommends -y \
    dbus-x11 \
    firefox \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme \
    curl \
    xscreensaver \
    git \
    cmake \
    build-essential \
    libgl1-mesa-dev \
    libxt-dev \
    qt5-default \
    libqt5x11extras5-dev \
    libqt5help5 \
    qttools5-dev \
    qtxmlpatterns5-dev-tools \
    libqt5svg5-dev \
    python3-dev \
    python3-numpy \
    libopenmpi-dev \
    libtbb-dev \
    ninja-build \
    && apt-get remove -y gnome-screensaver  \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /

# Install and Build ParaView
RUN git clone https://gitlab.kitware.com/paraview/paraview.git && \
    mkdir paraview_build && \ 
    cd paraview && \
    git checkout ${ParaView_version} && \
    git submodule update --init --recursive && \
    cd ../paraview_build && \
    cmake -GNinja -DCMAKE_PREFIX_PATH=$QT_DIR/lib/cmake -DPARAVIEW_USE_PYTHON=ON -DPARAVIEW_USE_MPI=ON -DVTK_SMP_IMPLEMENTATION_TYPE=TBB -DCMAKE_BUILD_TYPE=Release ../paraview && \
    ninja
