package com.controller.admin;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;
import com.entity.User;
import com.repository.UserRepository;
import com.service.UserService;

@Controller
public class UserController {
    private final UserService userService;
    private final UserRepository userRepository;

    public UserController(UserService userService, UserRepository userRepository) {
        this.userService = userService;
        this.userRepository = userRepository;
    }


    @RequestMapping("/admin/user")
    public String getUserpage(Model model) {
        model.addAttribute("userProfile", new com.entity.User());
        return "admin/user/create";
    }

    @RequestMapping(value = "/admin/user/create", method = RequestMethod.POST)
    public String createUserpage(Model model, @ModelAttribute("userProfile") com.entity.User userProfile) {
        this.userService.handleSaveUser(userProfile);
        System.out.println("create user" + userProfile);
        model.addAttribute("userProfile", new com.entity.User());
        return "admin/user/create";
    }

    @RequestMapping("/admin/user/list-user")
    public String listUsers(Model model) {
        List<User> users = this.userService.getAllUsers();
        model.addAttribute("users", users);
        System.out.println("Admin check list user");
        return "admin/user/list-user";
    }

    @RequestMapping(value = "/admin/user/update", method = RequestMethod.GET)
    public String showUpdateForm(@RequestParam("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        com.entity.User user = this.userService.findById(id);
        if (user == null) {
            redirectAttributes.addFlashAttribute("message", "Cannot find user!");
            redirectAttributes.addFlashAttribute("messageType", "error");
            return "redirect:/admin/user/list-user";
        }
        model.addAttribute("userProfile", user);
        return "admin/user/update";
    }

    @RequestMapping(value = "/admin/user/update", method = RequestMethod.POST)
    public String handleUpdate(@ModelAttribute("userProfile") com.entity.User userProfile,
            RedirectAttributes redirectAttributes) {
        User user = this.userService.handleUpdateUser(userProfile);
        if (user != null) {
            redirectAttributes.addFlashAttribute("message", "Update successfully!");
            redirectAttributes.addFlashAttribute("messageType", "success");
        } else {
            redirectAttributes.addFlashAttribute("message", "Fail to update user!");
            redirectAttributes.addFlashAttribute("messageType", "error");
        }
        System.out.println("Updated user: " + userProfile);
        return "redirect:/admin/user/list-user";
    }

    @RequestMapping(value = "/admin/user/delete", method = RequestMethod.POST)
    public String handledelete(@RequestParam("id") Long id, RedirectAttributes redirectAttributes) {
        boolean success = this.userService.deleteById(id);
        if (success) {
            redirectAttributes.addFlashAttribute("message", "Delete successfully!");
            redirectAttributes.addFlashAttribute("messageType", "success");
        } else {
            redirectAttributes.addFlashAttribute("message", "Fail to delete user!");
            redirectAttributes.addFlashAttribute("messageType", "error");
        }
        System.out.println("Delete user: " + id);
        return "redirect:/admin/user/list-user";
    }
}
