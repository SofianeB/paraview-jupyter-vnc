FROM jupyter/base-notebook:python-3.9.2


USER root

RUN apt-get -y update \
 && apt-get install -y dbus-x11 \
   firefox \
   xfce4 \
   xfce4-panel \
   xfce4-session \
   xfce4-settings \
   xorg \
   curl \
   git \
   xubuntu-icon-theme

# Remove light-locker to prevent screen lock
ARG TURBOVNC_VERSION=2.2.6
RUN wget -q "https://sourceforge.net/projects/turbovnc/files/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb/download" -O turbovnc_${TURBOVNC_VERSION}_amd64.deb && \
   apt-get install -y -q ./turbovnc_${TURBOVNC_VERSION}_amd64.deb && \
   apt-get remove -y -q light-locker && \
   rm ./turbovnc_${TURBOVNC_VERSION}_amd64.deb && \
   ln -s /opt/TurboVNC/bin/* /usr/local/bin/

# apt-get may result in root-owned directories/files under $HOME
RUN chown -R $NB_UID:$NB_GID $HOME

ADD . /opt/install
RUN fix-permissions /opt/install

# Install paraview
WORKDIR /opt

RUN wget -O ParaView-5.10.1.tar.gz "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.10&type=binary&os=Linux&downloadFile=ParaView-5.10.1-MPI-Linux-Python3.9-x86_64.tar.gz"

RUN tar -xzvf ParaView-5.10.1.tar.gz && \
    rm ParaView-5.10.1.tar.gz
    
ENV PATH=$PATH:/opt/ParaView-5.10.1-MPI-Linux-Python3.9-x86_64/bin

ENV LIBGL_ALWAYS_INDIRECT=y

ENV LIBGL_DEBUG_PLUGINS=y

WORKDIR /tmp
RUN curl -L -o virtualgl_2.5.2_amd64.deb 'https://downloads.sourceforge.net/project/virtualgl/2.5.2/virtualgl_2.5.2_amd64.deb?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fvirtualgl%2Ffiles%2F2.5.2&ts=1509495317&use_mirror=auto'
RUN dpkg -i virtualgl_2.5.2_amd64.deb
RUN printf "1\nn\nn\nn\nx\n" | /opt/VirtualGL/bin/vglserver_config

USER $NB_USER
RUN cd /opt/install && \
   conda env update -n base --file environment.yml

ENV RESOURCES=/opt/install/resources

RUN mkdir -p ${HOME}/.local/share/applications ${HOME}/Desktop ${HOME}/.local/share/ ${HOME}/.icons \
    && cp ${RESOURCES}/PARAVIEW.desktop ${HOME}/Desktop/ \
    && cp ${RESOURCES}/PARAVIEW.desktop ${HOME}/.local/share/applications\
    && ln -s ${RESOURCES}/paraview.png ${HOME}/.icons/paraview.png \
    && cp ${RESOURCES}/paraview_launcher.py ${HOME}/.local/share/ 

WORKDIR $HOME/$NB_USER
