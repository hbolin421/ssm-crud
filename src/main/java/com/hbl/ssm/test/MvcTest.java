package com.hbl.ssm.test;

import com.github.pagehelper.PageInfo;
import com.hbl.ssm.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * @Package: com.hbl.ssm.test
 * @ClassName : MvcTest
 * @Author : Administrator
 * @Date: 2021/3/29 15:02
 *
 * 使用 Spring 测试模块提供的测试请求功能，测试 CRUD 请求的正确性
 * Spring4 测试的时候，需要
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration//加上这个注解，WebApplicationContext 才能注入属性
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:dispatcherServlet.xml"})
public class MvcTest {

    //传入 SpringMVC 的 IOC
    @Autowired
    WebApplicationContext context;

    //虚拟 mvc 请求，获取到处理结果
    MockMvc mockMvc;

    //前置通知
    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    //测试 Page 查询
    @Test
    public void testPage() throws Exception {
        //模拟请求拿到返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps")
                .param("pageNumber", "1")).andReturn();

        //请求成功后，请求域中会有 pageInfo，我们呢可以取出 pageInfo 进行验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");

        System.out.println("当前页码：" + pageInfo.getPageNum());
        System.out.println("总页码：" + pageInfo.getPages());
        System.out.println("总记录数：" + pageInfo.getTotal());
        System.out.println("在页面需要连续显示的页码：");
        int[] nums = pageInfo.getNavigatepageNums();
        for (int i : nums){
            System.out.println("" + i);
        }

        //获取员工数据
        List<Employee> list = pageInfo.getList();
        for(Employee employee : list){
            System.out.println("ID:" + employee.getEmpId() + "===>Name:" + employee.getEmpName());
        }
    }
}