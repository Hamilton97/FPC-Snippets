library(sf)
library(arrow)
library(fpcFeatures)

current.dir <- './fpc-join-scores-to-point'
setwd(current.dir)

rds.file <- "./fpc-vv-multi-year-FeatureEngine.RData"

trianed.feature.engine <- readRDS(rds.file)

# transform the feature engine using the training data attr
training.data <- trianed.feature.engine$training.data

# run the fpcFeatures Transformer
df.bspline.fpc <- trianed.feature.engine$transform(
  newdata=training.data,
  location='X_Y',
  date='n_date',
  variable='vv'
)

selected.colnames <- grep(x = colnames(df.bspline.fpc), pattern = "^[0-9]+$", invert = TRUE);
DF.fpc.scores     <- df.bspline.fpc[,selected.colnames];

DF.land.cover <- unique(training.data[,c("X_Y","cDesc")]);

DF.fpc.scores <- merge(
 x  = DF.fpc.scores,
 y  = DF.land.cover,
 by = "X_Y"
);

write.csv(
  DF.fpc.scores,
  "./fpc-vv-multi-year.csv"
)