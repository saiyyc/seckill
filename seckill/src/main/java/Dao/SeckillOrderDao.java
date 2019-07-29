package Dao;

import Bean.SeckillOrder;
import org.apache.ibatis.annotations.Param;

public interface SeckillOrderDao {
    /**
     * 插入购买明细,可过滤重复
     * @param seckillId
     * @param userPhone
     * @return 插入的行数
     */
    int SeckillOrder(@Param("seckillId") long seckillId,@Param("userPhone") long userPhone);

    /**
     * 根据id查询SeckillOrder并携带秒杀产品对象实体
     * @param seckillId
     * @return
     */
    SeckillOrder queryByIdWithSeckill(@Param("seckillId") long seckillId,@Param("userPhone")long userPhone);

}
