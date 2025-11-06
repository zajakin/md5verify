


  function merge_checksums {
    OUTPUT_FILE="${1:-merged_checksums.md5}"
    rm -f "$OUTPUT_FILE"
    for f in *.md5; do
    [[ -e "$f" ]] || { echo "No .md5 files found."; exit 1; }
    echo "Merging: $f"
    cat "$f" >> "$OUTPUT_FILE"
    echo " " `basename -- "$f" .md5` >> "$OUTPUT_FILE"
    done
  }

  