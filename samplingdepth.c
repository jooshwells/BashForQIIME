#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main()
{
    FILE * fp;
    fp = fopen("feature-table.tsv", "r");

    char arr[300];
    char* token;
    char* endptr;
    int cols=0;
    fgets(arr, 300, fp);
    fgets(arr, 300, fp);

    token = strtok(arr, "\t");
    while(token != NULL)
    {
        token = strtok(NULL, "\t");

        if(token != NULL)
        {
            if(strstr(token, "UCF") != NULL)
            {
                cols++;
            }
        }
    }
    double frequencies[cols];

    while(fgets(arr, 300, fp) != NULL)
    {
        token = strtok(arr, "\t");

        for(int i = 0; i < cols; i++)
        {
            token = strtok(NULL, "\t");
            frequencies[i] += strtod(token, &endptr);
        }
    }

    double min = 10000000;

    for(int i = 0; i < cols; i++)
    {
        if(frequencies[i] < min) min = frequencies[i];
    }
    printf("%.0lf", min);

    fclose(fp);
    return 0;
}