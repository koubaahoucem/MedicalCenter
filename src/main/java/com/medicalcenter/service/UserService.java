package com.medicalcenter.service;

import com.medicalcenter.dao.UserDAO;
import com.medicalcenter.model.User;

public class UserService {
    private UserDAO userDAO;
    public UserService() {
        userDAO = new UserDAO();
    }


    public void updateUser(User user) {
        userDAO.updateUser(user);
    }

    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }
}
