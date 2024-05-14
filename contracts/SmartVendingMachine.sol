// SPDX-License-Identifier: GPL-3.0 

pragma
 solidity ^0.8.0;

contract SmartVendingMachine {
    // 定义外卖产品结构体
    struct FoodDelivery {
        uint256 deliveryNumber;
        uint256 deliveryTime;
        uint256 pickupTime;
        address addedBy; // 记录添加者地址
    }

    // 存储外卖产品信息的映射
    mapping(uint256 => FoodDelivery) public deliveries;
    
    // 定义事件，用于记录新外卖产品添加和取货操作
    event NewFoodDeliveryAdded(uint256 indexed deliveryNumber, uint256 deliveryTime, address addedBy);
    event FoodPickedUp(uint256 indexed deliveryNumber, uint256 pickupTime);
    
    // 查询指定编号的外卖产品信息
    function getFoodDelivery(uint256 _deliveryNumber) public view returns (uint256, uint256, uint256, address) {
        FoodDelivery memory delivery = deliveries[_deliveryNumber];
        return (delivery.deliveryNumber, delivery.deliveryTime, delivery.pickupTime, delivery.addedBy);
    }
    
    // 添加新的外卖产品
    function addFoodDelivery(uint256 _deliveryNumber, uint256 _deliveryTime) public {
        // 确保该编号的外卖产品尚未存在
        require(deliveries[_deliveryNumber].deliveryNumber == 0, "Delivery number already exists");
    
        // 创建新的外卖产品结构体并存储
        deliveries[_deliveryNumber] = FoodDelivery({
            deliveryNumber: _deliveryNumber,
            deliveryTime: _deliveryTime,
            pickupTime: 0,
            addedBy: msg.sender
        });
    
        // 触发新外卖产品添加事件
        emit NewFoodDeliveryAdded(_deliveryNumber, _deliveryTime, msg.sender);
    }
    
    // 外卖产品取货操作
    function pickUpFood(uint256 _deliveryNumber) public {
        // 确保外卖产品存在且未被取走
        require(deliveries[_deliveryNumber].deliveryNumber != 0, "Delivery number does not exist");
        require(deliveries[_deliveryNumber].pickupTime == 0, "Food already picked up");
    
        // 确保当前操作者有权限取货
        require(msg.sender == deliveries[_deliveryNumber].addedBy, "You are not authorized to pick up this food");
    
        // 更新外卖产品的取货时间
        deliveries[_deliveryNumber].pickupTime = block.timestamp;
    
        // 触发外卖产品取货事件
        emit FoodPickedUp(_deliveryNumber, block.timestamp);
    }
}