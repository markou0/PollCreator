package com.markkryzh.poll_creator.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AuthorizationController {

	@RequestMapping(value = "/login**", method = RequestMethod.GET)
	public ModelAndView login(
			@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "logout", required = false) String logout,
			@RequestParam(value = "registration_succeed", required = false) boolean registrationSucceed,
			@RequestParam(value = "username", required = false) String username,
			HttpServletRequest request) {

		ModelAndView model = new ModelAndView();
		if (error != null) {
			model.addObject("error", "Invalid username and password!");

			// login form for update page
			// if login error, get the targetUrl from session again.
			String targetUrl = getRememberMeTargetUrlFromSession(request);
			System.out.println(targetUrl);
			if (StringUtils.hasText(targetUrl)) {
				model.addObject("targetUrl", targetUrl);
				model.addObject("loginUpdate", true);
			}

		}

		if (registrationSucceed) {
			model.addObject("msg",
					"You have successfuly registered new Account");
			model.addObject("username", username);
		} else if (logout != null) {
			model.addObject("msg", "You've been logged out successfully.");
		}
		model.setViewName("login");

		return model;

	}

	/**
	 * get targetURL from session
	 */
	private String getRememberMeTargetUrlFromSession(HttpServletRequest request) {
		String targetUrl = "";
		HttpSession session = request.getSession(false);
		if (session != null) {
			targetUrl = session.getAttribute("targetUrl") == null ? ""
					: session.getAttribute("targetUrl").toString();
		}
		return targetUrl;
	}

}