# sphinx_liepa_train_docker


Prielaidą, kad vartoojas žino kas yra linux ir docker.

1. Parsitempti docker kaldi mokymo failus: 
   ```
   docker pull mondhs/kaldi-liepa-train

   ```
1. sukurti direktoriją */home/VARTOTOJAS/liepa_test* - vadinsim *LIEPA_DIREKTORIJA*
1. Parsisiųsti vieną iš garsynų: https://drive.google.com/open?id=1HgWjBn7LGFueSIfQe0wN_-sxd6TOPPsI
   1. LIEPA_garsynas_1.10.zip - užima zip 1,3GB. Iš archivuotas 1,6GB. yra apie 10h
   1. LIEPA_garsynas_1-44.zip - užima zip 5GB. Iš archivuotas 7,5GB
1. Išskleisti */home/VARTOTOJAS/liepa_test/LIEPA_garsynas*. Jame turi būti svarbiasios direktorijos:
   1. ./LIEPA_garsynas/kaldi_data/
   1. ./LIEPA_garsynas/test_repo/
   1. ./LIEPA_garsynas/train_repo/
1. Paleisti komandą su bash mokymo sąsaja *LIEPA_DIREKTORIJOJE*
   ```
   docker run  -v $(realpath ./LIEPA_garsynas):/data -it mondhs/kaldi_liepa_train bash
   ```
1. docker nueiti į ```cd :/opt/kaldi-liepa-train/```
1. paleisti ```sh 01_run.sh```
1. mokymo pabaigoje galima suglaudinti svarbiausias bylas su ```sh 02_archive.sh``` ir persiųsti jas į */home/VARTOTOJAS/liepa_test/LIEPA_garsynas*
