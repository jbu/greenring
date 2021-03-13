FROM rust as builder
WORKDIR /usr/src/greenring
COPY . .
RUN cargo build --release


FROM debian:buster-slim
RUN mkdir /app
WORKDIR /app
ENV PORT=8080
COPY --from=builder /usr/src/greenring/target/release/greenring /app/greenring
CMD ["/app/greenring"]
