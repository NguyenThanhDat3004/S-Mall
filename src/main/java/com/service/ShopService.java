package com.service;

import com.dto.request.ShopRegistrationDTO;
import com.entity.Shop;
import com.entity.User;
import java.io.IOException;

public interface ShopService {
    Shop registerShop(ShopRegistrationDTO dto, User user) throws IOException;
}
