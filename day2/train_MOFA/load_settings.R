suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(SingleCellExperiment))
suppressPackageStartupMessages(library(scater))
suppressPackageStartupMessages(library(MOFA2))

matrix.please <- function(x) {
  m<-as.matrix(x[,-1])
  rownames(m)<-x[[1]]
  m
}

################
## Define I/O ##
################

io <- list()
io$basedir <- "/Users/ricard/data/scnmt_gastrulation"
io$gene_metadata <- "/Users/ricard/data/ensembl/mouse/v87/BioMart/mRNA/Mmusculus_genes_BioMart.87.txt"
io$sample.metadata <- paste0(io$basedir,"/sample_metadata.txt")
io$met.dir <- paste0(io$basedir,"/met/feature_level")
io$acc.dir <- paste0(io$basedir,"/acc/feature_level")
io$met.stats <- paste0(io$basedir,"/met/stats/samples/sample_stats.txt")
io$acc.stats <- paste0(io$basedir,"/acc/stats/samples/sample_stats.txt")
io$rna.file <- paste0(io$basedir,"/rna/SingleCellExperiment.rds")
io$features  <- paste0(io$basedir, "/features/genomic_contexts")
io$outdir <- "/Users/ricard/data/teaching_heidelberg/mofa"

####################
## Define options ##
####################

opts <- list()

# Define which annotations to look at
opts$met.annos <- c(
  "prom_2000_2000",
  "H3K27ac_distal_E7.5_Mes_intersect12",
  # "H3K27ac_distal_E7.5_Ect_intersect12",
  "H3K27ac_distal_E7.5_End_intersect12"
)

opts$acc.annos <- c(
  "prom_2000_2000",
  "H3K27ac_distal_E7.5_Mes_intersect12",
  # "H3K27ac_distal_E7.5_Ect_intersect12",
  "H3K27ac_distal_E7.5_End_intersect12"
)


opts$rename.annos <- c(
  "prom_2000_2000"="Promoters",
  "prom_200_200"="Promoters",
  "H3K27ac_distal_E7.5_Mes_intersect12"="Enhancers",
  "H3K27ac_distal_E7.5_Ect_intersect12"="Enhancers",
  "H3K27ac_distal_E7.5_End_intersect12"="Enhancers"
)


# Define which stage and lineages to look at 
opts$lineages <- c(

  # E5.5
  # "E4.5_Epiblast",
  # "E5.5_Visceral_endoderm",
  
  # E5.5
  # "E5.5_Epiblast",
  # "E5.5_Visceral_endoderm",
  
  # E6.5
  # "E6.5_Epiblast",
  # "E6.5_Primitive_Streak",
  # "E6.5_Visceral_endoderm",
  # "E6.5_Mesoderm",
  
  # E7.5
  # "E7.5_Epiblast",
  # "E7.5_Primitive_Streak",
  "E7.5_Ectoderm",
  "E7.5_Endoderm",
  "E7.5_Mesoderm"
  # "E7.5_Visceral_endoderm"
)
# Filtering options for methylation
opts$met_min.CpGs <- 1        # minimum number of CpG sites per feature
opts$met_min.cells <- 50      # minimum number of cells per feature (per stage)
opts$met_nfeatures <- 1500    # maximum number of features per view (filter based on variance)

# Filtering options for accessibility
opts$acc_min.GpCs <- 5        # minimum number of GpC sites per feature
opts$acc_min.cells <- 50      # minimum number of cells per feature (per stage)
opts$acc_nfeatures <- 1500    # maximum number of features per view (filter based on variance)

# Filtering options for RNA
opts$rna_min.cdr <- 0.25      # Remove genes with cellular detection rate smaller than opts$min.cdr
opts$rna_ngenes <- 2500       # maximum number of genes (filter based on variance)

# Deefine cell type colors
opts$colors <- c(
  "Epiblast"="grey70",
  "Mesoderm"="#CD3278",
  "Primitive Streak"="sandybrown",
  "Endoderm"="#43CD80",
  "Ectoderm"="steelblue",
  "ExE Endoderm"="#E066FF"
)

# Define which cells to use
tmp <- fread(io$sample.metadata) %>% 
  .[,stage_lineage:=paste(stage,lineage10x_2,sep="_")] %>%
  .[pass_rnaQC==TRUE] %>%
  .[lineage10x!="Visceral_endoderm"] %>%
  # .[lineage10x!="Parietal_endoderm"] %>%
  .[stage_lineage%in%opts$lineages]
opts$met_cells <- tmp %>% .[pass_metQC==T,id_met]
opts$rna_cells <- tmp %>% .[pass_rnaQC==T,id_rna]
opts$acc_cells <- tmp %>% .[pass_accQC==T,id_acc]


##########################
## Load sample metadata ##
##########################

sample_metadata <- fread(io$sample.metadata) %>%
  .[,c("sample","id_rna","id_met","id_acc", "plate", "pass_rnaQC", "pass_metQC", "pass_accQC", "stage", "lineage10x","lineage10x_2")] %>%
  # .[stage=="E7.5" & lineage10x=="Visceral_endoderm",lineage10x_2:="Visceral_endoderm"] %>%
  .[,lineage10x_2:=stringr::str_replace_all(lineage10x_2,"_"," ")] %>%
  # .[lineage10x_2=="Visceral endoderm",lineage10x_2:="ExE Endoderm"] %>%
  .[,stage_lineage:=paste(stage,lineage10x_2,sep="_")] %>%
  .[id_met%in%opts$met_cells | id_rna%in%opts$rna_cells | id_acc%in%opts$acc_cells]

###########################
## Load feature metadata ##
###########################

# Load genomic annotations
feature_metadata.met <- lapply(opts$met.annos, function(n) 
  fread(sprintf("%s/%s.bed.gz",io$features,n), showProgress=F)
) %>% rbindlist %>% setnames(c("chr","start","end","strand","id","anno")) %>%
  .[,genomic_location:=sprintf("chr%s:%s-%s",chr,start,end)]

feature_metadata.acc <- lapply(opts$acc.annos, function(n) 
  fread(sprintf("%s/%s.bed.gz",io$features,n), showProgress=F)
) %>% rbindlist %>% setnames(c("chr","start","end","strand","id","anno")) %>%
  .[,genomic_location:=sprintf("chr%s:%s-%s",chr,start,end)]

# Remove duplicated entries
feature_metadata.met <- feature_metadata.met[!duplicated(feature_metadata.met$genomic_location)]
feature_metadata.acc <- feature_metadata.acc[!duplicated(feature_metadata.acc$genomic_location)]

