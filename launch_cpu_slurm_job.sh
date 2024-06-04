#!/bin/bash
 
d=`date +%Y-%m-%d`
j_name=${1}

resource=$2
cmd=$3
cuda_visible_devices=$4
num_celebs=$5

hdd=/data/healthy-ml/scratch/vinithms/projects/MACE-Update
j_dir=$hdd/slurm/logs/$d/${j_name}
 
mkdir -p $j_dir/scripts
 
# build slurm script
mkdir -p $j_dir/log
echo "#!/bin/bash
#SBATCH --job-name=${j_name}
#SBATCH --output=${j_dir}/log/%j.out
#SBATCH --error=${j_dir}/log/%j.err
#SBATCH --cpus-per-task=80
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --nodes=1
#SBATCH --time=7-00:00
#SBATCH --partition=healthyml
#SBATCH --qos=healthyml-main
 
bash ${j_dir}/scripts/${j_name}.sh
" > $j_dir/scripts/${j_name}.slrm
 
# build bash script
echo -n "#!/bin/bash
$cmd $cuda_visible_devices $num_celebs
" > $j_dir/scripts/${j_name}.sh 
 
sbatch $j_dir/scripts/${j_name}.slrm