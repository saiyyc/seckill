package Bean;
import java.util.Date;

public class SeckillOrder {
    private long seckillId; //秒杀到的商品ID
    private double money; //支付金额
    private long userPhone; //秒杀用户的手机号
    private Date createTime; //创建时间

    private boolean status; //订单状态， -1:无效 0:成功 1:已付款

    private Seckill seckill; //秒杀商品，和订单是一对多的关系

    public long getSeckillId() {
        return seckillId;
    }

    public void setSeckillId(long seckillId) {
        this.seckillId = seckillId;
    }

    public double getMoney() {
        return money;
    }

    public void setMoney(double money) {
        this.money = money;
    }

    public long getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(long userPhone) {
        this.userPhone = userPhone;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Seckill getSeckill() {
        return seckill;
    }

    public void setSeckill(Seckill seckill) {
        this.seckill = seckill;
    }

    @Override
    public String toString() {
        return "SeckillOrder{" +
                "seckillId=" + seckillId +
                ", money=" + money +
                ", userPhone=" + userPhone +
                ", createTime=" + createTime +
                ", status=" + status +
                ", seckill=" + seckill +
                '}';
    }
}
