FROM debian:testing-slim
# docker run -it --name=md5verify -v /volume3/seq_202402:/wd debian:testing-slim bash
RUN env DEBIAN_FRONTEND=noninteractive apt-get update && env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends r-base-core
COPY md5verify.R /md5verify.R
CMD ["/usr/bin/Rscript --vanilla /md5verify.R"]
# docker pull ghcr.io/zajakin/md5verify && docker run --rm --name=md5verify -v /volume3/seq_202402:/wd ghcr.io/zajakin/md5verify