package com.hbl.ssm.service;

import com.hbl.ssm.bean.Department;
import com.hbl.ssm.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Package: com.hbl.ssm.service
 * @ClassName : DepartmentService
 * @Author : Administrator
 * @Date: 2021/3/30 11:27
 */
@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> getDepts(){
        List<Department> list = departmentMapper.selectByExample(null);

        return list;
    }
}