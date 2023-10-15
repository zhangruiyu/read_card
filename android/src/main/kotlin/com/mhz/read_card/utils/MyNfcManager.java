package com.mhz.read_card.utils;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.IntentFilter;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.nfc.tech.NfcB;
import android.os.Bundle;

/**
 * 用于NFC配置
 */
public class MyNfcManager {


    /**
     * Android 4.4之后NFC模式配置
     */

    public static NfcAdapter enableReaderMode(final Activity activity, final NfcListener listener) {
        try {
            NfcAdapter nfcAdapter = NfcAdapter.getDefaultAdapter(activity);
            if (nfcAdapter == null) {
                if (listener != null) {
                    listener.onNfcError(false);
                }
                return null;
            }
            if (!nfcAdapter.isEnabled()) {
                if (listener != null) {
                    listener.onNfcError(true);
                }
                return null;
            }
            Bundle options = new Bundle();
            //对卡片的检测延迟300ms
            options.putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, 300);
            int READER_FLAGS = NfcAdapter.FLAG_READER_NFC_B | NfcAdapter.FLAG_READER_NFC_V | NfcAdapter.FLAG_READER_NFC_F
                    | NfcAdapter.FLAG_READER_NFC_A | NfcAdapter.FLAG_READER_NFC_BARCODE;
            nfcAdapter.enableReaderMode(activity, new NfcAdapter.ReaderCallback() {

                @Override
                public void onTagDiscovered(final Tag tag) {
                    if (listener != null) {
                        listener.onNfcEvent(tag);
                    }
                }
            }, READER_FLAGS, options);
            return nfcAdapter;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static NfcAdapter enableReaderMode(final Activity activity) {
        return enableReaderMode(activity, null);
    }

    public static void disableReaderMode(Activity activity, NfcAdapter nfcAdapter) {
        try {
            if (nfcAdapter != null) {
                nfcAdapter.disableReaderMode(activity);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * Android 4.4之前NFC模式配置
     */

    private static IntentFilter mTagDetectedIntentFilter;
    private static String[][] mTechLists;
    private static PendingIntent mNfcPendingIntent;

    public static NfcAdapter enableForegroundDispatch(final Activity activity, final NfcListener listener) {

        try {
            NfcAdapter nfcAdapter = NfcAdapter.getDefaultAdapter(activity);
            if (nfcAdapter == null) {
                if (listener != null) {
                    listener.onNfcError(false);
                }
                return null;
            }
            if (!nfcAdapter.isEnabled()) {
                if (listener != null) {
                    listener.onNfcError(true);
                }
                return null;
            }
            if (mNfcPendingIntent == null) {
                mNfcPendingIntent = PendingIntent.getActivity(activity, 0, (new Intent(activity, activity.getClass())).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), 0);
            }
            if (mTagDetectedIntentFilter == null) {
                mTagDetectedIntentFilter = new IntentFilter("android.nfc.action.TECH_DISCOVERED");
                mTagDetectedIntentFilter.addCategory("android.intent.category.DEFAULT");
            }
            if (mTechLists == null) {
                mTechLists = new String[][]{{NfcB.class.getName()}};
            }
            nfcAdapter.enableForegroundDispatch(activity, mNfcPendingIntent, new IntentFilter[]{mTagDetectedIntentFilter}, mTechLists);
            return nfcAdapter;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void disableForegroundDispatch(Activity activity, NfcAdapter nfcAdapter) {
        try {
            if (nfcAdapter != null) {
                nfcAdapter.disableForegroundDispatch(activity);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}