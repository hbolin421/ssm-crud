<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2021/3/29
  Time: 14:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<%--
    web 路径：
    不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题
    以/开始的相对路径，找资源，以服务器的路径为标准（http://localhost:3306）加上项目名
--%>
<%--引入 bootstrap JQuery--%>
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<%--引入 bootstrap 样式--%>
<link rel="stylesheet" href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<%--引入 bootstarp javaScript--%>
<script type="text/javascript" src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<html>
<head>
  <title>员工列表</title>
</head>
<body>
<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" >员工更新</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal">
          <%--员工姓名--%>
          <div class="form-group">
            <label class="col-sm-2 control-label">empName</label>
            <div class="col-sm-10">
              <p class="form-control-static" id="empName_update_static"></p>
              <span class="help-block"></span>
            </div>
          </div>
          <div class="form-group">
            <%--电子邮箱--%>
            <label class="col-sm-2 control-label">email</label>
            <div class="col-sm-10">
              <input type="text" class="form-control" name="email" id="email_update_input" placeholder="email@163.com">
              <span class="help-block"></span>
            </div>
          </div>
          <div class="form-group">
            <%--性别--%>
            <label class="col-sm-2 control-label">gender</label>
            <div class="col-sm-10">
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
              </label>
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
              </label>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">deptName</label>
            <div class="col-sm-4">
              <%--部门提交部门 id，从数据库中查询出来部门名称--%>
              <select class="form-control" name="dId" id="dept_update_select"></select>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
      </div>
    </div>
  </div>
</div>

<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal">
          <%--员工姓名--%>
          <div class="form-group">
            <label class="col-sm-2 control-label">empName</label>
            <div class="col-sm-10">
              <input type="text" class="form-control" name="empName" id="empName_add_input" placeholder="empName">
              <span class="help-block"></span>
            </div>
          </div>
          <div class="form-group">
            <%--电子邮箱--%>
            <label class="col-sm-2 control-label">email</label>
            <div class="col-sm-10">
              <input type="text" class="form-control" name="email" id="email_add_input" placeholder="email@163.com">
              <span class="help-block"></span>
            </div>
          </div>
          <div class="form-group">
            <%--性别--%>
            <label class="col-sm-2 control-label">gender</label>
            <div class="col-sm-10">
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
              </label>
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
              </label>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">deptName</label>
            <div class="col-sm-4">
              <%--部门提交部门 id，从数据库中查询出来部门名称--%>
              <select class="form-control" name="dId" id="dept_add_select"></select>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
      </div>
    </div>
  </div>
</div>

<%--搭建显示页面--%>
<div class="container">
  <%--标题--%>
  <div class="row">
    <div class="col-md-12">
      <h1>SSM-CRUD</h1>
    </div>
  </div>

  <%--按钮--%>
  <div class="row">
    <div class="col-md-4 col-md-offset-8">
      <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
      <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
    </div>
  </div>

  <%--显示表格数据--%>
  <div class="row">
    <div class="col-md-12">
      <table class="table table-hover" id="emps_table">
        <thead>
          <tr>
            <th>
              <input type="checkbox" id="check_all" />
            </th>
            <th>#</th>
            <th>empName</th>
            <th>gender</th>
            <th>department</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>

        </tbody>
      </table>
    </div>
  </div>

  <%--显示分页信息--%>
  <div class="row">
    <%--分页文字信息--%>
    <div class="col-md-6" id="page_info_area"></div>
    <%--分页条信息--%>
    <div class="col-md-6" id="page_nav_area"></div>
  </div>
</div>
      <script type="text/javascript">
        //定义一个全局变量，总记录数，用于显示最后一页
        var totalRecord, currentPage;

        //1. 页面加载完成以后，直接去发送 ajax 请求，要到分页数据
        $(function (){
          //去首页
          to_page(1)
        });

        function to_page(pn){
          $.ajax({
            url:"${APP_PATH}/emps",
            data:"pageNumber= " + pn,
            type:"GET",
            success:function (result){
              //1. 解析并显示员工数据
              build_emps_table(result);

              //2. 解析并显示分页信息
              build_page_info(result);

              //3. 解析显示分页条数据
              build_page_nav(result);
            }
          });
        }

        function build_emps_table(result){
          //先清空表格中的数据
          $("#emps_table tbody").empty();

          var emps = result.extend.pageInfo.list;

          $.each(emps, function (index, item){
            /*获取 json 字符串中的员工信息*/
            var checkBoxTd = $("<td><input type='checkbox' class='check_item' /></td>")
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == "M" ? "男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var departmentTd = $("<td></td>").append(item.department.deptName);

            //按钮
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                          .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            //为编辑按钮添加一个自定义的属性，来表示当前员工 id
            editBtn.attr("edit-id", item.empId);

            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");

            //为删除按钮添加一个自定义属性来表示当前删除员工的 id
            delBtn.attr("del-id", item.empId);

            //把两个按钮追加到 <td>
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

            //append 方法执行完成之后还是返回原来的元素
            $("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd).append(genderTd)
                    .append(emailTd).append(departmentTd)
                    .append(btnTd).appendTo("#emps_table tbody");
          });
        }

        //解析显示分页信息
        function build_page_info(result){
          //先清空分页信息
          $("#page_info_area").empty();

          //找到显示位置id，追加
          $("#page_info_area").append("当前" + result.extend.pageInfo.pageNum + " 页，总" +
                  result.extend.pageInfo.pages + " 页，共" + result.extend.pageInfo.total + " 条");

          totalRecord = result.extend.pageInfo.total;
          currentPage = result.extend.pageInfo.pageNum;
        }

        //解析显示分页条
        function build_page_nav(result){
          //先清空分页信息
          $("#page_nav_area").empty();

          //page_nav_area
          //父元素
          var ul = $("<ul></ul>").addClass("pagination");

          //首页 <
          var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
          var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

          //判断是否有前一页，没有就不显示
          if (result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disables");
            prePageLi.addClass("disables");
          }else {
            //为元素添加点击事件
            firstPageLi.click(function (){
              to_page(1);
            });
            prePageLi.click(function (){
              to_page(result.extend.pageInfo.pageNum - 1);
            });
          }

          //末页 >
          var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
          var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));

          //判断是否有下一页，没有就不显示
          if (result.extend.pageInfo.hasNextPage = false){
            nextPageLi.addClass("disables");
            lastPageLi.addClass("disables");
          }else {
            //为元素添加点击事件
            nextPageLi.click(function (){
              to_page(result.extend.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function (){
              to_page(result.extend.pageInfo.pages);
            });
          }

          //添加 首页和 <
          ul.append(firstPageLi).append(prePageLi);

          //循环得到连续页码，可以传入两个参数，一个索引，一个是当前数
          $.each(result.extend.pageInfo.navigatepageNums, function (index, itme){
            var numLi = $("<li></li>").append($("<a></a>").append(itme));

            //判断是否等于当前页，是的话，就是加上高亮
            if (result.extend.pageInfo.pageNum == itme){
              numLi.addClass("active");
            }

            //添加点击事件
            numLi.click(function (){
              to_page(itme);
            });

            //把循环得到的连续页码，追加到ul中
            ul.append(numLi);
          });

          //添加 > 和 末页的提示
          ul.append(nextPageLi).append(lastPageLi);

          //把 ul 加入到 nav 元素中
          var navEle = $("<nav></nav>").append(ul);

          //把分页条加入 appendTo 追加到
          navEle.appendTo("#page_nav_area");
        }

        //表单重置
        function reset_form(ele){
          //清除数据
          $(ele)[0].reset();
          //清除表单下 所有标签的样式
          $(ele).find("*").removeClass("has-success has-error");
          $(ele).find(".help-block").text("");
        };

        //点击新增按钮，弹出模态框
        $("#emp_add_modal_btn").click(function (){
          //清除表单数据（表单完整重置：包括数据，表单的样式）
          reset_form("#empAddModal form");

          //发送 ajax 请求，查出部门信息，显示在下拉列表
          getDepts("#dept_add_select");

          //弹出模态框
          $("#empAddModal").modal({
            backdrop:"static"
          });
        })

        //查询所有部门信息并显示在下拉列表中
        function getDepts(ele){
          //先要清下拉列表的数据
          $(ele).empty();

          $.ajax({
            url:"${APP_PATH}/depts",
            type:"GET",
            success:function (result){
              //因为使用的 @ResponseBody 注解所以返回过来的是 json
              //console.log(result);

              //显示部门信息在下拉列表中
              $.each(result.extend.depts, function (index, item){
                //构建元素，添加下拉框真正的值，使用 attr value 添加 部门id
                var optionEle = $("<option></option>").append(item.deptName).attr("value", item.deptId);
                optionEle.appendTo(ele);
              });
            }
          });
        }

        //校验表单数据
        function validate_add_form(){
          //1. 拿到要校验的数据，使用正则表达式
          var empName = $("#empName_add_input").val();
          var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;

          //判断是否通过正则表达式
          if(!regName.test(empName)){
            //清空这个元素之前的样式

            //alert("用户名可以是2-5位中文或者6-16位英文和数字的组合")
            show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
            return false;
          }else {
            show_validate_msg("#empName_add_input", "success");
          }

          //2. 校验邮箱
          var email = $("#email_add_input").val();
          var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;

          //判断是否通过正则表达式
          if(!regEmail.test(email)){
            //alert("邮箱格式不正确");
            show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
            return false;
          }else {
            show_validate_msg("#email_add_input", "success", "");
          }

          return true;
        };

        //校验方法
        function show_validate_msg(ele, status, msg){
          //清除当前元素状态
          $(ele).parent().removeClass("has-error", "has-success");
          $(ele).next("span").text("");

          if("success" == status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
          }else if("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
          }
        };

        //校验用户名是否可用
        $("#empName_add_input").change(function (){
          //发送 ajax 请求校验用户名是否可用
          var empName = this.value;

          $.ajax({
            url:"${APP_PATH}/checkUser",
            data:"empName=" + empName,
            type:"GET",
            success:function (result){
              if (result.code == 100){
                //调用校验方法
                show_validate_msg("#empName_add_input", "success", "用户名可用");
                //校验成功后添加属性值，以供判断
                $("#emp_save_btn").attr("ajax-va", "success");
              }else if(result.code == 200){
                show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                $("#emp_save_btn").attr("ajax-va", "error");
              }
            }
          });
        });

        //点击保存，保存员工
        $("#emp_save_btn").click(function (){
          //1. 模态框中填写的表单数据提交给服务器进行保存

          //1. 先对要提交给服务器的数据进行校验
          if(!validate_add_form()){
            return false;
          };

          //1. 判断之前的 ajax 用户名是否验证成功
          if($(this).attr("ajax-va") == "error"){
            return false;
          };

          //2. 发送 ajax 请求保存员工
          $.ajax({
            url:"${APP_PATH}/emp",
            type:"post",
            data:$("#empAddModal form").serialize(),
            success:function (result){
              //alert(result.msg);
              //员工保存成功：
              if(result.code == 100){
                //1. 关闭模态框
                $("#empAddModal").modal('hide');

                //2. 来到最后一页
                //发送 ajax 请求显示最后一页数据即可
                to_page(totalRecord);
              }else {
                //显示失败信息
                //有那个字段的错误信息就显示那个字段的错误信息
                if(undefined != result.extend.errorFields.email){
                  //显示邮箱错误信息
                  show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                }

                if(undefined != result.extend.errorFields.empName){
                  //显示员工名字的错误信息
                  show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                }
              }
            }
          });
        });

        //1. 因为我们是创建之前就绑定了 click 所以绑定不上
        $(document).on("click", ".edit_btn", function (){
          //0. 查出员工信息，显示员工信息
          getEmp($(this).attr("edit-id"));

          //1. 查出部门信息，并显示部门列表
          getDepts("#empUpdateModal select");

          //把员工 id 传递给模态框的更新按钮
          $("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));

          //弹出模态框
          $("#empUpdateModal").modal({
            backdrop:"static"
          });
        });

        function getEmp(id){
          $.ajax({
            url:"${APP_PATH}/emp/" + id,
            type:"GET",
            success:function (result){
              var empData = result.extend.emp;
              $("#empName_update_static").text(empData.empName);
              $("#email_update_input").val(empData.email);
              $("#empUpdateModal input[name=gender]").val([empData.gender]);
              $("#empUpdateModal select").val([empData.dId]);
            }
          });
        }

        //点击更新，更新员工信息
        $("#emp_update_btn").click(function (){
          //验证邮箱是否合法
          var email = $("#email_update_input").val();
          var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;

          //判断是否通过正则表达式
          if(!regEmail.test(email)){
            //alert("邮箱格式不正确");
            show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
            return false;
          }else {
            show_validate_msg("#email_update_input", "success", "");
          }

          //发送 ajax 请求保存更新员工的信息
          $.ajax({
            url:"${APP_PATH}/emp/" + $(this).attr("edit-id"),
            type:"PUT",
            data:$("#empUpdateModal form").serialize(),
            success:function (result){
              //alert(result.msg)
              //1. 关闭对话框
              $("#empUpdateModal").modal('hide');

              //2. 回到本页面
              to_page(currentPage);
            }
          });
        });

        //单个删除
        $(document).on("click", ".delete_btn", function (){
          //1. 弹出是否确认删除对话框
          //alert($(this).parents("tr").find("td:eq(1)").text());
          //拿到员工姓名
          var empName = $(this).parents("tr").find("td:eq(2)").text();

          var empId = $(this).attr("del-id");

          if(confirm("确认删除【" + empName + "】?")){
            //确认，删除即可
            $.ajax({
              url:"${APP_PATH}/emp/" + empId,
              type:"DELETE",
              success:function (result){
                //alert(result.msg)
                //处理成功之后，回到本页
                to_page(currentPage);
              }
            });
          }
        });

        //完成全选/全不选功能
        $("#check_all").click(function (){
          //attr 获取 checked 是 underfind
          //我们这些原生的属性
          //prop 修改和读取 dom 原生属性的值
          $(".check_item").prop("checked", $(this).prop("checked"));
        })

        //check_item
        $(document).on("click", ".check_item", function (){
          //判断当前选择中的元素是否5个
          var flag = $(".check_item:checked").length == $(".check_item").length;
          $("#check_all").prop("checked", flag);
        });

        //点击全部删除，就批量删除
        $("#emp_delete_all_btn").click(function (){

          var empNames = "";
          var del_idstr = "";

          $.each($(".check_item:checked"), function (){
            //组装 empName 字符串
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";

            //组装 id 字符串
            del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";

          });
          //去除 empNames 多余的,
          empNames = empNames.substring(0, empNames.length - 1);
          //去除 id 多余的 -
          del_idstr = del_idstr.substring(0, del_idstr.length - 1);

          if(confirm("确认删除【" + empNames + "】？")){
            //发送 ajax 请求删除
            $.ajax({
              url:"${APP_PATH}/emp/" + del_idstr,
              type:"DELETE",
              success:function (result){
                //回到当前页
                to_page(currentPage);
              }
            });
          }
        });
      </script>
</body>
</html>
