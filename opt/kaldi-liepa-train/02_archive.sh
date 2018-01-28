#!/bin/bash

tar -czvf kaldi_log-$(date +%Y%m%dT%H%M%S).tar.gz exp | mv kaldi_log-* /data/archive/
rm -rf exp mfcc data/train/spk2utt data/train/cmvn.scp data/train/feats.scp data/train/split1 data/test/spk2utt data/test/cmvn.scp data/test/feats.scp data/test/split1 data/local/lang data/lang data/local/tmp data/local/dict/lexiconp.txt


