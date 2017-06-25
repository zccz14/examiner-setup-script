# awk script for paper formating

BEGIN {
  opt["A"]=1; opt[1]="A";
  opt["B"]=2; opt[2]="B";
  opt["C"]=3; opt[3]="C";
  opt["D"]=4; opt[4]="D";
  opt["E"]=5; opt[5]="E";
  opt["F"]=6; opt[6]="F";
  opt["G"]=7; opt[7]="G";
  opt["Q"]="Q"
}

/^[0-9]/ {
  max_ind=$1 > max_ind ? $1 : max_ind
  cur_ind=$1
  cur_op=$2
  $1=$2=""
  paper[cur_ind][opt[cur_op]]=$0
}

END {
  print max_ind > "./paper/paper-total-count"
  for(i=1;i<=max_ind;i++){
    filename=sprintf("./paper/q-%d", i);
    printf("Question: %d\n", i) > filename
    printf("  %s\n", paper[i]["Q"]) >> filename
    for(o=1;paper[i][o];o++){
      printf("  %s. %s\n", opt[o], paper[i][o]) >> filename
    }
  }
}