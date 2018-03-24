suppressMessages(library("optparse"))
suppressMessages(library("sequenza"))
option_list = list(
  make_option(c("--seqz_file"), type="character", default=NULL, 
              help="seqz.gz file name", metavar="character"),
    make_option(c("-o", "--output_dir"), type="character", default=".", 
              help="output folder path [default= %default]", metavar="character"), 
    make_option(c("-s", "--sample_name"), type="character", default=".", 
          help="sample name", metavar="character") 

); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);


if (is.null(opt$seqz_file) | is.null(opt$sample_name)){
  print_help(opt_parser)
  stop("--seqz_file and --sample_name is required.\n", call.=FALSE)
}


# Import Sequenza Datat
data = sequenza.extract(file=opt$seqz_file)


# Start fitting
data_fit = sequenza.fit(data)


# Save result
sequenza.results(sequenza.extract=data,cp.table=data_fit, sample.id=opt$sample_name, out.dir=opt$output_dir)

print('Done')

