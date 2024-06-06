// Joshua Wells
// File Renamer for QIIME2
// Written June 6th, 2024
// Contact at jo907377@ucf.edu if bugs occur.

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main()
{
    char ogfile[107]; // original file being read

    // was supposed to be final file, but something in the 
    // string editing was messed up so i needed an extra string
    char finalfile[58] = {'\0'}; 
    
    // extra string to finish renaming
    char finalfinalfile[34] = {'\0'};
    
    scanf("%s", ogfile); // read name of file

    // remove leading characters up to "UCF"
    for(int i = 48; i < 88; i++)
    {
        finalfile[i-48] = ogfile[i];
    }
    
    // get whatever number is next to R (either 1 or 2) in the file name
    char rNum = ogfile[90];

    // add on extra characters to the end accordingly
    if(rNum == '1')
        strcat(finalfile, "_L001_R1_001.fastq");
    if(rNum == '2')
        strcat(finalfile, "_L001_R2_001.fastq");

    // trim off extra characters missed on first trim
    for(int i = 24; i < 58; i++)
    {
        finalfinalfile[i-24] = finalfile[i];
    }

    // send output to terminal
    printf("%s", finalfinalfile);
    return 0;
}