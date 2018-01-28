
### Training

* create dir for training ```mkdir -p ./target/data/train/ ./target/data/test/ ./target/data/local/```
* create sphinx transcription files for test and train
* run transform_liepa2csv.py to get 2 csv files
* run ./data_prep.py to get kaldi files




* start docker
* change ```rm -rf data && ln -s /data/kaldi_data/data data```
* run run.sh
