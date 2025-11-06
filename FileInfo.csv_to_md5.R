#!/usr/bin//usr/bin/Rscript --vanilla
  setwd("/wd/")
  system(paste0("find . -not -path '*/#recycle/*' -name  *_FileInfo.csv > FileInfo_files.txt 2> md5verify.log"),intern=TRUE)
  Sys.chmod(c("FileInfo_files.txt"), mode = "0666")

  make_md5_from_FileInfo_csv<-function(input){
    out<-sub(".csv$",".md5",input)
    if(!file.exists(out)){
      d<-read.csv(input,header = F)
      write.table(cbind(gsub("-","",d$V2),d$V1),file = out,quote = F,col.names=F,row.names = F)
    }
  }
  files<-readLines(paste0("FileInfo_files.txt"))
  files<-files[!grepl("/[@#]",files)]
  for(i in files) make_md5_from_FileInfo_csv(i)
  print("Done")
  
  # docker pull ghcr.io/zajakin/md5verify && docker run --rm -it --name=md5cover -v /volume3/from_MGI:/wd ghcr.io/zajakin/md5verify /usr/bin/Rscript --vanilla /FileInfo.csv_to_md5.R
  