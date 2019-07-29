package Dao;

import Bean.Seckill;
import org.apache.ibatis.annotations.Param;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface SeckillDao {
    /**
     *
     * 减库存
     * @param seckillId
     * @param killTime
     * @return 如果影响行数>1,表示更新的记录行数
     */
    int reduceStock(@Param("seckillId") long seckillId, @Param("killTime")Date killTime);
    /**
     *根据id查询秒杀对象
     */
    Seckill queryById(@Param("seckillId")long seckillId);
    /**
     * 根据偏移量查询秒杀商品列表
     */
    List<Seckill> queryAll(@Param("offset") int offset, @Param("limit") int limit);

    /**
     *使用存储过程进行秒杀
     * @param paramMap
     */
    void killByProcedure(Map<String,Object> paramMap);
}
