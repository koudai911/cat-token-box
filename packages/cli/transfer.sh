#!/bin/bash
read -p "请输入想要转移的gas: " input_gas
read -p "请输入想要转移的钱包地址: " input_address
read -p "请输入想要转移的数量: " input_num
if [ $input_gas -gt 0 ]; then
    sed -i "s/\"maxFeeRate\": [0-9]*/\"maxFeeRate\": $input_gas/" ~/cat-token-box/packages/cli/config.json
fi
  
newMaxFeeRate=$input_gas
echo -e "实际给的gas为: $newMaxFeeRate"
command="yarn cli send -i c468e99ac3b533e503eac5ccf4f0e3362772f80cead8b7f71d802305d02f73d0_0 $input_address $input_num --fee-rate $newMaxFeeRate"
$command



