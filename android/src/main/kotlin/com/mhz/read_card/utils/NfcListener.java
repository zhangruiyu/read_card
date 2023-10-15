package com.mhz.read_card.utils;

import android.nfc.Tag;

public interface NfcListener {
    void onNfcEvent(Tag tag);

    void onNfcError(boolean has);
}
