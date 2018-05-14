# sphinx_liepa_train_docker


Prielaidą, kad vartotojas žino kas yra linux ir docker.

1. Suinstaliuoti docker. (Naudojau legacy toolbelt https://docs.docker.com/toolbox/overview/) 
1. Parsitempti docker kaldi mokymo failus(docker image sveria apie 15GB): 
   ```
   docker pull mondhs/kaldi-liepa-train

   ```
1. sukurti direktoriją - vadinsim *<LIEPA_DIREKTORIJA>*
   1. Linux: */home/VARTOTOJAS/liepa_test*
   1. Windows /c/liepa_test
1. Parsisiųsti vieną iš garsynų: https://drive.google.com/open?id=1HgWjBn7LGFueSIfQe0wN_-sxd6TOPPsI
   1. LIEPA_garsynas_1.10.3.zip - užima zip 1,4GB. Iš archivuotas 1,7GB. yra apie 10h
   1. LIEPA_garsynas_1-56.2.zip - užima zip 5,6GB. Iš archivuotas 8,2GB yra apie 56h
1. ZIP Išskleisti į naują direktoriją: *<LIEPA_DIREKTORIJA>* */LIEPA_garsynas*. Jame turi būti svarbiasios direktorijos:
   1. ./LIEPA_garsynas/config/kaldi/data/
   1. ./LIEPA_garsynas/wav/test/
   1. ./LIEPA_garsynas/wav/train/
1. Paleisti komandą su bash mokymo sąsaja *LIEPA_DIREKTORIJOJE*
   ```
   docker run  -v $(realpath ./LIEPA_garsynas):/data -it mondhs/kaldi-liepa-train bash
   ```
1. docker nueiti į ```cd /opt/kaldi-liepa-train/```
1. paleisti ```sh 01_run.sh```
1. mokymo pabaigoje galima suglaudinti svarbiausias bylas su ```sh 02_archive.sh``` ir persiųsti jas į *<LIEPA_DIREKTORIJA>* */LIEPA_garsynas*
