#!/bin/bash
total_num=0
succ_num=0
error_num=0
read -p "请输入想要mint的gas,如果为0就实时为当前的gas去打: " input_gas
if [ $input_gas -gt 0 ]; then
    sed -i "s/\"maxFeeRate\": [0-9]*/\"maxFeeRate\": $input_gas/" ~/cat-token-box/packages/cli/config.json
fi
  
while true; do
    newMaxFeeRate=$input_gas
    response=$(curl -s https://mempool.fractalbitcoin.io/api/v1/fees/mempool-blocks)
    feeRangeFee=$(echo $response | jq '.[0].feeRange | .[2]') # 倒数第四档
    fastestFee=$(echo "scale=0; ($feeRangeFee*1.1+0.999)/1" | bc)
    
    if [ $fastestFee -le 200 ]; then
        echo -e "小于200,取第三个参数:$fastestFee"
        feeRangeFee=$(echo $response | jq '.[0].feeRange | .[3]') # 倒数第四档
        fastestFee=$(echo "scale=0; ($feeRangeFee*1.1+0.999)/1" | bc)
    fi 
    echo -e "内存池第一个块第2/3个参数实时gas为: $fastestFee"
    
    if [ $newMaxFeeRate -le 0 ]; then
        # 小于等于0
        newMaxFeeRate=$fastestFee
    else
        if [ $fastestFee -gt $newMaxFeeRate ]; then
          echo -e "当前gas高于你要mint的gas，等待机会吧，当前gas为:$fastestFee,设置要mint的gas为:$newMaxFeeRate"
          continue
        fi  
    fi
    newMaxFeeRate=$fastestFee
    
    echo -e "实际给的gas为: $newMaxFeeRate"
    command="yarn cli mint -i 59d566844f434e419bf5b21b5c601745fcaaa24482b8d68f32b2582c61a95af2_0 10 --fee-rate $newMaxFeeRate"
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
