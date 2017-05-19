#! /usr/bin/env python3

import os
import sys
import glob
import csv
from collections import OrderedDict


def extractText(fileCsvPath='liepa_audio/test/liepa_test.csv'):
    results = {}
    textReader = csv.reader(open(fileCsvPath, encoding='utf-8'))
    for row in textReader:
        fileName=row[2]
        baseName=os.path.basename(fileName).split(os.extsep, 1)[0]
        speaker = baseName.split("_")[-1]
        speakerNum = str(speaker.strip("d")).zfill(3)
        key = speakerNum+"_"+baseName.strip("_"+speaker)
        content=row[1]
        results[key]=[key, fileName ,content.strip(), speakerNum]
    return OrderedDict(sorted(results.items(), key=lambda t: t[0]))


def formatWavScpFileRecord(row):
    return row[0] + " " + row[1]

def formatTextFileRecord(row):
    return row[0] + " " + row[2]

# utils/utt2spk_to_spk2utt.pl data/train/utt2spk > data/train/spk2utt
def formatUtt2spkFileRecord(row):
    return row[0] + " " + row[3]

def extractUtterances(row):
    return row[2]

corpus = set()


with open('data/test/text', 'w') as text_file, open('data/test/wav.scp', 'w') as wav_scp_file, open('data/test/utt2spk', 'w') as utt2spk_file:
    exractedTextMap = extractText('liepa_audio/test/liepa_test.csv')
    wavScpArr = list(map(formatWavScpFileRecord,exractedTextMap.values()))
    textArr = list(map(formatTextFileRecord,exractedTextMap.values()))
    utt2spkArr = list(map(formatUtt2spkFileRecord,exractedTextMap.values()))
    aUtteranceSet = set(map(extractUtterances,exractedTextMap.values()))
    corpus.update(aUtteranceSet)
    text_file.write("\n".join(textArr))
    wav_scp_file.write("\n".join(wavScpArr))
    utt2spk_file.write("\n".join(utt2spkArr))

with open('data/train/text', 'w') as text_file, open('data/train/wav.scp', 'w') as wav_scp_file, open('data/train/utt2spk', 'w') as utt2spk_file:
    exractedTextMap = extractText('liepa_audio/train/liepa_train.csv')
    wavScpArr = list(map(formatWavScpFileRecord,exractedTextMap.values()))
    textArr = list(map(formatTextFileRecord,exractedTextMap.values()))
    utt2spkArr = list(map(formatUtt2spkFileRecord,exractedTextMap.values()))
    aUtteranceSet = set(map(extractUtterances,exractedTextMap.values()))
    corpus.update(aUtteranceSet)
    text_file.write("\n".join(textArr))
    wav_scp_file.write("\n".join(wavScpArr))
    utt2spk_file.write("\n".join(utt2spkArr))


with open('data/local/corpus.txt', 'w') as corpus_file:
    corpus_file.write("\n".join(sorted(corpus)))


#utils/fix_data_dir.sh data/train/
#utils/fix_data_dir.sh data/test/
