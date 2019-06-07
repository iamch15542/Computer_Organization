#include <iostream>
#include <stdio.h>
#include <math.h>
#include <string>
#include <iomanip>

using namespace std;

struct cache_content
{
    bool v;
    unsigned int tag;
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


void simulate(int cache_size, int block_size, string filename)
{
    unsigned int tag, index, x;

    int offset_bit = (int)log2(block_size);
    int index_bit = (int)log2(cache_size / block_size);
    int line = cache_size >> (offset_bit);

    cache_content *cache = new cache_content[line];

    for(int j = 0; j < line; j++)
        cache[j].v = false;
    
    FILE *fp = fopen(filename.c_str(), "r");  // read file
    
    int hit = 0, miss = 0;
    
    while(fscanf(fp, "%x", &x) != EOF)
    {
        // cout << hex << x << " ";
        index = (x >> offset_bit) & (line - 1);
        tag = x >> (index_bit + offset_bit);
        if(cache[index].v && cache[index].tag == tag) {
            hit++;
        }
        else
        {
            cache[index].v = true;
            cache[index].tag = tag;
            miss++;
        }
    }
    fclose(fp);
    
    cout << "cache_size: " << setw(4) << cache_size/K << "K, block_size: " << setw(4) << block_size ;
    cout << ", cache line: " << setw(5) << line << ", miss rate: " << setw(10) << (double)miss / (miss + hit) * 100 << "%\n";
    
    delete [] cache;
}
    
int main()
{
    string cache_file[2] = {"ICACHE.txt", "DCACHE.txt"};
    for(int read = 0; read <= 1; read++){
        cout << "file: " << cache_file[read] << '\n';
        for(int i = 4; i <= 256; i *= 4) {
            for(int j = 16; j <= 256; j *= 2) {
                simulate(i * K, j, cache_file[read]);
            }
        }
    }
}
