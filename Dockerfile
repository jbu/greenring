FROM rust as builder
WORKDIR /usr/src/greenring
COPY . .
RUN cargo install --path .

FROM busybox
COPY --from=builder /usr/local/cargo/bin/greenring /usr/local/bin/greenring
CMD ["greenring"]
