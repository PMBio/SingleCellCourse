SAMPLE_FOLDER=data/ST8059048
mkdir -p data
mkdir -p $SAMPLE_FOLDER
mkdir -p $SAMPLE_FOLDER/spatial
curl 'https://cell2location.cog.sanger.ac.uk/tutorial/mouse_brain_visium_data/rawdata/ST8059048/filtered_feature_bc_matrix.h5' > $SAMPLE_FOLDER/filtered_feature_bc_matrix.h5
curl 'https://cell2location.cog.sanger.ac.uk/tutorial/mouse_brain_visium_data/rawdata/ST8059048/spatial/scalefactors_json.json' > $SAMPLE_FOLDER/spatial/scalefactors_json.json
curl 'https://cell2location.cog.sanger.ac.uk/tutorial/mouse_brain_visium_data/rawdata/ST8059048/spatial/tissue_hires_image.png' > $SAMPLE_FOLDER/spatial/tissue_hires_image.png
curl 'https://cell2location.cog.sanger.ac.uk/tutorial/mouse_brain_visium_data/rawdata/ST8059048/spatial/tissue_positions_list.csv' > $SAMPLE_FOLDER/spatial/tissue_positions_list.csv
curl 'https://cell2location.cog.sanger.ac.uk/tutorial/mouse_brain_visium_data/rawdata/ST8059048/spatial/tissue_lowres_image.png' > $SAMPLE_FOLDER/spatial/tissue_lowres_image.png