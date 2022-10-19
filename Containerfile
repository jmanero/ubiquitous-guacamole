FROM golang:1.18 AS build

## Build golang
RUN mkdir -p /work
WORKDIR /work

# COPY pkg ./pkg
COPY go.mod go.sum main.go ./
RUN go build -o lambda -v ./main.go

## Build library tree and ldconfig
RUN mkdir -p /build/etc /build/usr/{bin,lib,lib64,libexec,sbin}
RUN cp /etc/group /etc/passwd /build/etc/
RUN cp /usr/lib64/libc.so.6 /usr/lib64/libpthread.so.0 /usr/lib64/libtinfo.so.6.2 /usr/lib64/ld-linux-x86-64.so.2 /build/usr/lib64/
RUN touch /build/etc/ld.so.conf

## Rebuild linking configuration and symlinks
RUN ldconfig -r /build -v

## Link root directories to /usr/ subdirectories
RUN ln -s /usr/bin /build/bin
RUN ln -s /usr/lib /build/lib
RUN ln -s /usr/lib64 /build/lib64
RUN ln -s /usr/sbin /build/sbin

## Build a Very Small Image™
FROM scratch

COPY --from=build /build /
COPY --from=build /usr/bin/bash /usr/bin/ldd /usr/bin/sh /usr/bin/
COPY --from=build /usr/sbin/ldconfig /usr/sbin/
COPY --from=build /work/lambda .
