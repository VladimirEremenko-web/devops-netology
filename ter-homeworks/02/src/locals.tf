locals { 
  platform1 = "netology–${ var.env }–${ var.project }–${ var.role[0] }"
  platform2 = "netology–${ var.env }–${ var.project }–${ var.role[1] }"
}