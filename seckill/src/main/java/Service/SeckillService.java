package Service;

import Bean.Seckill;
import dto.Exposer;
import dto.SeckillExecution;
import exception.RepeatKillException;
import exception.SeckillCloseException;
import exception.SeckillException;

import java.util.List;

/**
 *设计业务层接口，应该站在使用者角度上设计，如我们应该做到：
 * 1.定义业务方法的颗粒度要细。
 * 2.方法的参数要明确简练，不建议使用类似Map这种类型，让使用者可以封装进Map中一堆参数而传递进来，尽量精确到哪些参数。
 * 3.方法的return返回值，除了应该明确返回值类型，还应该指明方法执行可能产生的异常(RuntimeException)，并应该手动封装一些通用的异常处理机制。
 */
public interface SeckillService {
    /**
     * 查询所有秒杀记录
     * @return
     */
    List<Seckill> getSeckillList();

    /**
     * 查询单个秒杀记录
     * @param seckillId
     * @return
     */
    Seckill getById(long seckillId);

    /**
     * 秒杀开始时输出输出秒杀接口地址
     * 否则输出系统时间和秒杀时间
     * @param seckillId
     */
    Exposer exportSeckillUrl(long seckillId);
    /**
     * 执行秒杀操作
     */
    SeckillExecution executeSeckill(long seckillId, long userPhone, String md5)
            throws SeckillException, RepeatKillException, SeckillCloseException;
    /**
     *执行秒杀操作,存储过程调用
     */
    SeckillExecution executeSeckillProcedure(long seckillId, long userPhone, String md5);
}
