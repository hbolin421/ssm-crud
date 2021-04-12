package com.hbl.ssm.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * @Package: com.hbl.ssm.bean
 * @ClassName : Msg
 * @Author : Administrator
 * @Date: 2021/3/29 18:06
 */
public class Msg {
    //状态码 100-成功，200-失败
    private int code;

    //提示信息
    private String msg;

    //用户要返回给浏览器的数据
    private Map<String, Object> extend = new HashMap<String, Object>();

    //状态成功方法
    public static Msg success(){
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功！");

        return result;
    }

    //状态失败方法
    public static Msg fail(){
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败！");

        return result;
    }

    //添加方法，以供前段方便使用
    public Msg add(String key, Object value){
        //将传入进来的参数，传入 extend 中
        this.getExtend().put(key, value);

        //返回
        return this;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

    public int getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }
}