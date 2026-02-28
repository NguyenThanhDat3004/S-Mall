package com.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.service.UserService;

@Controller
public class UserController {
    private final UserService userService;
    // dependency injection
    public UserController(UserService userService) {
        this.userService = userService;
    }


    @RequestMapping("/")
    public String getHomepage() {
        return "dat.html";
    }
    // quy dinh string vi ten file thi phai la du lieu String vi no khong biet file no dinh dang nhu the nao
    // view chinh la folder static nam trong resources
    // ngang vid engine 
    

}
