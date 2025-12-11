#!/usr/bin//usr/bin/Rscript --vanilla
  setwd("/wd/")
  files<-system(paste0("(find -not -path '*/#recycle/*' -name *q.gz; find -not -path '*/#recycle/*' -name *.bam; find -not -path '*/#recycle/*' -name *.pod5)"),intern=TRUE)
  files<-files[!grepl("/[@#]",files)]
  md5<-system(paste0("find -not -path '*/#recycle/*' -name md5sum.txt; find -not -path '*/#recycle/*' -name *.md5; find -not -path '*/#recycle/*' -name *_FileInfo.txt"),intern=TRUE)
  # md5<-readLines("md5files.txt")
  md5<-md5[!grepl("/[@#]",md5)]
  # md5<-gsub("^/wd",".",md5)
  for(i in md5) if(file.exists(i) && file.size(i)>0) files<-files[!files %in% file.path(dirname(i),sub("^./","",as.data.frame(do.call(rbind, strsplit(readLines(i), "  ", fixed = TRUE)))[,2]))]
  cat(files,file="not_covered_by_md5.txt",append = F,sep = "\n")
  Sys.chmod(c("not_covered_by_md5.txt","md5files.txt"), mode = "0666")

  for(i in unique(sub("/.*","",sub("^./","",files)))){ # tar: Auto_user_SN2-20-IJ-2-11-12-13-14-16042014_44_015: file changed as we read it
    # system(paste0("cd '",i,"' && md5sum `find -type f \\( -not -path '*/#recycle/*' -not -name md5sum.txt -not -name NAS_generated.md5 -not -name *_md5_check_report_NAS.txt \\)` > NAS_generated.md5"),intern=TRUE)
    system(paste0("cd '",i,"' && find -type f -not -name NAS_generated.md5 -not -name *_md5_check_report_NAS.txt -exec md5sum '{}' \\; > NAS_generated.md5"),intern=TRUE)
    # system(paste0("cd '",i,"' && find -type f -not -name NAS_generated.md5 -not -name *_md5_check_report_NAS.txt -exec md5sum '{}' \\; > NAS_generated.md5 && cd .. && tar cf - '",i,"' | gzip -f9 > '",i,"'.tar.gz"),intern=TRUE)
  }
  # docker pull ghcr.io/zajakin/md5verify && docker run --rm -it --name=md5cover -v /volume3/from_MGI:/wd ghcr.io/zajakin/md5verify /usr/bin/Rscript --vanilla /not_covered_by_md5.R
  # find -type f \( -not -name NAS_generated.md5 -not -name *_md5_check_report_NAS.txt \) -exec md5sum '{}' \; > NAS_generated.md5
  
  files<-system(paste0("find -type f -not -path '*/#recycle/*' -not -name *q.gz -not -name *.bam -not -name *.pod5"),intern=TRUE)
  # files<-readLines("notseqfiles.txt")
  files<-files[!grepl("/[@#]",files)]
  for(i in md5) if(file.size(i)>0) files<-files[!files %in% file.path(dirname(i),sub("^./","",as.data.frame(do.call(rbind, strsplit(readLines(i), "  ", fixed = TRUE)))[,2]))]
  cat(files,file="not_covered_by_md5_notseqfiles.txt",append = F,sep = "\n")
  write.table(table(sub(".*\\.","",files)),file = "not_covered_by_md5_notseqfiles.csv")
  Sys.chmod(c("not_covered_by_md5_notseqfiles.txt","not_covered_by_md5_notseqfiles.csv"), mode = "0666")
  
  print("Done")
  