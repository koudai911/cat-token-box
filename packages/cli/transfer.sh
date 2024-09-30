#!/bin/bash
yarn cli wallet export
yarn cli wallet address
yarn cli wallet balances
read -p "请输入想要转移的gas: " input_gas
read -p "请输入想要转移的钱包地址: " input_address
read -p "请输入想要转移的数量: " input_num
if [ $input_gas -gt 0 ]; then
    sed -i "s/\"maxFeeRate\": [0-9]*/\"maxFeeRate\": $input_gas/" ~/cat-token-box/packages/cli/config.json
fi
  
newMaxFeeRate=$input_gas
echo -e "实际给的gas为: $newMaxFeeRate"
command="yarn cli send -i 59d566844f434e419bf5b21b5c601745fcaaa24482b8d68f32b2582c61a95af2_0 $input_address $input_num --fee-rate $newMaxFeeRate"
$command



