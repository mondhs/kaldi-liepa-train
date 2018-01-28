#! /usr/bin/env python3
# -*- coding: utf-8 -*-
'''
@author: Mindaugas Greibus
'''
import  re
import wave
import os

def transform_transcription_file(transcription_path, output_file_map, total_duration_map, repo_type):
    with open(transcription_path, 'r') as input_file:
        for line in input_file:
            line=re.sub(r'<sil[\+\w]+>',r'',line)
            line=re.sub(r'<s> *<sil>',r'<s>',line)
            line=re.sub(r'<sil> *</s>',r'</s>',line)
            line=re.sub(r'( *<sil>)+',r'',line)
            line=re.sub(r'(\s+)',r' ',line)
            text =""
            file_name=""

            m = re.search('<s>(.*)</s>\s*\((.*)\)',line)
            if(not m):
                print(">>>> " + line)
                raise ValueError('Cannot parse the line: ' + line)
            #line text
            text = m.group(1)
            ## find correct file path
            file_name = m.group(2)
            m = re.search('-(.+)$',file_name)
            if(not m):
                print(">>>> " + line)
                raise ValueError('Dir not found: ' + file_name)
            dir_name=m.group(1)

            wav_name = "../{}_repo/{}/{}.wav".format(repo_type,dir_name, file_name)
            ##Calculate duration
            audio = wave.open(wav_name)
            duration = float(audio.getnframes()) / audio.getframerate()
            audio.close()

            kaldi_path = "./liepa_audio/{}/{}/{}.wav".format(repo_type,dir_name, file_name)

            total_duration_map["total"] += duration

            out = '{},{},{}\n'.format(duration, text, kaldi_path)
            print(out)

            if(duration>1):
                #if shorter as given time training is crashing is code dump
                total_duration_map[repo_type] += duration
                output_file_map[repo_type].write(out)
            else:
                total_duration_map["short"] += duration


src_dir = "../"

test_transcription_path = os.path.join(src_dir, "./target/liepa_test.transcription")
train_transcription_path = os.path.join(src_dir, "./target/liepa_train.transcription")


with open('./target/liepa_test.csv', 'w') as test_repo_csv, \
     open('./target/liepa_train.csv', 'w') as train_repo_csv:
    output_file_map = {"test":test_repo_csv, "train": train_repo_csv}
    total_duration_map = { "test":0, "train":0,"short":0, "total":0}
    transform_transcription_file(test_transcription_path, output_file_map, total_duration_map, "test")
    transform_transcription_file(train_transcription_path, output_file_map, total_duration_map, "train")

    print(total_duration_map)

# cp sphinx_files/etc/liepa.dic ./target/data/local/dict/lexicon.txt
# inserto to ./target/data/local/dict/lexicon.bak "!SIL sil\n<UNK> spn\n"
