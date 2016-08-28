# --------------------------------------------------------------------------------------------------
# LICENSE
# --------------------------------------------------------------------------------------------------
# ! # License #
# ! Copyright 2016 Rafael CATROU
# !
# ! Licensed under the Apache License, Version 2.0 (the "License");
# ! you may not use this file except in compliance with the License.
# ! You may obtain a copy of the License at
# !
# !     http://www.apache.org/licenses/LICENSE-2.0
# !
# ! Unless required by applicable law or agreed to in writing, software
# ! distributed under the License is distributed on an "AS IS" BASIS,
# ! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# ! See the License for the specific language governing permissions and
# ! limitations under the License.
# !
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# Base OS + tools
# --------------------------------------------------------------------------------------------------
FROM rafaelcatrou/docker_gnat
MAINTAINER Rafael Catrou <rafael@localhost>

# --------------------------------------------------------------------------------------------------
# STEP 2: Install GHDL based on GCC
# --------------------------------------------------------------------------------------------------
# M4 : Need install m4 tool before configure GCC GMP
# LCOV : Summarise Code coverage information from GCOV
# GCOVR : Manages the compilation of coverage information from gcov
RUN \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y m4 && \
    apt-get install -y lcov && \
    apt-get install -y gcovr && \
    apt-get install -y libgmp-dev

RUN mkdir -p /root/tools/download    
COPY src/build_ghdl_with_gcc.sh /root/tools/download
WORKDIR /root/tools/download
RUN \
    chmod +x build_ghdl_with_gcc.sh && \
    sync && \
    ./build_ghdl_with_gcc.sh

# --------------------------------------------------------------------------------------------------
# STEP 3: Check if STEP 1 + 2 were fine
# --------------------------------------------------------------------------------------------------
ENV PATH /root/tools/ghdl_final/bin:$PATH

RUN mkdir /root/tools/ghdl_check1
COPY src/ghdl_check1 /root/tools/ghdl_check1
WORKDIR /root/tools/ghdl_check1
RUN ./ghdl.bash

# --------------------------------------------------------------------------------------------------
# STEP 4: PYTHON + VUNIT
# --------------------------------------------------------------------------------------------------
# According to the instructions on the following address
# https://github.com/VUnit/vunit.git
# And
# https://vunit.github.io/installing.html
RUN pip install -U vunit_hdl

# --------------------------------------------------------------------------------------------------
# Doxygen
# --------------------------------------------------------------------------------------------------
#RUN \
#    apt-get install -y doxygen && \
#    apt-get install -y doxygen-gui && \
#    apt-get install -y doxygen-doc

# --------------------------------------------------------------------------------------------------
# GraphViz
# --------------------------------------------------------------------------------------------------
#RUN \
#    apt-get install -y graphviz && \
#    apt-get install -y graphviz-doc

# --------------------------------------------------------------------------------------------------
# End
# --------------------------------------------------------------------------------------------------

RUN mkdir /root/work
WORKDIR /root/work

# Define default command
CMD ["zsh"]
