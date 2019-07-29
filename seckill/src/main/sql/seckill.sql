use seckill;
show tables;
DROP TABLE IF EXISTS `seckill`;
DROP TABLE IF EXISTS `seckill_order`;
DROP TABLE IF EXISTS `success_killed`;
-- 创建秒杀商品表
CREATE TABLE `seckill`(
                          `seckill_id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
                          `title` varchar (1000) DEFAULT NULL COMMENT '商品标题',
                          `image` varchar (1000) DEFAULT NULL COMMENT '商品图片',
                          `price` decimal (10,2) DEFAULT NULL COMMENT '商品原价格',
                          `cost_price` decimal (10,2) DEFAULT NULL COMMENT '商品秒杀价格',
                          `stock_count` bigint DEFAULT NULL COMMENT '剩余库存数量',
                          `start_time` timestamp NOT NULL DEFAULT '1970-02-01 00:00:01' COMMENT '秒杀开始时间',
                          `end_time` timestamp NOT NULL DEFAULT '1970-02-01 00:00:01' COMMENT '秒杀结束时间',
                          `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          PRIMARY KEY (`seckill_id`),
                          KEY `idx_start_time` (`start_time`),
                          KEY `idx_end_time` (`end_time`),
                          KEY `idx_create_time` (`end_time`)
) CHARSET=utf8 ENGINE=InnoDB COMMENT '秒杀商品表';

-- 创建秒杀订单表
CREATE TABLE `seckill_order`(
                                `seckill_id` bigint NOT NULL COMMENT '秒杀商品ID',
                                `money` decimal (10, 2) DEFAULT NULL COMMENT '支付金额',
                                `user_phone` bigint NOT NULL COMMENT '用户手机号',
                                `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
                                `state` tinyint NOT NULL DEFAULT -1 COMMENT '状态：-1无效 0成功 1已付款',
                                PRIMARY KEY (`seckill_id`, `user_phone`) /*联合主键，保证一个用户只能秒杀一件商品*/
) CHARSET=utf8 ENGINE=InnoDB COMMENT '秒杀订单表';
select * from seckill;
select * from seckill_order;
truncate table seckill;
truncate table seckill_order;
insert into seckill(seckill_id, title, price, cost_price, stock_count, start_time, end_time, create_time)
values(1000,'小米9',2999,999,3,'2019-07-31','2019-08-01','2019-07-16');
insert into seckill(seckill_id, title, price, cost_price, stock_count, start_time, end_time, create_time)
values(2000,'iphone Xs',8999,2999,1,'2019-07-31','2019-08-01','2019-07-16');
insert into seckill(seckill_id, title, price, cost_price, stock_count, start_time, end_time, create_time)
values(3000,'华为P30 pro',5999,1999,2,'2019-07-31','2019-08-01','2019-07-16');
insert into seckill(seckill_id, title, price, cost_price, stock_count, start_time, end_time, create_time)
values(1001,'华为P20 pro',999,1999,2,'2019-07-22','2019-08-01','2019-07-16');









CREATE TABLE seckill(
                        `seckill_id` BIGINT NOT NUll AUTO_INCREMENT COMMENT '商品库存ID',
                        `name` VARCHAR(120) NOT NULL COMMENT '商品名称',
                        `number` int NOT NULL COMMENT '库存数量',
                        `start_time` TIMESTAMP  NOT NULL COMMENT '秒杀开始时间',
                        `end_time`   TIMESTAMP   NOT NULL COMMENT '秒杀结束时间',
                        `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        PRIMARY KEY (seckill_id),
                        key idx_start_time(start_time),
                        key idx_end_time(end_time),
                        key idx_create_time(create_time)
)ENGINE=INNODB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8 COMMENT='秒杀库存表';

-- 初始化数据
INSERT into seckill(name,number,start_time,end_time)
VALUES
('1000元秒杀iphone6',100,'2016-01-01 00:00:00','2016-01-02 00:00:00'),
('800元秒杀ipad',200,'2016-01-01 00:00:00','2016-01-02 00:00:00'),
('6600元秒杀mac book pro',300,'2016-01-01 00:00:00','2016-01-02 00:00:00'),
('7000元秒杀iMac',400,'2016-01-01 00:00:00','2016-01-02 00:00:00');

-- 秒杀成功明细表
-- 用户登录认证相关信息(简化为手机号)
CREATE TABLE success_killed(
                               `seckill_id` BIGINT NOT NULL COMMENT '秒杀商品ID',
                               `user_phone` BIGINT NOT NULL COMMENT '用户手机号',
                               `state` TINYINT NOT NULL DEFAULT -1 COMMENT '状态标识:-1:无效 0:成功 1:已付款 2:已发货',
                               `create_time` TIMESTAMP NOT NULL COMMENT '创建时间',
                               PRIMARY KEY(seckill_id,user_phone),/*联合主键*/
                               KEY idx_create_time(create_time)
)ENGINE=INNODB DEFAULT CHARSET=utf8 COMMENT='秒杀成功明细表';



-- 秒杀执行存储过程
DELIMITER $$ --界定符修改
-- 定义存储过程
-- 参数: in 输入参数; out 输出参数
-- row_count():返回上一条修改类型sql(delete,insert,update)的影响行数
-- row_count: 0:未修改数据; >0:表示修改的行数; <0:sql错误/未执行修改sql
CREATE PROCEDURE `seckill`.`execute_seckill`
  (in v_seckill_id bigint,
   in v_phone bigint,
   in v_kill_time timestamp,
   out r_result int)
  BEGIN
    DECLARE insert_count int DEFAULT 0;
    -- 开启事务
    START TRANSACTION;
    -- 记录购买行为
    insert ignore into seckill_order
    (seckill_id,user_phone,create_time)
    values (v_seckill_id,v_phone,v_kill_time);
    -- 获取insert执行结果
    select row_count() into insert_count;
    -- 重复秒杀
    IF (insert_count = 0) THEN
      ROLLBACK;
      set r_result = -1;
    -- 系统异常
    ELSEIF(insert_count < 0) THEN
      ROLLBACK;
      SET R_RESULT = -2;
    ELSE
      -- 执行秒杀，减库存
      update seckill
      set stock_count = stock_count-1
      where seckill_id = v_seckill_id
        and end_time > v_kill_time
        and start_time < v_kill_time
        and stock_count > 0;
      select row_count() into insert_count;
      IF (insert_count = 0) THEN
        ROLLBACK;
        set r_result = 0;
      ELSEIF (insert_count < 0) THEN
        ROLLBACK;
        set r_result = -2;
      ELSE
        COMMIT;
        set r_result = 1;
      END IF;
    END IF;
  END;
$$
-- 存储过程定义结束

-- 查看存储过程定义
show create procedure execute_seckill;
DELIMITER ;
-- 定义变量
set @r_result=-3;
-- 执行存储过程
call execute_seckill(1001,13502178891,now(),@r_result);
-- 获取结果
select @r_result;

-- 存储过程
-- 1:存储过程优化：事务行级锁持有的时间
-- 2:不要过度依赖存储过程
-- 3:简单的逻辑可以应用存储过程
-- 4:QPS:一个秒杀单6000/qps