#!/usr/bin//usr/bin/Rscript --vanilla
  setwd("/wd/")
  if(file.exists("md5verify.log")) unlink(("md5verify.log"))
  cat(date(),file="md5verify.log",append = T)
  system(paste0("(find -not -path '*/#recycle/*' -name md5sum.txt; find -not -path '*/#recycle/*' -name *.md5; find -not -path '*/#recycle/*' -name *_FileInfo.txt) > md5files.txt 2> md5verify.log"),intern=TRUE)
  files<-system(paste0("(find -not -path '*/#recycle/*' -name *q.gz; find -not -path '*/#recycle/*' -name *.bam; find -not -path '*/#recycle/*' -name *.pod5)"),intern=TRUE)
  files<-files[!grepl("/[@#]",files)]
  md5<-readLines("md5files.txt")
  md5<-md5[!grepl("/[@#]",md5)]
  for(i in md5) if(file.exists(i) && file.size(i)>0) files<-files[!files %in% file.path(dirname(i),sub("^./","",as.data.frame(do.call(rbind, strsplit(readLines(i), "  ", fixed = TRUE)))[,2]))]
  cat(files,file="not_covered_by_md5.txt",append = F,sep = "\n")
  system(paste0("find -not -path '*/#recycle/*' -name *.pod5 > pod5files.txt"),intern=TRUE)
  system(paste0("df -h /wd | awk  '/wd/ {print $4}' > space"),intern=TRUE)
  Sys.chmod(c("not_covered_by_md5.txt","md5verify.log","md5files.txt","pod5files.txt","space"), mode = "0666")
  files<-readLines(paste0("md5files.txt"))
  files<-files[!grepl("/[@#]",files)]
  i<-1
  for(i in 1:length(files)){
    f<-files[i]
    cat(paste0("\n",f," ",i,"/",length(files)),file="md5verify.log",append = T)
    print(paste0(f," ",i,"/",length(files)))
    out<- sub(".md5$","_md5_check_report_NAS.txt",sub(".txt$","_md5_check_report_NAS.txt",f) )
    if(!file.exists(out)){
      cat("   Check...",file="md5verify.log",append = T)
      print("Check...")
      system(paste0("cd '",dirname(f),"' && md5sum -c '",basename(f),"' > '",basename(out),"' 2>&1"),intern=TRUE)
    } else if(sub(" .*","",system(paste0("wc -l '",f,"'"),intern=TRUE)) != sub(" .*","",system(paste0("wc -l '",out,"'"),intern=TRUE))){
      cat("   Recheck...",file="md5verify.log",append = T)
      print("Recheck...")
      system(paste0("cd '",dirname(f),"' && md5sum -c '",basename(f),"' > '",basename(out),"' 2>&1"),intern=TRUE)
    }
  }
  system(paste0("find -not -path '*/#recycle/*' -name *_md5_check_report_NAS.txt -exec grep --with-filename -v ' OK$' {} \\; > md5errors.txt 2>&1"),intern=TRUE)
  cat(paste0("\n",date()),file="md5verify.log",append = T)
  system(paste0("df -h /wd | awk  '/wd/ {print $4}' > space"),intern=TRUE)
  Sys.chmod(c("md5verify.log","md5errors.txt","space"), mode = "0666")
  print("Done")
