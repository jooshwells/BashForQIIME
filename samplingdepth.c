#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main()
{
    FILE* fp = fopen("sample-frequency-detail.csv", "r");

    double min = 100000000.0;
    double dep = 0;
    char line[50] = {'\0'};
    char *curdep;
    char *endptr;

    while(fscanf(fp, "%s", line) != EOF) 
    {
        curdep = strtok(line, ","); // skip past the label token

        curdep = strtok(NULL, ","); // This is the sampling depth as a string
        dep = strtod(curdep, &endptr);
        if(dep < min) min = dep;
    }
    printf("%.0lf", min); // display min sampling depth
    fclose(fp);

    return 0;
}