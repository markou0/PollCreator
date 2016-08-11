package com.markkryzh.poll_creator.controllers;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.markkryzh.poll_creator.dao.PostgreSqlDAO;
import com.markkryzh.poll_creator.objects.User;
import com.markkryzh.poll_creator.validators.UserValidator;

@Controller
public class RegistrationController {

	@Autowired
	private PostgreSqlDAO postgreSQLDAO;
	@Autowired
	private UserValidator userValidator;

	@RequestMapping(value = "/registration", method = RequestMethod.GET)
	public ModelAndView showRegistrationForm() {
		ModelAndView modelAndView = new ModelAndView("registration");
		modelAndView.addObject("user", new User());
		return modelAndView;
	}

	@RequestMapping(value = "submit_registration", method = RequestMethod.POST)
	public ModelAndView submitRegistrationForm(
			@Valid @ModelAttribute User user, BindingResult bindingResult,
			HttpServletResponse response) {
		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		userValidator.validate(user, bindingResult);
		ModelAndView modelAndView = new ModelAndView("redirect:/login");
		if (bindingResult.hasErrors()) {
			modelAndView.setViewName("/registration");
			modelAndView.addObject(user);
		} else {
			user.setPassword(passwordEncoder.encode(user.getPassword()));
			postgreSQLDAO.insertUser(user);
			modelAndView
					.setViewName("redirect:/login?registration_succeed=true&username="
							+ user.getUsername());
		}
		return modelAndView;
	}
}
