#!/bin/bash
total_num=0
succ_num=0
error_num=0
read -p "请输入想要转移的gas: " input_gas
if [ $input_gas -gt 0 ]; then
    sed -i "s/\"maxFeeRate\": [0-9]*/\"maxFeeRate\": $input_gas/" ~/cat-token-box/packages/cli/config.json
fi
  
while true; do
    newMaxFeeRate=$input_gas
    echo -e "实际给的gas为: $newMaxFeeRate"
   yarn cli send -i c468e99ac3b533e503eac5ccf4f0e3362772f80cead8b7f71d802305d02f73d0_0 bc1pk7n0rqzvvy0puatmgtsq5h53k2jf0p7ttzl84f55um2ja6hdceassw44jn 15 --fee-rate $newMaxFeeRate
    $command
    total_num=$((total_num + 1))
    if [ $? -ne 0 ]; then
        echo "命令执行失败"
        error_num=$((error_num + 1))
    else
        succ_num=$((succ_num + 1))
    fi
    #echo -e "发送次数: $total_num"
    echo -e "发送次数: $total_num，成功次数:$succ_num,失败次数：$error_num"
    sleep 1
done
