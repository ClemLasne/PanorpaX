### Generate consensus repeat library using Repeatmodeler:

```
module load RepeatMasker
module load RepeatModeler #/2.0.1

BuildDatabase -name panorpa yahs.out_scaffolds_final_hicpro_multimapping_matlock_0_13_03_2023.fa -engine ncbi

RepeatModeler -database panorpa -threads 100 -engine ncbi
```
### Mask genome using repeatmasker:
```
module load RepeatMasker

RepeatMasker yahs.out_scaffolds_final_hicpro_multimapping_matlock_0_13_03_2023.fa -lib consensi.fa.classified -pa 40
```
### repeat content in 10000 bp windwos:
```
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy
import seaborn as sns
import matplotlib.patches as mpatches
import os
import pysam
import warnings
warnings.filterwarnings("ignore")
panorpa_repeats=pd.read_csv("~/Repeats_all_classified.out",sep="\s+",header=None,names=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16])
repeat_content_all=[]
binwidth=10000
n=0
for i in ['scaffold_1','scaffold_22','scaffold_2','scaffold_3','scaffold_4','scaffold_5','scaffold_6','scaffold_7','scaffold_8','scaffold_9','scaffold_10','scaffold_11','scaffold_12','scaffold_13','scaffold_14','scaffold_15','scaffold_16','scaffold_17','scaffold_18','scaffold_19','scaffold_20','scaffold_21','scaffold_23','scaffold_24','scaffold_25']:
    n=n+1
    df=panorpa_repeats[panorpa_repeats[5]==i]
    df["START"]=df[6]
    df["FINISH"]=df[7]
    df.sort_values("START", inplace=True)
    df["group"]=(df["START"]>df["FINISH"].shift().cummax()).cumsum()
    result=df.groupby("group").agg({"START":"min", "FINISH": "max"})
    result['length']=result['FINISH']-result['START']
    repeat_content=[0]*max(result['FINISH'])
    for i in np.arange(0,len(result),1):
        for t in np.arange(result['START'][i],result['FINISH'][i],1):
            repeat_content[t]=1
    repeat_content_chr=[]
    for s in np.arange(0,math.ceil(max(result['FINISH'])),10000):
        repeat_content_chr.append(repeat_content[s:s+10000].count(1))
    repeat_content_all.append(repeat_content_chr)
```
plot X-linked vs autosomal:
```
repeat_content=repeat_content_all
plt.figure(figsize=(30, 30))
c="#969696"
e="#ffd92f"
d="black"
plt.boxplot([repeat_content[0]+repeat_content[1]],positions=np.arange(1,2,1),showfliers=False,widths=0.5,notch=True, patch_artist=True,boxprops=dict(facecolor=e, color=d,linewidth=10.0),medianprops=dict(color=d,linewidth=10.0),whiskerprops=dict(color=d,linewidth=10.0),capprops=dict(color=d,linewidth=10.0))
plt.boxplot([repeat_content[2]+repeat_content[3]+repeat_content[4]+repeat_content[5]+repeat_content[6]+repeat_content[7]+repeat_content[8]+repeat_content[9]+repeat_content[10]+repeat_content[11]+repeat_content[12]+repeat_content[13]+repeat_content[14]+repeat_content[15]+repeat_content[16]+repeat_content[17]+repeat_content[18]+repeat_content[19]+repeat_content[20]+repeat_content[21]+repeat_content[22]+repeat_content[23]+repeat_content[24]],widths=0.5,positions=np.arange(2,3,1),showfliers=False,notch=True, patch_artist=True,boxprops=dict(facecolor=c, color=d,linewidth=10.0),medianprops=dict(color=d,linewidth=10.0),whiskerprops=dict(color=d,linewidth=10.0),capprops=dict(color=d,linewidth=10.0))
plt.xticks(fontsize=80)
plt.yticks(fontsize=80)
plt.xlabel('Chromosome',fontsize=80)
plt.ylabel('Repeat content (10000bp windows)',fontsize=80)
l=[repeat_content[2],repeat_content[3],repeat_content[4],repeat_content[5],repeat_content[6],repeat_content[7],repeat_content[8],repeat_content[9],repeat_content[10],repeat_content[11],repeat_content[12],repeat_content[13],repeat_content[14],repeat_content[15],repeat_content[16],repeat_content[17],repeat_content[18],repeat_content[19],repeat_content[20],repeat_content[21],repeat_content[22],repeat_content[23],repeat_content[24]]
flat_list = [item for sublist in l for item in sublist]
plt.hlines(np.median(flat_list),0.5,2.5,color="gray",linestyle='dashed',linewidth=10)
plt.xticks(np.arange(1,3,1), ['X-linked','Autosomal'])
plt.savefig('repeats_x_vs_autosomal.png',bbox_inches='tight')
```
plot all chromosomes:
```
#LINE
plt.figure(figsize=(100, 30))
c="#969696"
e="#ffd92f"
d="black"
plt.boxplot([repeat_content[0],repeat_content[1]],positions=np.arange(1,3,1),showfliers=False,widths=0.5,notch=True, patch_artist=True,boxprops=dict(facecolor=e, color=d,linewidth=10.0),medianprops=dict(color=d,linewidth=10.0),whiskerprops=dict(color=d,linewidth=10.0),capprops=dict(color=d,linewidth=10.0))
plt.boxplot([repeat_content[2],repeat_content[3],repeat_content[4],repeat_content[5],repeat_content[6],repeat_content[7],repeat_content[8],repeat_content[9],repeat_content[10],repeat_content[11],repeat_content[12],repeat_content[13],repeat_content[14],repeat_content[15],repeat_content[16],repeat_content[17],repeat_content[18],repeat_content[19],repeat_content[20],repeat_content[21],repeat_content[22],repeat_content[23],repeat_content[24]],widths=0.5,positions=np.arange(3,26,1),showfliers=False,notch=True, patch_artist=True,boxprops=dict(facecolor=c, color=d,linewidth=10.0),medianprops=dict(color=d,linewidth=10.0),whiskerprops=dict(color=d,linewidth=10.0),capprops=dict(color=d,linewidth=10.0))
plt.xticks(fontsize=80)
plt.yticks(fontsize=80)
plt.xlabel('Chromosome',fontsize=80)
plt.ylabel('Repeat content (10000bp windows)',fontsize=80)
l=[repeat_content[2],repeat_content[3],repeat_content[4],repeat_content[5],repeat_content[6],repeat_content[7],repeat_content[8],repeat_content[9],repeat_content[10],repeat_content[11],repeat_content[12],repeat_content[13],repeat_content[14],repeat_content[15],repeat_content[16],repeat_content[17],repeat_content[18],repeat_content[19],repeat_content[20],repeat_content[21],repeat_content[22],repeat_content[23],repeat_content[24]]
flat_list = [item for sublist in l for item in sublist]
plt.hlines(np.median(flat_list),0.5,25.5,color="gray",linestyle='dashed',linewidth=10)
plt.xticks(np.arange(1,26,1), ['1','22','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','23','24','25'])
plt.savefig('repeats_all_chromosomes.png',bbox_inches='tight')
```
output results tables:
```
X_linked=pd.DataFrame(repeat_content_all[0]+repeat_content_all[1])
X_linked['location']='X_linked'
Autosomal=pd.DataFrame(repeat_content_all[2]+repeat_content_all[3]+repeat_content_all[4]+repeat_content_all[5]+repeat_content_all[6]+repeat_content_all[7]+repeat_content_all[8]+repeat_content_all[9]+repeat_content_all[10]+repeat_content_all[11]+repeat_content_all[12]+repeat_content_all[13]+repeat_content_all[14]+repeat_content_all[15]+repeat_content_all[16]+repeat_content_all[17]+repeat_content_all[18]+repeat_content_all[19]+repeat_content_all[20]+repeat_content_all[21]+repeat_content_all[22]+repeat_content_all[23]+repeat_content_all[24])
Autosomal['location']='autosomal'
mixed=pd.concat([X_linked,Autosomal],ignore_index=True)
mixed = mixed.rename({
          0:'windows'
        }, axis='columns')
mixed=mixed[['location','windows']]
mixed.to_csv('repeats_x_vs_autosomes.txt',index=False,sep='\t')
names=['scaffold_1','scaffold_22','scaffold_2','scaffold_3','scaffold_4','scaffold_5','scaffold_6','scaffold_7','scaffold_8','scaffold_9','scaffold_10','scaffold_11','scaffold_12','scaffold_13','scaffold_14','scaffold_15','scaffold_16','scaffold_17','scaffold_18','scaffold_19','scaffold_20','scaffold_21','scaffold_23','scaffold_24','scaffold_25']
chromosomes=pd.DataFrame(repeat_content_all[0])
chromosomes['location']=names[0]
for i in np.arange(1,25,1):
    chr_i=pd.DataFrame(repeat_content_all[i])
    chr_i['location']=names[i]
    chromosomes=pd.concat([chromosomes,chr_i],ignore_index=True)
chromosomes = chromosomes.rename({
          0:'windows'
        }, axis='columns')
chromosomes=chromosomes[['location','windows']]
chromosomes.to_csv('repeats_all_chromosomes.txt',index=False,sep='\t') 
```

