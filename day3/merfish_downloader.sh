mkdir -p data
mkdir -p data/merfish
curl 'https://s3.amazonaws.com/starfish.data.spacetx/spacejam2/MERFISH_Allen_VISp/Allen_MERFISH_spots_with_anatomy.csv' > data/merfish/Allen_MERFISH_spots_with_anatomy.csv
curl 'https://raw.githubusercontent.com/spacetx-spacejam/data/master/gene_lists/MERFISH_genes.csv' > data/merfish/MERFISH_genes.csv
curl 'https://s3.amazonaws.com/starfish.data.spacetx/spacejam2/MERFISH_Allen_VISp/fixed_1001844875.csv' > data/merfish/fixed_1001844875.csv
curl 'https://raw.githubusercontent.com/spacetx-spacejam/data/master/annotations/Allen_MERFISH_Layers.geojson' > data/merfish/Allen_MERFISH_Layers.geojson
