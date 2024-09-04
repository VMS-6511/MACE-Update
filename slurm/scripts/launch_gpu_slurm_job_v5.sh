#!/bin/bash
 
d=`date +%Y-%m-%d`
j_name=${1}

resource=$2
cmd=$3
cuda_visible_devices=$4
algo_name=$5
change=$6
orig_task=$7
orig_config=$8
finetune_algo=$9
finetune_task=${10}
finetune_config=${11}
port_number=${12}
prompts_csv=${13}


hdd=/data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness
j_dir=$hdd/slurm/logs/$d/${j_name}
 
mkdir -p $j_dir/scripts
 
# build slurm script
mkdir -p $j_dir/log
echo "#!/bin/bash
#SBATCH --job-name=${j_name}
#SBATCH --output=${j_dir}/log/%j.out
#SBATCH --error=${j_dir}/log/%j.err
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --gres=${resource}
#SBATCH --nodes=1
#SBATCH --time=1-00:00
#SBATCH --partition=healthyml
#SBATCH --qos=healthyml-main
#SBATCH --account=healthy-ml
 
bash ${j_dir}/scripts/${j_name}.sh
" > $j_dir/scripts/${j_name}.slrm
 
# build bash script
echo -n "#!/bin/bash
$cmd $cuda_visible_devices $algo_name $change $orig_task $orig_config $finetune_algo $finetune_task $finetune_config $port_number $prompts_csv
" > $j_dir/scripts/${j_name}.sh 
 
sbatch $j_dir/scripts/${j_name}.slrm