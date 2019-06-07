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
    int last_access_time;
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}

void simulate(int associativity, int cache_size, int block_size, string filename)
{
    unsigned int tag, index, x;

    int offset_bit = (int)log2(block_size);
    int index_bit = (int)log2(cache_size / block_size / associativity);
    int line = (cache_size >> (offset_bit)) / associativity;

    // cout<<"offset_bit: "<<offset_bit<<" index_bit: "<<index_bit<<" tag_bit: "<<32 - offset_bit - index_bit;

    // we need 2d-array as a set associativity version cache
    cache_content **cache = new cache_content*[line];

    for(int i = 0; i < line; i++)
        cache[i] = new cache_content[associativity];

    for(int i = 0; i < line; i++)
        for(int j = 0; j < associativity; j++){
            cache[i][j].v = false;
            cache[i][j].tag = 0;
            cache[i][j].last_access_time = 0;
        }
    
    FILE *fp = fopen(filename.c_str(), "r");  // read file
    
    int hit = 0, miss = 0;
    int total_access = 0;
    
    while(fscanf(fp, "%x", &x) != EOF)
    {
        total_access++;

        // cout << hex << x << " ";
        index = (x >> offset_bit) & (line - 1);
        tag = x >> (index_bit + offset_bit);
        bool isMiss = 1;
        
        for(int set = 0; set < associativity; set++){
            if(cache[index][set].v && cache[index][set].tag == tag) {
                cache[index][set].last_access_time = total_access;
                hit++;
                isMiss = 0;
                break;
            }
        }
        
        if(isMiss) {
            miss++;
            int min_time = total_access;
            int replace_index = 0;
            
            // find the empty or lru slot
            for(int set = 0; set < associativity; set++) {
                if(cache[index][set].last_access_time < min_time) {
                    min_time = cache[index][set].last_access_time;
                    replace_index = set;
                }
            }
            
            cache[index][replace_index].v = true;
            cache[index][replace_index].tag = tag;
            cache[index][replace_index].last_access_time = total_access;
        }
    }
    fclose(fp);
    cout << "set: " << associativity << " ,cache_size: " << setw(4) << cache_size/K << "K, ";
    cout << "cache line: " << setw(4) << line << ", " << "miss rate: " << setw(10) << (double)miss / (miss + hit) * 100 << "% ,";
    // total_bit = num_block * (block_size_bit + tag_bit + valid_bit) * associativity
    int tag_bit = 32 - offset_bit - index_bit;
    int total_bit = (1 << index_bit) * ( 8 * block_size + tag_bit + 1) * associativity;
    cout << "total_bit: " << total_bit << '\n';

    for(int i = 0; i < line; i++)
        delete [] cache[i];
    delete [] cache;
}

int main()
{
    string cache_file[2] = {"LU.txt", "RADIX.txt"};
    for(int read = 0; read <= 1; read++){
        cout << "file: " << cache_file[read] << '\n';
        for(int i = 1; i <= 32; i *= 2) {
            for(int set = 1; set <= 8; set *= 2){
                simulate(set, i * K, 64, cache_file[read]);
            }
        }
    }
}