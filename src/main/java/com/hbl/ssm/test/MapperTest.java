package com.hbl.ssm.test;

import com.hbl.ssm.bean.Department;
import com.hbl.ssm.bean.DepartmentExample;
import com.hbl.ssm.bean.Employee;
import com.hbl.ssm.dao.DepartmentMapper;
import com.hbl.ssm.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * @Package: com.hbl.ssm.test
 * @ClassName : MapperTest
 * @Author : Administrator
 * @Date: 2021/3/29 11:51
 *
 * 推荐：Spring 项目可以使用 Spring 的单元测试，可以自动注入我们需要的组件
 * 1. 导入 SpringTest 模块
 * 2. @ContextConfiguration 指定 Spring 的配置文件的位置
 * 3. 直接 autowired 要使用的组件即可
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    //拿到 DepartmentMapper 中的方法，根据属性类型注入
    @Autowired
    DepartmentMapper departmentMapper;

    //拿到 EmployeeMapper 中的方法，根据属性类型注入
    @Autowired
    EmployeeMapper employeeMapper;

    //拿到 SqlSession
    @Autowired
    SqlSession sqlSession;

    /*
    * 测试 DepartmentMapper
    * */
    @Test
    public void testCRUD(){
        /*因为使用了 Spring test，所以可以直接使用 autowired 即可
        //1. 创建 Spring IOC 容器
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        //2. 从容器中获取 mapper
        Department department = context.getBean("department", Department.class);*/

        //1. 插入几个部门
        /*departmentMapper.insertSelective(new Department(null, "开发部"));
        departmentMapper.insertSelective(new Department(null, "测试部"));*/

        //2. 生成员工数据，测试员工插入
        //employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@163.com", 1));

        //3. 批量出入多个员工：批量，使用可以执行批量操作的 sqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i = 0; i < 1000; i++){
            //UUID作为姓名
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "M", uid + "@163.com",  1));
        }
        System.out.println("批量完成~");
    }
}