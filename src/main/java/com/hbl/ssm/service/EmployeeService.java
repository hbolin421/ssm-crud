package com.hbl.ssm.service;

import com.hbl.ssm.bean.Employee;
import com.hbl.ssm.bean.EmployeeExample;
import com.hbl.ssm.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Package: com.hbl.ssm.service
 * @ClassName : EmployeeService
 * @Author : Administrator
 * @Date: 2021/3/29 14:39
 */
@Service
public class EmployeeService{

    //根据属性类型注入，dao
    @Autowired
    EmployeeMapper employeeMapper;


    /*
    * 校验用户名是否可用
    * */
    public boolean checkUser(String empName){
        //创建 EmployeeExample 对象
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        //这条记录中的 empName 需要等于传入过来的参数
        criteria.andEmpNameEqualTo(empName);

        //返回是否有这条记录
        long count = employeeMapper.countByExample(example);

        //为 0 代表当前姓名可用
        return count == 0;
    }

    /*
    * 查询所有员工
    * */
    public List<Employee> getAll() {
        //调用 employeeMapper 中的 自定义的查询员工和部门信息
        return employeeMapper.selectByExampleWithDept(null);
    }

    /*
    * 员工保存
    * */
    public void saveEmp(Employee employee){
        //调用保存方法
        employeeMapper.insertSelective(employee);
    }

    /*
    * 按照员工 id 查询员工
    * */
    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);

        return employee;
    }

    /*
    * 员工更新
    * */
    public void updateEmp(Employee employee){
        //按照 Employee 对象有选择的更新
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /*
    * 员工删除
    * */
    public void deleteEmp(Integer id) {
        //调用删除方法，传入 id
        employeeMapper.deleteByPrimaryKey(id);
    }

    /*
    * 批量删除方法
    * */
    public void deleteBatch(List<Integer> ids){
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        //传入传入过来的 ids
        criteria.andEmpIdIn(ids);

        //调用删除方法
        employeeMapper.deleteByExample(example);
    }
}