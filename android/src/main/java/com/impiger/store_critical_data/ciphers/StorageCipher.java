package com.impiger.store_critical_data.ciphers;

public interface StorageCipher {

    byte[] encrypt(byte[] input) throws Exception;
    byte[] decrypt(byte[] input) throws Exception;
}
