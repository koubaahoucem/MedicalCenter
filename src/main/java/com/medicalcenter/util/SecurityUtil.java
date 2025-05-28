package com.medicalcenter.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.UUID;

public class SecurityUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    public static String hashPassword(String password) {
        try {
            // Generate a salt
            byte[] salt = new byte[16];
            RANDOM.nextBytes(salt);

            // Hash the password
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());

            // Combine salt and password
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);

            return Base64.getEncoder().encodeToString(combined);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static boolean verifyPassword(String password, String storedHash) {
        try {
            // Decode the stored hash
            byte[] combined = Base64.getDecoder().decode(storedHash);

            // Extract salt and hash
            byte[] salt = new byte[16];
            byte[] hash = new byte[combined.length - 16];
            System.arraycopy(combined, 0, salt, 0, 16);
            System.arraycopy(combined, 16, hash, 0, hash.length);

            // Hash the input password with the same salt
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());

            // Compare the hashes
            if (hash.length != hashedPassword.length) {
                return false;
            }

            for (int i = 0; i < hash.length; i++) {
                if (hash[i] != hashedPassword[i]) {
                    return false;
                }
            }

            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public static String generateResetToken() {
        return UUID.randomUUID().toString();
    }

    public static String generateSecureToken() {
        byte[] tokenBytes = new byte[32];
        RANDOM.nextBytes(tokenBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
    }
}