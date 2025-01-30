Seek in folder md5sum.txt and *.md5 files, check hash and create *_md5_check_report_NAS.txt.

    docker pull ghcr.io/zajakin/md5verify && docker run --rm --name=md5check -v <working directory>:/wd ghcr.io/zajakin/md5verify
