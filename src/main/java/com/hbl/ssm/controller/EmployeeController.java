package com.hbl.ssm.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hbl.ssm.bean.Employee;
import com.hbl.ssm.bean.Msg;
import com.hbl.ssm.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Package: com.hbl.ssm.controller
 * @ClassName : EmployeeController
 * @Author : Administrator
 * @Date: 2021/3/29 14:34
 */
@Controller
public class EmployeeController {

    //根据属性类型注入
    @Autowired
    EmployeeService employeeService;


    /*
    * 员工删除方法
    * 单删和批量删除
    * */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable(value = "ids") String ids){
        //批量删除
        if(ids.contains("-")){
            List<Integer> del_ids = new ArrayList<>();

            //分割传入进来的 ids
            String[] str_ids = ids.split("-");

            //循环得到 id
            for(String id : str_ids){
                //把每个 id 传入 List 中
                del_ids.add(Integer.parseInt(id));
            }
            employeeService.deleteBatch(del_ids);
        }else {
            int id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }

        return Msg.success();
    }


    /*
    * ajax 直接使用 PUT 请求会出现
    * 问题：
    * 请求体中有数据，但是 Employee 对象封装不上
    *
    * 原因：
    * Tomcat
    *   1. 将请求体中的数据，封装成一个 Map
    *   2. request.getParameter 会从这个 map 中取值
    *   3. SpringMVC 封装 POJO 对象的时候会把 POJO 中每个属性的值，从这个方法中拿到 request.getParameter
    *
    *  ajax 发送 PUT 请求会导致 request.getParameter 方法拿不到
    *  Tomcat 看到是 PUT 请求不会封装请求体中的数据为 Map，只有 POST 的请求会去封装为 Map
    *
    * 我们如果想支持直接发送 PUT 之类的请求还有封装请求体中的数据
    * 配置上 HttpPutFormContentFilter 作用：
    * request 被重新封装，request.getParameter 被重写
    * 员工更新
    * */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee){
        //调用 有选择更新的方法
        employeeService.updateEmp(employee);

        return Msg.success();
    }

    /*
    * 根据 id 查询员工
    * */
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable(value = "id") Integer id){
        Employee employee = employeeService.getEmp(id);

        return Msg.success().add("emp", employee);
    }

    /*
    * 检查用户名是否可用
    * */
    @ResponseBody
    @RequestMapping(value = "/checkUser")
    public Msg checkUser(@RequestParam(value = "empName") String empName){
        //先判断用户名是否是合法的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";

        if(!empName.matches(regx)){
            return Msg.fail().add("va_msg", "用户名必须是2-5位中文或者6-16位英文和数字的组合");
        }

        //数据库用户名重复校验
        //调用 EmployeeService 中的方法
        boolean b = employeeService.checkUser(empName);

        //判断返回是否为 true，false
        if(b){
            return Msg.success();
        }else {
            return Msg.fail().add("va_msg", "用户名不可用");
        }
    }

    /*
    * 员工保存方法
    * 1. JSR303 数据校验需要先导入 hibernate-validate
    *
    * */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        //@Valid 后台校验，需加上 BindingResult 参数
        if(result.hasErrors()){
            //校验失败，应该返回失败，在模态框中显示校验失败的错误新
            //创建 map
            Map<String , Object> map = new HashMap<>();

            //获取错误信息
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors){
                //拿到错误信息
                System.out.println("错误的字段名：" + fieldError.getField());
                System.out.println("错误信息：" + fieldError.getDefaultMessage());
                //把错误信息，加入 Map
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }

            return Msg.fail().add("errorField", map);
        }else {
            //调用保存方法，前段传入的数据，会进行封装到 Employee 对象中
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /*
    * 使用 @ResponseBody 需要导入 jackson 包
    * */
    @RequestMapping(value = "/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pageNumber", defaultValue = "1",
            required = false) Integer pageNumber){
        //引入 PageHelper 分页插件
        //在查询之前只需要调用，startPage 方法，传入页码和每页大小
        PageHelper.startPage(pageNumber, 5);
        //startPage 后面紧跟的查询，就是分页查询

        //这不是一个分页查询
        List<Employee> emps = employeeService.getAll();

        //使用 PageInfo 包装查询后的结果，只需要将 pageInfo 交给页面
        //pageInfo 里封装了详细的分页信息，包括我们查询出来的信息，传入连续显示的页数
        PageInfo page = new PageInfo(emps, 5);

        //因为使用了 @ResponseBody 注解，可以直接返回成 json 字符串
        return Msg.success().add("pageInfo", page);
    }

    /*@RequestMapping(value = "/emps")//映射，并传入一个参数，默认值为 1
    public String getEmps(@RequestParam(value = "pageNumber", defaultValue = "1", required = false) Integer pageNumber,
                          Model model){
        //引入 PageHelper 分页插件
        //在查询之前只需要调用，startPage 方法，传入页码和每页大小
        PageHelper.startPage(pageNumber, 5);
        //startPage 后面紧跟的查询，就是分页查询

        //这不是一个分页查询
        List<Employee> emps = employeeService.getAll();

        //使用 PageInfo 包装查询后的结果，只需要将 pageInfo 交给页面
        //pageInfo 里封装了详细的分页信息，包括我们查询出来的信息，传入连续显示的页数
        PageInfo page = new PageInfo(emps, 5);

        //加入 Model 中，Map 也可以，传入页面，以供使用
        model.addAttribute("pageInfo", page);

        //返回到 list 页面
        return "list";
    }*/
}