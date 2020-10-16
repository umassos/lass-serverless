FROM python:3.6

WORKDIR /app
ADD binaryalert/ binaryalert/
RUN pip3 install -r binaryalert/requirements.txt

RUN pip3 install Flask nose

RUN wget -q https://github.com/VirusTotal/yara/archive/v3.8.0.tar.gz && \
    tar -xzf v3.8.0.tar.gz && \
    cd yara-3.8.0 && \
    ./bootstrap.sh && \
    ./configure && \
    make && \
    make install

RUN rm -rf v3.8.0.tar.gz yara-3.8.0

RUN apt update && apt install -y poppler-utils libarchive-dev

RUN wget -q https://github.com/BayshoreNetworks/yextend/archive/1.6.tar.gz && \
    tar -xzf 1.6.tar.gz && \
    cd yextend-1.6 && \
    # Manually: modify main.cpp, line 473 to hardcode the yara version to 3.8
    sed -i '473s/.*/\tdouble yara_version = 3.8;/' main.cpp && \
    sed -i "46i#ifndef TRUE\n#define TRUE true\n#endif\n\n#ifndef FALSE\n#define FALSE false\n#endif\n" libs/bayshore_yara_wrapper.c && \
    ./build.sh && \
    mv yextend /app

RUN rm -rf 1.6.tar.gz yextend-1.6

RUN wget -q https://github.com/upx/upx/releases/download/v3.94/upx-3.94-amd64_linux.tar.xz && \
    tar -xf upx-3.94-amd64_linux.tar.xz && \
    mv upx-3.94-amd64_linux/upx /app

RUN rm -rf upx-3.94-amd64_linux.tar.xz upx-3.94-amd64_linux.tar.xz

ADD test_files/ test_files/
ADD main.py main.py

ENTRYPOINT [ "python3", "-u", "main.py" ]
