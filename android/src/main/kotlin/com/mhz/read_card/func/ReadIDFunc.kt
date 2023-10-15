package com.mhz.read_card.func

import android.R.attr.bitmap
import android.app.Activity
import android.graphics.Bitmap
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.text.TextUtils
import com.eidlink.idocr.sdk.bean.EidlinkResult
import com.eidlink.idocr.sdk.listener.OnGetResultListener
import com.mhz.read_card.ReadCardManager
import com.mhz.read_card.utils.MyNfcManager
import com.mhz.read_card.utils.NfcListener
import com.zkteco.android.IDReader.IDCardPhoto
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream


const val NoNFCFailCode = 10000
const val NFCOpenFailCode = 10001

class ReadIDFunc(
    private val activity: Activity,
    private val result: MethodChannel.Result,
    private val channel: MethodChannel
) :
    NfcListener {
    private var mNfcAdapter: NfcAdapter? = null

    //读卡开始时间
    private var starttime: Long = 0

    init {
        mNfcAdapter = MyNfcManager.enableReaderMode(activity, this)
    }

    override fun onNfcEvent(tag: Tag?) {
        /*result.success(
            mapOf(
                "success" to true,
            )
        )*/
        /**
         * ReadCardManager.eid.readIDCard(tag, mResultListener);
         * 通用模式，同时支持二代证读取和eID电子证照读取
         */
        ReadCardManager.eid.readIDCard(activity, tag, mResultListener)
        /**
         * ReadCardManager.eid.readIDCard(IDOCRCardType.IDCARD,tag, mResultListener);
         * 设置只支持二代证读取
         */
//        ReadCardManager.eid.readIDCard(IDOCRCardType.IDCARD,tag, mResultListener);
        /**
         * ReadCardManager.eid.readIDCard(IDOCRCardType.ECCARD,tag, mResultListener);
         * 设置只支持eID电子证照读取
         */
//        ReadCardManager.eid.readIDCard(IDOCRCardType.ECCARD,tag, mResultListener);
    }

    override fun onNfcError(has: Boolean) {
        /*if (has) {
            result.success(
                mapOf(
                    "success" to false,
                    "msg" to "当前NFC未启用",
                    "errorCode" to NFCOpenFailCode
                )
            )
        } else {
            result.success(
                mapOf(
                    "success" to false,
                    "msg" to "设备不支持NFC",
                    "errorCode" to NoNFCFailCode
                )
            )
        }*/
    }

    private val mResultListener: OnGetResultListener = object : OnGetResultListener() {
        override fun onSuccess(result: EidlinkResult) {
            val endtime = System.currentTimeMillis() - starttime
//            tv_msg.setText(
//                """
//                读卡成功  $result
//                耗时: ${endtime}ms
//                """.trimIndent()
//            )
            val identityBean = result.getIdentity()
            if (identityBean != null && !TextUtils.isEmpty(
                    identityBean.picture
                )
            ) {
                val bt = IDCardPhoto.getIDCardPhoto(identityBean.picture)
                if (bt != null) {
                    val stream = ByteArrayOutputStream()
                    bt.compress(Bitmap.CompressFormat.PNG, 100, stream)
                    val byteArray = stream.toByteArray()
                    channel.invokeMethod(
                        "onSuccess", mapOf(
                            "classify" to identityBean.classify,
                            "idType" to identityBean.idType,
                            "birthDate" to identityBean.birthDate,
                            "address" to identityBean.address,
                            "nation" to identityBean.nation,
                            "sex" to identityBean.sex,
                            "name" to identityBean.name,
                            "endTime" to identityBean.endTime,
                            "signingOrganization" to identityBean.signingOrganization,
                            "beginTime" to identityBean.beginTime,
                            "idnum" to identityBean.idnum,
                            "signingTimes" to identityBean.signingTimes,
                            "otherIdNum" to identityBean.otherIdNum,
                            "enName" to identityBean.enName,
                            "countryCode" to identityBean.countryCode,
                            "version" to identityBean.version,
                            "picture" to byteArray,
                        )
                    )
                }


            }
        }

        override fun onFailed(code: Int, msg: String, biz_id: String) {
            channel.invokeMethod(
                "onFailed", mapOf(
                    "msg" to msg,
                    "errorCode" to code,
                    "bizId" to biz_id,
                )
            )

        }

        override fun onStart() {
            super.onStart()
            starttime = System.currentTimeMillis()
        }
    }


}