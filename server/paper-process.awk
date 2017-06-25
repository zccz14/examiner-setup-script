# awk script for paper formating

# define option mapping
BEGIN {
  opt["A"] = 1; opt[1] = "A";
  opt["B"] = 2; opt[2] = "B";
  opt["C"] = 3; opt[3] = "C";
  opt["D"] = 4; opt[4] = "D";
  opt["E"] = 5; opt[5] = "E";
  opt["F"] = 6; opt[6] = "F";
  opt["G"] = 7; opt[7] = "G";
  opt["Q"] = "Q"
}

# process each line and assign the related option to variable paper
/^[0-9]/ {
  max_ind = $1 > max_ind ? $1 : max_ind
  cur_ind = $1
  cur_op = $2
  $1=$2 = ""
  paper[cur_ind][opt[cur_op]] = $0
}

# render the HTML tag lists
END {
  for(i=1;i<=max_ind;i++){
    print("<div class='question'>")
    printf("\t<div><b>%d.</b> %s</div>\n", i, paper[i]["Q"]);
    for(o=1;paper[i][o];o++){
      printf("\t<div><b>%s</b> %s<div>\n", opt[o], paper[i][o])
    }
    print("\t<hr/>\n</div>")
  }
}