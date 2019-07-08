#include <iomanip>
#include <iostream>
#include <math.h>
#include <string>
#include <vector>

#define associativity 8

using namespace std;

struct cache_content {
    bool v;
    unsigned int tag;
    int last_access_time;
};

const int K = 1024;
int m, n, p;
unsigned int A_base, B_base, C_base;
FILE *input, *output;

double log2(double n) {
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}

int execution_cycle(int m, int n, int p) {
    int i, j, k;
    int count = 0;
    
    i = 0;
    count += 2; // const4, i = 0
    while(1){
        count+=2; // slt, beq
        if(i == m)
            break;
        j = 0;
        count++; // j = 0
        while(1){
            count+=2; // slt, beq
            if(j == p)
                break;
            k = 0;
            count++; // k = 0
            while(1){
                count+=2; // slt, beq
                if(k == n)
                    break;
                // temp1 = 4(i*p+j) + C[]base
                // temp2 = 4(i*n+k) + A[]base
                // temp3 = 4(k*p+j) + B[]base
                // C[i][j] = C[i][j] + A[i][k]*B[k][j]
                count+=18;
                
                k++;
                count+=2; // k++, j loop_k
            }
            j++;
            count+=2; // j++, j loop_j
        }
        i++;
        count+=2; //i++, j loop_i
    }
    count++; // exit:nop
    return count;
}

void calc_matmul(vector<vector<int>> &A, vector<vector<int>> &B, vector<vector<int>> &C, vector<unsigned int> &memory_addr) {
    for(int i=0;i<m;i++){
        for(int j=0;j<p;j++){
            for(int k=0;k<n;k++){
                memory_addr.push_back(C_base + 4 * (i * p + j)); // lw
                memory_addr.push_back(A_base + 4 * (i * n + k)); // lw
                memory_addr.push_back(B_base + 4 * (k * p + j)); // lw
                memory_addr.push_back(C_base + 4 * (i * p + j)); // sw
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

int memory_1(int cache_size, int block_size, vector<unsigned int> memory_addr) {
    unsigned int tag, index, x;

    int offset_bit = (int)log2(block_size);
    int index_bit = (int)log2(cache_size / block_size / associativity);
    int line = (cache_size >> (offset_bit)) / associativity;

    // we need 2d-array as a set associativity version cache
    cache_content **cache = new cache_content *[line];

    for (int i = 0; i < line; i++)
        cache[i] = new cache_content[associativity];

    for (int i = 0; i < line; i++)
        for (int j = 0; j < associativity; j++) {
            cache[i][j].v = false;
            cache[i][j].tag = 0;
            cache[i][j].last_access_time = 0;
        }

    int total_access = 0;
    int memory_stall = 0;

    for (int i = 0; i < memory_addr.size(); i++) {
        x = memory_addr[i];
    
        total_access++;

        index = (x >> offset_bit) & (line - 1);
        tag = x >> (index_bit + offset_bit);
        bool isMiss = 1;

        for (int set = 0; set < associativity; set++) {
            if (cache[index][set].v && cache[index][set].tag == tag) {
                cache[index][set].last_access_time = total_access;
                isMiss = 0;
                memory_stall += (1 + 2 + 1); // send addr, access cache, send data
                break;
            }
        }

        if (isMiss) {
            int min_time = total_access;
            int replace_index = 0;

            // find the empty or lru slot
            for (int set = 0; set < associativity; set++) {
                if (cache[index][set].last_access_time < min_time) {
                    min_time = cache[index][set].last_access_time;
                    replace_index = set;
                }
            }

            cache[index][replace_index].v = true;
            cache[index][replace_index].tag = tag;
            cache[index][replace_index].last_access_time = total_access;
            
            memory_stall += (1 + 8 * (1 + 2 + 100 + 1) + 2 + 1);
        }
    }
    
    for (int i = 0; i < line; i++)
        delete[] cache[i];
    delete[] cache;
    
    return memory_stall;
}

int memory_2(int cache_size, int block_size, vector<unsigned int> memory_addr) {
    unsigned int tag, index, x;

    int offset_bit = (int)log2(block_size);
    int index_bit = (int)log2(cache_size / block_size / associativity);
    int line = (cache_size >> (offset_bit)) / associativity;

    // we need 2d-array as a set associativity version cache
    cache_content **cache = new cache_content *[line];

    for (int i = 0; i < line; i++)
        cache[i] = new cache_content[associativity];

    for (int i = 0; i < line; i++)
        for (int j = 0; j < associativity; j++) {
            cache[i][j].v = false;
            cache[i][j].tag = 0;
            cache[i][j].last_access_time = 0;
        }

    int total_access = 0;
    int memory_stall = 0;

    for (int i = 0; i < memory_addr.size(); i++) {
        x = memory_addr[i];
    
        total_access++;

        index = (x >> offset_bit) & (line - 1);
        tag = x >> (index_bit + offset_bit);
        bool isMiss = 1;

        for (int set = 0; set < associativity; set++) {
            if (cache[index][set].v && cache[index][set].tag == tag) {
                cache[index][set].last_access_time = total_access;
                isMiss = 0;
                memory_stall += (1 + 2 + 1); // send addr, access cache, send data
                break;
            }
        }

        if (isMiss) {
            int min_time = total_access;
            int replace_index = 0;

            // find the empty or lru slot
            for (int set = 0; set < associativity; set++) {
                if (cache[index][set].last_access_time < min_time) {
                    min_time = cache[index][set].last_access_time;
                    replace_index = set;
                }
            }

            cache[index][replace_index].v = true;
            cache[index][replace_index].tag = tag;
            cache[index][replace_index].last_access_time = total_access;
            
            memory_stall += (1 + (1 + 2 + 100 + 1) + 2 + 1);
        }
    }
    
    for (int i = 0; i < line; i++)
        delete[] cache[i];
    delete[] cache;
    
    return memory_stall;
}

int memory_3(int cache_size, int block_size, int cache_size_1, int block_size_1, vector<unsigned int> memory_addr) {
    unsigned int tag, index, x, tag_1, index_1;

    int offset_bit = (int)log2(block_size);
    int index_bit = (int)log2(cache_size / block_size / associativity);
    int line = (cache_size >> (offset_bit)) / associativity;
    
    int offset_bit_1 = (int)log2(block_size_1);
    int index_bit_1 = (int)log2(cache_size_1 / block_size_1 / associativity);
    int line_1 = (cache_size_1 >> (offset_bit_1)) / associativity;

    // we need 2d-array as a set associativity version cache
    cache_content **cache = new cache_content *[line];
    cache_content **cache_1 = new cache_content *[line_1];

    for (int i = 0; i < line; i++)
        cache[i] = new cache_content[associativity];
    for (int i = 0; i < line_1; i++)
        cache_1[i] = new cache_content[associativity];

    for (int i = 0; i < line; i++)
        for (int j = 0; j < associativity; j++) {
            cache[i][j].v = false;
            cache[i][j].tag = 0;
            cache[i][j].last_access_time = 0;
        }
    for (int i = 0; i < line_1; i++)
        for (int j = 0; j < associativity; j++) {
            cache_1[i][j].v = false;
            cache_1[i][j].tag = 0;
            cache_1[i][j].last_access_time = 0;
        }

    int total_access = 0;
    int total_access_1 = 0;
    int memory_stall = 0;

    for (int i = 0; i < memory_addr.size(); i++) {
        x = memory_addr[i];
    
        total_access++;
        // fprintf(stderr, "L1\n");
        
        index = (x >> offset_bit) & (line - 1);
        tag = x >> (index_bit + offset_bit);
        index_1 = (x >> offset_bit_1) & (line_1 - 1);
        tag_1 = x >> (index_bit_1 + offset_bit_1);
        
        bool isMiss = 1;

        for (int set = 0; set < associativity; set++) {
            if (cache[index][set].v && cache[index][set].tag == tag) {
                cache[index][set].last_access_time = total_access;
                isMiss = 0;
                memory_stall += (1 + 1 + 1); // send addr, access cache, send data
                break;
            }
        }

        if (isMiss) {
            total_access_1++;
            // fprintf(stderr, "L2\n");
        
            bool isMiss_1 = 1;
            
            for (int set = 0; set < associativity; set++) {
                if (cache_1[index_1][set].v && cache_1[index_1][set].tag == tag_1) {
                    cache_1[index_1][set].last_access_time = total_access_1;
                    isMiss_1 = 0;
                    memory_stall += (1 + 4 * (1 + 10 + 1 + 1) + 1 + 1); // send addr, access cache, send data
                    break;
                }
            }
            
            int min_time = total_access;
            int replace_index = 0;
            
            // LRU for L1 cache
            for (int set = 0; set < associativity; set++) {
                if (cache[index][set].last_access_time < min_time) {
                    min_time = cache[index][set].last_access_time;
                    replace_index = set;
                }
            }

            cache[index][replace_index].v = true;
            cache[index][replace_index].tag = tag;
            cache[index][replace_index].last_access_time = total_access;
            
            if (isMiss_1) {
                int min_time = total_access;
                int replace_index = 0;
                // fprintf(stderr, "Mem\n");
                
                // LRU for L1 cache
                for (int set = 0; set < associativity; set++) {
                    if (cache[index][set].last_access_time < min_time) {
                        min_time = cache[index][set].last_access_time;
                        replace_index = set;
                    }
                }
    
                cache[index][replace_index].v = true;
                cache[index][replace_index].tag = tag;
                cache[index][replace_index].last_access_time = total_access;
                
                int min_time_1 = total_access_1;
                int replace_index_1 = 0;
                
                // LRU for L2 cache
                for (int set = 0; set < associativity; set++) {
                    if (cache_1[index_1][set].last_access_time < min_time_1) {
                        min_time_1 = cache_1[index_1][set].last_access_time;
                        replace_index_1 = set;
                    }
                }
    
                cache_1[index_1][replace_index_1].v = true;
                cache_1[index_1][replace_index_1].tag = tag_1;
                cache_1[index_1][replace_index_1].last_access_time = total_access_1;
                
                memory_stall += (1 + 32 * (1 + 100 + 10 + 1) + 4 * (1 + 10 + 1 + 1) + 1 + 1);
            }
        }
    }
    
    for (int i = 0; i < line; i++)
        delete[] cache[i];
    delete[] cache;
    
    for (int i = 0; i < line_1; i++)
        delete[] cache_1[i];
    delete[] cache_1;
    
    return memory_stall;
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("usage: ./simulate_caches [input_filename] [output_filename]\n");
        exit(1);
    }
    
    input = fopen(argv[1], "r");
    output = fopen(argv[2], "w");
    
    fscanf(input, "%x %x %x %d %d %d", &A_base, &B_base, &C_base, &m, &n, &p);
    vector<vector<int>> A(m, vector<int>(n)), B(n, vector<int>(p)), C(m, vector<int>(p, 0));
    vector<unsigned int> memory_addr;
    
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            fscanf(input, "%d", &A[i][j]);
        }
    }
    for(int i=0;i<n;i++){
        for(int j=0;j<p;j++){
            fscanf(input, "%d", &B[i][j]);
        }
    }
    calc_matmul(A, B, C, memory_addr);
    for(int i=0;i<m;i++){
        for(int j=0;j<p;j++){
            fprintf(output, "%d ", C[i][j]);
        }
        fprintf(output, "\n");
    }
    fprintf(output, "%d ", execution_cycle(m, n, p));
    fprintf(output, "%d ", memory_1(1<<9, 4 * 8, memory_addr));
    fprintf(output, "%d ", memory_2(1<<9, 4 * 8, memory_addr));
    fprintf(output, "%d ", memory_3(1<<7, 4 * 4, 1<<12, 4 * 32, memory_addr));
    fclose(input);
    fclose(output);
    
}