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
    fastestFee=$(echo "scale=0; ($feeRangeFee+0.999)/1" | bc)
    echo -e "当前实时gas为: $fastestFee"
    
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
    if [ $newMaxFeeRate -le 1000 ]; then
        echo -e "基本不存在小于1000的情况。小于1000就不打:$newMaxFeeRate"
        continue
    fi 
    echo -e "实际给的gas为: $newMaxFeeRate"
    command="yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5 --fee-rate $newMaxFeeRate"
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
