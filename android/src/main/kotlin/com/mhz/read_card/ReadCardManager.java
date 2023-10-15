package com.mhz.read_card;

import android.content.Context;

import com.eidlink.idocr.sdk.EidLinkSE;
import com.eidlink.idocr.sdk.EidLinkSEFactory;
import com.eidlink.idocr.sdk.bean.EidlinkInitParams;

public class ReadCardManager {
    public static EidLinkSE eid;
    public static String tag_need_add_picture = "tag_need_add_picture";

    /**
     * SDK初始化
     */
    public static void initEid(final Context context,String appid,String ip,int port,int envCode) {
        eid = EidLinkSEFactory.getEidLinkSE(new EidlinkInitParams(context, appid, ip, port, envCode));
        eid.setGetDataFromSdk(true);
    }
}
