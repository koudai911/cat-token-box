#!/bin/bash

read -p "请输入想要mint的gas,如果为0就实时为当前的gas去打: " input_gas
if [ $input_gas -gt 0 ]; then
    sed -i "s/\"maxFeeRate\": [0-9]*/\"maxFeeRate\": $input_gas/" ~/cat-token-box/packages/cli/config.json
fi
  
while true; do
    newMaxFeeRate=$input_gas
    response=$(curl -s https://mempool.fractalbitcoin.io/api/v1/fees/mempool-blocks)
    feeRangeFee=$(echo $response | jq '.[0].feeRange | .[-3]') # 倒数第四档
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

    echo -e "实际给的gas为: $newMaxFeeRate"
    command="yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5 --fee-rate $newMaxFeeRate"
    $command &

    if [ $? -ne 0 ]; then
        echo "命令执行失败，退出循环"
        exit 1
    fi

    sleep 1
done
