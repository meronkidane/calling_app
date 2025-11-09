package com.example.callingapp.service;

import com.google.i18n.phonenumbers.NumberParseException;
import com.google.i18n.phonenumbers.PhoneNumberUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class PhoneNumberService {

    private static final Logger log = LoggerFactory.getLogger(PhoneNumberService.class);
    private final PhoneNumberUtil phoneUtil = PhoneNumberUtil.getInstance();

    public String toE164(String rawNumber, String defaultRegion) {
        try {
            var number = phoneUtil.parse(rawNumber, defaultRegion);
            if (!phoneUtil.isValidNumber(number)) {
                throw new IllegalArgumentException("Invalid phone number");
            }
            return phoneUtil.format(number, PhoneNumberUtil.PhoneNumberFormat.E164);
        } catch (NumberParseException | IllegalArgumentException ex) {
            log.warn("Failed to normalize phone {}: {}", rawNumber, ex.getMessage());
            throw new IllegalArgumentException("Invalid phone number format");
        }
    }
}
