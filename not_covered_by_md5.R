#!/usr/bin//usr/bin/Rscript --vanilla
  setwd("/wd/")
  system(paste0("(find -not -path '*/#recycle/*' -name *q.gz; find -not -path '*/#recycle/*' -name *.bam; find -not -path '*/#recycle/*' -name *.pod5) > seqfiles.txt"),intern=TRUE)
  files<-readLines("seqfiles.txt")
  files<-files[!grepl("/[@#]",files)]
  md5<-readLines("md5files.txt")
  md5<-md5[!grepl("/[@#]",md5)]
  md5<-gsub("^/wd",".",md5)
  for(i in md5) files<-files[!files %in% file.path(dirname(i),read.table(i,header=F)[,2])]
  cat(files,file="not_covered_by_md5.txt",append = F,sep = "\n")
  Sys.chmod(c("not_covered_by_md5.txt","seqfiles.txt"), mode = "0666")
  print("Done")

  for(i in unique(sub("/.*","",sub("^./","",files)))){ # system(paste0("cd ",i," && find -type f -not -path '*/#recycle/*' -not -name md5sum.txt -exec md5sum '{}' \\; > md5sum.txt"),intern=TRUE)
    # dir(i,recursive = T)
    system(paste0("cd ",i," && md5sum `find -type f \\( -not -path '*/#recycle/*' -not -name md5sum.txt \\) ` > md5sum.txt"),intern=TRUE)
  }
  # docker pull ghcr.io/zajakin/md5verify && docker run --rm -it --name=md5cover -v /volume3/from_MGI:/wd ghcr.io/zajakin/md5verify /usr/bin/Rscript --vanilla /not_covered_by_md5.R
  