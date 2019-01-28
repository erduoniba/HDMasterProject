//
//  GetQRID.c
//  midea
//
//  Created by midea on 16/6/23.
//  Copyright © 2016年 Midea. All rights reserved.
//

#include "GetQRID.h"
#include <stdio.h>
#include <string.h>
#import <objc/runtime.h>
static unsigned char confusion_key[] = {
    22, 11, 34, 5, 19, 27, 4, 20,
    35, 3, 15, 21, 16, 26, 8, 37,
    33, 6, 31, 29, 28, 39, 14, 36,
    32, 9, 25, 18, 10, 17, 38, 30,
    24, 7, 13, 2, 12, 1, 40, 23,
};

static char  encode_map[]={
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,/*-*/62,/*.*/63,-1,
    /*0*/26,/*1*/27,/*2*/28,/*3*/29,/*4*/30,/*5*/31,/*6*/32,/*7*/33,/*8*/34,/*9*/35,-1,-1,-1,-1,-1,-1,
    -1,0,/*B*/1,/*C*/2,/*D*/3,/*E*/4,/*F*/5,/*G*/6,/*H*/7,/*I*/8,/*J*/9,/*K*/10,/*L*/11,/*M*/12,/*N*/13,/*O*/14,
    /*P*/15,/*Q*/16,/*R*/17,/*S*/18,/*T*/19,/*U*/20,/*V*/21,/*W*/22,/*X*/23,/*Y*/24,/*Z*/25,-1,-1,-1,-1,-1,
    -1,/*a*/36,/*b*/37,/*c*/38,/*d*/39,/*e*/40,/*f*/41,/*g*/42,/*h*/43,/*i*/44,/*j*/45,/*k*/46,/*l*/47,/*m*/48,/*n*/49,/*o*/50,
    /*p*/51,/*q*/52,/*r*/53,/*s*/54,/*t*/55,/*u*/56,/*v*/57,/*w*/58,/*x*/59,/*y*/60,/*z*/61
};
static char  decode_map[]={
 			'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
 			'0','1','2','3','4','5','6','7','8','9',
 			'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
 			'-','.'
};
static unsigned char PC_1[] = {
    57, 49, 41, 33, 25, 17, 9,
    1, 58, 50, 42, 34, 26, 18,
    10, 2, 59, 51, 43, 35, 27,
    19, 11, 3, 60, 52, 44, 36,
    63, 55, 47, 39, 31, 23, 15,
    7, 62, 54, 46, 38, 30, 22,
    14, 6, 61, 53, 45, 37, 29,
    21, 13, 5, 28, 20, 12, 4
};
static unsigned char PC_2[] = {
    14, 17, 11, 24, 1, 5, 3, 28,
    15, 6, 21, 10, 23, 19, 12, 4,
    26, 8, 16, 7, 27, 20, 13, 2,
    41, 52, 31, 37, 47, 55, 30, 40,
    51, 45, 33, 48, 44, 49, 39, 56,
    34, 53, 46, 42, 50, 36, 29, 32
};
static unsigned char IP[] = {
    58, 50, 42, 34, 26, 18, 10, 2,
    60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6,
    64, 56, 48, 40, 32, 24, 16, 8,
    57, 49, 41, 33, 25, 17, 9, 1,
    59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5,
    63, 55, 47, 39, 31, 23, 15, 7
};
static unsigned char IP_1[] = {
    40, 8, 48, 16, 56, 24, 64, 32,
    39, 7, 47, 15, 55, 23, 63, 31,
    38, 6, 46, 14, 54, 22, 62, 30,
    37, 5, 45, 13, 53, 21, 61, 29,
    36, 4, 44, 12, 52, 20, 60, 28,
    35, 3, 43, 11, 51, 19, 59, 27,
    34, 2, 42, 10, 50, 18, 58, 26,
    33, 1, 41, 9, 49, 17, 57, 25
};
static unsigned char E[] = {
    32, 1, 2, 3, 4, 5,
    5, 4, 6, 7, 8, 9,
    10, 11, 10, 11, 12, 13,
    13, 12, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21,
    22, 21, 22, 23, 24, 25,
    23, 25, 26, 27, 28, 29,
    28, 29, 30, 31, 32, 1
};
static unsigned char P[] = {
    16, 7, 20, 21, 29, 12, 28, 17,
    1, 15, 23, 26, 5, 18, 31, 10,
    2, 8, 24, 14, 32, 27, 3, 9,
    19, 13, 30, 6, 22, 11, 4, 25
};
static unsigned char S1[][16] = {
    {14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7},
    {0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8},
    {4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0},
    {15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13}
};

static unsigned char S2[][16] = {
    {15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10},
    {3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5},
    {0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15},
    {13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9}};

static unsigned char S3[][16] = {
    {10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8},
    {13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1},
    {13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7},
    {1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12}};

static unsigned char S4[][16] = {
    {7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15},
    {13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9},
    {10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4},
    {3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14}
};

static unsigned char S5[][16] = {
    {2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9},
    {14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6},
    {4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14},
    {11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3}
};

static unsigned char S6[][16] = {
    {12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11},
    {10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8},
    {9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6},
    {4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13}
};
static unsigned char S7[][16] = {
    {4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1},
    {13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6},
    {1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2},
    {6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12}
};
static unsigned char S8[][16] = {
    {13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7},
    {1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2},
    {7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8},
    {2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11}
};


char K[16][48];
int get_value_key(char *src,char *value,char* key)
{
    if(strlen(src)!=sizeof(confusion_key)) return 0;
    for(int i=0;i<32;i++){
        value[i]=src[confusion_key[i]-1];
    }
    for(int i=0;i<8;i++)
        key[i]=src[confusion_key[32+i]-1];
    return 1;
}
int char2bin(char src,char* result)
{
    int idx=encode_map[src];
    for(int i=5;i>=0;i--)
    {
        result[5-i]=((idx>>i)&1?'1':'0');
    }
    return 1;
}
int str2bin(char* src,char* result)
{
    for(int i=0;i<strlen(src);i++)
    {
        if(!char2bin(src[i],result+i*6)) return 0;
    }
    return 1;
}
int bin2char(char* src,char* result)
{
    char idx=0;
    for(int i=0;i<6;i++){
        idx|=((src[i]-'0')<<(5-i));
    }
    result[0]=decode_map[idx];
    return 1;
}
int bin2str(char* src,char* result)
{
    for(int i=0;i<strlen(src)/6;i++)
    {
        if(!bin2char(src+i*6,result+i)) return 0;
    }
    return 1;
    
}
int key2bin(char* src,char* result)
{
    int ridx=0;
    for(int i=0;i<strlen(src);i++)
    {
        for(int j=0;j<8;j++)
        {
            result[ridx++]=((src[i]>>j)&1?'1':'0');
        }
    }
    return 1;
}

/**
 * ∏˘æ›√‹‘ø≤˙…˙16◊È◊”√‹‘ø
 * <p/>
 * ◊”√‹‘ø≤˙…˙πÊ‘Ú£∫
 * 1. 64Œª≥ı ºKeyæ≠π˝Àı–°ªªŒª??6Œª£¨∆Ω∑÷≥…C0,D0∏˜’º28??
 * 2. C0£¨D0æ≠π˝—≠ª∑ªªŒª
 * 3. Ω´—≠ª∑ªªŒª∫ÛµƒC0,D0∫œ≤¢??6??
 * 4. ¿©¥ÛªªŒª??4Œª£¨≤˙…˙◊”√‹??
 * 5. ÷ÿ∏¥16¥Œ£¨≤˙…˙16◊È◊”√‹‘ø
 * <p/>
 * ◊¢“‚??6¥Œ—≠ª∑◊Û“∆∞¥“‘œ¬πÊ‘Ú
 * 2,  1, 2,  2, 2, 2, 1,  2, 1, 2, 2,  2, 1, 2, 2,  2
 *
 * @param key
 * @return
 */
int generatekey(char* key) {
    char keyPC_1[56];
    //56bitÀı–°ªªŒª
    for (int i = 0; i < 56; i++) {
        keyPC_1[i] = key[PC_1[i] - 1];
    }
    //??C0 D0
    char keyPC_1_C0[28]={0};
    char keyPC_1_D0[28]={0};
    for (int i = 0; i < 27; i++) {
        keyPC_1_C0[i] = keyPC_1[i + 1];
    }
    //????—≠ª∑◊Û“∆
    keyPC_1_C0[27] = keyPC_1[0];
    for (int i = 0; i < 27; i++) {
        keyPC_1_D0[i] = keyPC_1[29 + i];
    }
    keyPC_1_D0[27] = keyPC_1[28];
    
    for (int cycle = 0; cycle < 16; cycle++) {
        switch (cycle) {
            case 1:
            case 6:
            case 8:
            case 12:
            {
                char a1 = keyPC_1_C0[0];
                for (int i = 0; i < 27; i++) {
                    keyPC_1_C0[i] = keyPC_1_C0[i + 1];
                }
                keyPC_1_C0[27] = a1;
                char b1 = keyPC_1_D0[0];
                for (int i = 0; i < 27; i++) {
                    keyPC_1_D0[i] = keyPC_1_D0[1 + i];
                }
                keyPC_1_D0[27] = b1;
                break;
            }
            default:
            {
                char c1 = keyPC_1_C0[0];
                char d1 = keyPC_1_C0[1];
                for (int i = 0; i < 26; i++) {
                    keyPC_1_C0[i] = keyPC_1_C0[i + 2];
                }
                keyPC_1_C0[26] = c1;
                keyPC_1_C0[27] = d1;
                char e1 = keyPC_1_D0[0];
                char f1 = keyPC_1_D0[1];
                for (int i = 0; i < 26; i++) {
                    keyPC_1_D0[i] = keyPC_1_D0[2 + i];
                }
                keyPC_1_D0[26] = e1;
                keyPC_1_D0[27] = f1;
                break;
            }
        }
        char keyPC_2[56]={0};
        for (int i = 0; i < 28; i++) {
            keyPC_2[i] = keyPC_1_C0[i];
        }
        for (int i = 0; i < 28; i++) {
            keyPC_2[i + 28] = keyPC_1_D0[i];
        }
        char K1[48]={0};
        //Ω¯––Àı–°ªªŒª—°‘Ò
        for (int i = 0; i < 48; i++) {
            K1[i] = keyPC_2[PC_2[i] - 1];
        }
        for (int i = 0; i < 48; i++) {
            K[cycle][i] = K1[i];
        }
    }
    
    return 1;
}
void pafi(char* per,int* value,int len)
{
    printf("%s={",per);
    for(int i=0;i<len;i++){
        printf("%d,",value[i]);
        if(!(i+1)%32)
            printf("\n");
    }
    printf("}\n");
}


void paf(char* per,char* value,int len)
{
    printf("%s={",per);
    for(int i=0;i<len;i++){
        printf("%c,",value[i]);
        if(!(i+1)%32)
            printf("\n");
    }
    printf("}\n");
}

int block_encrpty(char* src,char* key,char *result){
    //≥ı ºªªŒª
    char changedPosData[64]={0};
    for (int i = 0; i < 64; i++) {
        changedPosData[i] = src[IP[i] - 1];
    }
    //ªÒµ√L0 R0
    char L0_v[32]={0};
    char R0_v[32]={0};
    char R1_v[32]={0};
    char *L0=L0_v;
    char *R0=R0_v;
    char *R1=R1_v;
    for (int i = 0; i < 32; i++) {
        L0[i] = changedPosData[i];
    }
    for (int i = 0; i < 32; i++) {
        R0[i] = changedPosData[32 + i];
    }
    /*paf("changedPosData",changedPosData,64);
     paf("L0",L0,32);
     paf("R0",R0,32);
     */
    
    //—≠ª∑ Æ¡˘¥Œº”??
    for (int cycle = 0; cycle < 16; cycle++) {
        char R0_E[48]={0};
        for (int i = 0; i < 48; i++) {
            R0_E[i] = R0[E[i] - 1];
        }
        char A[48]={0};
        //º”√‹Ω‚√‹π˝≥Ãø…??
        for (int i = 0; i < 48; i++) {
            A[i] = R0_E[i] == K[15 - cycle][i] ? '0' : '1';
        }
        int binaryA[48]={0};
        for (int i = 0; i < 48; i++) {
            binaryA[i] = (A[i]=='1')?1:0;
        }
        /*printf("cycle %d\n",cycle);
         paf("A",A,48);
         pafi("binaryA",binaryA,48);
         */
        int s1 = S1[binaryA[0] * 2 + binaryA[5]][binaryA[1] * 8 + binaryA[2] * 4 + binaryA[3] * 2 + binaryA[4]];
        int s2 = S2[binaryA[6] * 2 + binaryA[11]][binaryA[7] * 8 + binaryA[8] * 4 + binaryA[9] * 2 + binaryA[10]];
        int s3 = S3[binaryA[12] * 2 + binaryA[17]][binaryA[13] * 8 + binaryA[14] * 4 + binaryA[15] * 2 + binaryA[16]];
        int s4 = S4[binaryA[18] * 2 + binaryA[23]][binaryA[19] * 8 + binaryA[20] * 4 + binaryA[21] * 2 + binaryA[22]];
        int s5 = S5[binaryA[24] * 2 + binaryA[29]][binaryA[25] * 8 + binaryA[26] * 4 + binaryA[27] * 2 + binaryA[28]];
        int s6 = S6[binaryA[30] * 2 + binaryA[35]][binaryA[31] * 8 + binaryA[32] * 4 + binaryA[33] * 2 + binaryA[34]];
        int s7 = S7[binaryA[36] * 2 + binaryA[41]][binaryA[37] * 8 + binaryA[38] * 4 + binaryA[39] * 2 + binaryA[40]];
        int s8 = S8[binaryA[42] * 2 + binaryA[47]][binaryA[43] * 8 + binaryA[44] * 4 + binaryA[45] * 2 + binaryA[46]];
        int b = (s1 << 28) + (s2 << 24) + (s3 << 20) + (s4 << 16) + (s5 << 12) + (s6 << 8) + (s7 << 4) + s8;
        
        char binaryB[32]={0};
        for(int i=0;i<32;i++){
            binaryB[i]=(b>>(31-i))&1?'1':'0';
        }
        char P_B[32]={0};
        for (int i = 0; i < 32; i++) {
            P_B[i] = binaryB[P[i] - 1];
        }
        for (int i = 0; i < 32; i++) {
            R1[i] = P_B[i] == L0[i] ? '0' : '1';
        }
        L0 = R0;
        R0 = R1;
        R1 = L0;
    }
    char lastLR [64]={0};
    for (int i = 0; i <32; i++) {
        lastLR[i] = R0[i];
    }
    for (int i = 0; i < 32; i++) {
        lastLR[32 + i] = L0[i];
    }
    char lastLR_IP_1[64]={0};
    for (int i = 0; i < 64; i++) {
        lastLR_IP_1[i] = lastLR[IP_1[i] - 1];
    }
    for(int i=0;i<64;i++){
        result[i]=lastLR_IP_1[i];
    }
    return 1;
}
char * getQRID(const char * cd,char * finally){
    if(strlen(cd)==22)
    {
        
        strcpy (finally,"000000");
        strcat (finally,cd);
        strcat (finally,"0000");
        printf("000000%s0000",cd);
        return finally;
    }
    char value[33]={0};
    char key[9]={0};
    int getkey=get_value_key(cd,value,key);
    if(!getkey)
    {
        printf("c:%s->err\n",cd);
        return NULL;
    }
    char bin[32*6+1]={0};
    int tobin=str2bin(value,bin);
    char binkey[65]={0};
    int result=key2bin(key,binkey);
    generatekey(binkey);

    char encrypt[193]={0};
    block_encrpty(bin,binkey,encrypt);
    block_encrpty(bin+64,binkey,encrypt+64);
    block_encrpty(bin+128,binkey,encrypt+128);
    
    //char finally[33]={0};
    bin2str(encrypt,finally);
    printf("c:%s->%s\n",cd,finally);
    return finally;
}
