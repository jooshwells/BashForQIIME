// Joshua Wells
// File Renamer for QIIME2
// Written June 6th, 2024
// Contact at jo907377@ucf.edu if bugs occur.

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main()
{
    char ogfile[109]; // original file being read
    char newfile[34];
    int len = 0;

    scanf("%s", ogfile); // read name of file
    
    for(int i = 84; i <= 99; i++) {
        newfile[i-84] = ogfile[i];
    }

    strcat(newfile, "_L001_");
    if(ogfile[102] == '1') strcat(newfile, "R1");
    if(ogfile[102] == '2') strcat(newfile, "R2");

    strcat(newfile, "_001.fastq");
    len = strlen(newfile);

    printf("%s", newfile);
    return 0;
}