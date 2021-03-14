FROM debian:buster as builder
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    musl-tools ca-certificates curl file build-essential autoconf \
    automake autotools-dev libtool xutils-dev && \
    rm -rf /var/lib/apt/lists/*
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- --default-toolchain nightly -y
RUN /root/.cargo/bin/rustup target add x86_64-unknown-linux-musl && \
    /root/.cargo/bin/rustup target add x86_64-unknown-linux-gnu && \
    /root/.cargo/bin/rustup target add aarch64-apple-darwin && \
    /root/.cargo/bin/rustup target add aarch64-unknown-linux-musl
WORKDIR /usr/src/greenring
COPY . .
RUN /root/.cargo/bin/cargo +nightly build --release

FROM debian:buster-slim
RUN mkdir /app
WORKDIR /app
ENV PORT=8080 RUST_LOG=info RUST_BACKTRACE=1
ENV ROCKET_PORT=${PORT}
COPY --from=builder /usr/src/greenring/target/release/greenring /app/greenring
CMD ["/app/greenring"]
