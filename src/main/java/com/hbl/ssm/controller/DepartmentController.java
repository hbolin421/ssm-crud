package com.hbl.ssm.controller;

import com.hbl.ssm.bean.Department;
import com.hbl.ssm.bean.Msg;
import com.hbl.ssm.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @Package: com.hbl.ssm.controller
 * @ClassName : DepartmentController
 * @Author : Administrator
 * @Date: 2021/3/30 11:27
 *
 * 处理和部门有关的请求
 */
@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    /*
    * 返回所有部门信息
    * */
    @RequestMapping(value = "/depts")
    @ResponseBody
    public Msg getDepts(){
        //查出的所有部门信息
        List<Department> list = departmentService.getDepts();

        return Msg.success().add("depts", list);
    }
}