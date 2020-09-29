Return-Path: <SRS0=LTc5=DG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060E9C4727C
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 15:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75FAA20739
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 15:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="DY3wVI46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgI2Pw6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 29 Sep 2020 11:52:58 -0400
Received: from mail-dm6nam10on2118.outbound.protection.outlook.com ([40.107.93.118]:21153
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728401AbgI2Pw6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 29 Sep 2020 11:52:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTGF7NI5mDqwZUARwuzlIHNTo5Uxewl4b0pSSRSffOpZXlFc157twPv/8rmsT5RWu9i8n15d61Ed1NkrRD8q3LlJGKb49NVwpLQEIQUagulWEWDTyysmkyygmWqdrnxcM2k+T+XnYPkxQKLUFbga3jYW8toWh0T5NwIPg5zaC3vbeB8pNZtOMgmeUwfeypdMO/PoHxh+hSMRz/rlPb0POOMCYn0FBDyNszuXhY54TgIw9xZsdxTmDCUsckVkE8eHq6bEKuV2lvpPyGBlzP0fKyis/P8DUFC0vT6AO2Qy9/YOiBoFVygWqtdfNgHJd+W3f3Be6n9Xx4UZq0u25qYvQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJ3OnC3jTzSONEv6oesCrcYo+F4ugmCy7UsSx4QO/o8=;
 b=dPCnXGp0ykRKXCeDD+A+w6AGyd5QxfSF37fE/clWxMygBA31d/u7PqoqSnPa7kkKYXAAiow6fhAdsGTQq8bZHwDAAnnJXXzyNk2DNO4jWhNjtf+vdbWvJKohVvOLinRFVTeE5mPle4qrdi0GmdtE03MU1o79krNGIuioBl3bvN7ghWM+468mbxmIHzrSbCy64BRImQ0jwhpWRBnMBd5/jwm+PUp8TaMfQOp9of9katpCxeovbdQo/ouwESV8VtVqQlnliHfz5rH7PwP1HOGLPhYXlsYkqsOCD1e3jT5+kAjH0SnlQzMvp7i8Na+FPxJUWlrAQjlLeBsNRE+qp7XHzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJ3OnC3jTzSONEv6oesCrcYo+F4ugmCy7UsSx4QO/o8=;
 b=DY3wVI46kwPy/ovYHgHRSO+5xEI7eryDtg5WHQMZHgh7TDjORXzAx+b5F4jmPrmtSLQ9L1laY/uFDKKDXJXNAZgKwrd42Tc5Cdjun2scGvhbLXWhg9H6otPGnN55K/5/SnStVMmiQI5sTmFyoXIs6N2QzTyn2u/rNfz2ts+uq7o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4007.namprd11.prod.outlook.com (2603:10b6:a03:189::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 29 Sep
 2020 15:52:53 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 15:52:53 +0000
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
From:   Jethro Beekman <jethro@fortanix.com>
Subject: Unable to load large enclave
Message-ID: <9393934c-e390-a7df-2e74-08f16d4f48d4@fortanix.com>
Date:   Tue, 29 Sep 2020 17:52:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030701090303040307060009"
X-Originating-IP: [213.127.14.5]
X-ClientProxiedBy: AM4PR0501CA0061.eurprd05.prod.outlook.com
 (2603:10a6:200:68::29) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.14.5) by AM4PR0501CA0061.eurprd05.prod.outlook.com (2603:10a6:200:68::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 15:52:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cff5582-0eff-4ac8-8741-08d8648fb968
X-MS-TrafficTypeDiagnostic: BY5PR11MB4007:
X-Microsoft-Antispam-PRVS: <BY5PR11MB400710B70D0627B628F807B1AA320@BY5PR11MB4007.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6akazDBgQgjVq73EXrwU50UOhh4gahQGzq/rBasCc4QrlN0E6SXr5lnxDC3XQTR5vVj/smP6Wu5zw36fCrK4o5ItqPb/xrw/rC74vYEWjvw9Wwek4roLrVDhXD5bByTb/87it0i4mbWIJ+7SsN1yctikH2kT4+sVU2UJji0Zf1Z6xVmXe7Cr5HHhpuzdVL+QePlH89ESIoTu0UgMdee9+9xy5LQa0QurZFXkAV05lI04gTbR1D6wgwZ7Ka6VCAga1G9VjL87IqbWeng8tDzV/RtzQCq43wSeuNQyL2mG3w4/mt/eaFGglUiGon1dqGyxHTerVAwg3Mj/RE8nq592D7yX0HU9YY0Jez/I/nsxfAdlu9fu5b0jeHIKdg4gUujFLU71gkTZ7SmC0JMvYz1MWexsr0u5nSXKfwEoGFcSU+8XHV4GQqPlBXIrWJhIqbVUa6oKP+Xgw8qN09SBMms8QRk3RdKSA3Pt95iL3HP6AeE2wqLDR0MijFeK3AaLtCf3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39840400004)(396003)(366004)(235185007)(52116002)(478600001)(956004)(66476007)(2616005)(16576012)(5660300002)(316002)(66556008)(33964004)(31696002)(86362001)(6486002)(6666004)(186003)(16526019)(8936002)(26005)(36756003)(66946007)(6916009)(31686004)(2906002)(966005)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Q0WLTqKCgyh8W8qmHRN7rYd96jzV1JaDyxlkVLI3ofKfydzedyjsOKgR1VkRvW6GPV60oCIsUfTNu/RpCFs3ntDZwj0gkamnDklGoHzaR8zn/6wBOwVg+qcvrvn3Fo4hN0LNsHrhLm8QmzHpJdly6QKDL3Zk2lTHqm1MlpiKzQMk80d6a+baxRTrsvT81GHB8g3QaUeuCqiQCz0Kvi2T7zKwbwe3zi/dGdlxHOp6m8jJgph2Sy0EhfCHO/dyJDOwFZqwUC/YXdhiPjpAHj11vYUAgo/gScJ6tayFkm9ggzNr03PskGQKEptdCxiqgSJ5PJXQEdfEGMJWaHKK6KTuxNHqlWCa1ilfBTNORXimJ1gqRP8eAu4wYFF0zqNxvajUIXVNjfrm8hxLGabbZYpRmDyrQB8EyhqCRV8dP2/oNEZiAU/1Y0U3WZXd8X3Lk5dvP1AIUwHXJ5SU2w62/yJGALxm8H716YluxwHKC2Hz8DJ1zLRT6LN4iejHoAx8Xh99Mez/NiIxQFuIS4E6UEXMXX/NRB9FYcVg4H1KkN9lfEwpMLYn5lDhB7sWlV3UOCLClyIkMdD8YgDSjWJa0jtDjhDiUhH3KtaBBvwu+cbP1wF/Rpjt7fv/1MHDlfxDSAwQ9yd6NifMYQgDYt1IX9y7Yw==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cff5582-0eff-4ac8-8741-08d8648fb968
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 15:52:52.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJhdynUZpVOOvLmOehY7RJuBIEyJHSdE8tzLsF0MgzH8IoECRJuXSrZg1Wa0DJTDGMBG4rqHwt3vJfkMzWNRng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4007
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms030701090303040307060009
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Since the latest API changes, I'm unable to load a large enclave. The tes=
t program at https://github.com/fortanix/rust-sgx/blob/sgx-load-large-enc=
lave-test/src/main.rs always fails with ENOMEM after loading 0xffd6 pages=
=2E

I've tested this with v36, if there's reason to believe it has been fixed=
 I'd be happy to try it out on a newer patch set.

--=20
Jethro Beekman | Fortanix


--------------ms030701090303040307060009
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
JTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJl
dm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVw
b3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUvpepqoS/gL8QU30JMvnh
LjIbz3cwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBCwUAA4ICAQAmm+cbWQ10sxID6edV
94SAhc1CwzthHFfHpuYS30gisWUfWpgp43Dg1XzG2in3VGV7XrzCCGZh4JM/XQWp+4oxmyV4
2Qjz9vc8GRksgo6X2nYObPYZzQjda9wxsCB38i4G3H33w8lf9sFvl0xm4ZXZ2s2bF/PdqvrK
0ZgvF51+MoIPnli/wJBw3p72xbk5Sb1MneSO3tZ293WFzDmz7tuGU0PfytYUkG7O6annGqbU
1I6CA6QVKUqeFLPodSODAFqJ3pimKD0vX9MuuSa0QinH7CkiPtZMD0mpwwzIsnSs3qOOl60t
IZQOTc0I6lCe1LLhrz7Q75J6nNL9N5zVwZ1I3o2Lb8Dt7BA13VFuZvZIzapUGV83R7pmSVaj
1Bik1nJ/R393e6mwppsT140KDVLh4Oenywmp2VpBDuEj9RgICAO0sibv8n379LbO7ARa0kw9
y9pggFzN2PAX25b7w0n9m78kpv3z3vW65rs6wl7E8VEHNfv8+cnb81dxN3C51KElz+l31zch
FTurD5HFEpyEhzO/fMS5AkweRJIzwozxNs7OL/S/SVTpJLJL1ukZ1lnHHX0d3xCzRy/5HqfK
3uiG22LPB5+RjNDobPAjAz2BKMfkF/+v0pzn8mqqkopQaJzEAbLbMpgQYHRCjvrUxxwjJyUF
b2Z+40UNtMF4MTK7zTGCA/MwggPvAgEBMIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwH
QmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBT
LnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBu
kmvE8GLB9+EYd88699DiMA0GCWCGSAFlAwQCAQUAoIICLTAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA5MjkxNTUyNDhaMC8GCSqGSIb3DQEJBDEiBCDH
Xj569U+xS44p3bu2Dw+B1f97TrU/+vAXa8yJ/gXu3TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAFZHttMoVNYqxbXuQCAQa7OFUS0VReqUmWoPVAnnEDMWzNbr25h7
VhwA6+e3CyZtrLP0uFQcAXy789kD1ma4YGdoyAKwvx1St8o2B8WaLmVmHOmx2so/WP2E5WUl
lsEFDg1aaM9LtVVhR8zKciPoQv2c8wENr5Oehtvjp3mqn5dDWNMu1ngmDy7xHACBWl4J4tsB
wRRQyAMtyvahwSqPxjtA/dnZRBITslXAsy7YpJfb3FSRTHpIewpmfP55iMm1h3oFkOP3EpJ1
JSoMkhL9r0oLHZOLCPs3hnKvUGAfFr/PQMDL8OUwZPAqSpEIBwT2Jae3y29nKxRDQtVlFo0S
mVkAAAAAAAA=

--------------ms030701090303040307060009--
