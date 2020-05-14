Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AE6C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 06:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC59A206B6
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 06:31:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="QvO+mk3E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgENGbh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 02:31:37 -0400
Received: from mail-bn7nam10on2124.outbound.protection.outlook.com ([40.107.92.124]:56544
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgENGbh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 02:31:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ogYsvmdUH0FC9j8N50Py3SA5a2jfG1lzjJLQe7GpwRfW0FY/tv6PUBZh1VZQDDW6So9TzocGRoxAD4ml/goy9bVSV1XNt7mbrfb6g4JvHO8zHJ6YDpUn1iKchgZuivqXqOKOCqypIhhRq93J15ZC/L3Vlys7jdCbFXkaG37CmfYh806VnkLoTNSWOtOg7c+6ZaDab3lgbamBY2RcfzWlrYojiOa7sYvWP2q0Ft0ROD84MuS0eyNehfTKIl/WsG/yJOi9ntyQcFdgcNZsfd1bgdPF5LlPU7R34H0YWrY18ByLPJc8Xx/Lu5D7kI27L1y2vUVGObGt4JV3BkKasLKJSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wfy4LmEJJ+QmJ8Vc/2/dLeU/GfGu0Bg1WcSq2ymC+3g=;
 b=EXeuE87HsDc5K5QaZ+6+XmAt6KyDQ3/yAxJ2irze/xYF/qYLc2mxdXFbcZ83JIRLTLthRXfs4U28SUeASuu5eNqKji0t0IaBKn9k0cHK3aDfoYhDnFjqr4q4HiB0/Vpt2tC9wS5YRwA9Kej0xI1QKjHmYDqcncg1uGY7EV5gdMt3ZbEw7Rk3raJCoZFL5Zgz2+yN3lGk+WhKj1IwNU0w8vzHkIF6gWZo9dTjLBAjWRD+c/045LnjhmasiW2rUh0J2cWfj2NTSBEtZA67ujL1tVWTRIgUrWwusTG2qR+J0bDNv0gFdXE/UCdHEtoOjgZOJ00ZxAdhLyRi8cxBs4jSfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wfy4LmEJJ+QmJ8Vc/2/dLeU/GfGu0Bg1WcSq2ymC+3g=;
 b=QvO+mk3EMQyORZNkcDG2zRydzH65LkCieQeE7Hm/8wo21zkz+/BGE1Rk/vE/NJItm0sjGekVbPuyb5eTyYR0DRbps3kyYvpTyhfcKciZTOxb0hdRWcSqFLGQTJS8RVquZ1IjqF987CxB7+RuQLKS6dpRq9T9hcU8wSLEG4fcj3k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4211.namprd11.prod.outlook.com (2603:10b6:a03:1ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Thu, 14 May
 2020 06:31:32 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::48d6:af47:b6c8:fe6a]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::48d6:af47:b6c8:fe6a%7]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 06:31:31 +0000
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
 <0d485f780ac9809229290762931cd591e6f8156a.camel@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <a20e2eb4-1714-7975-693e-1c6aca7ea77d@fortanix.com>
Date:   Thu, 14 May 2020 08:31:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <0d485f780ac9809229290762931cd591e6f8156a.camel@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020901080807080700030501"
X-ClientProxiedBy: AM4PR0501CA0063.eurprd05.prod.outlook.com
 (2603:10a6:200:68::31) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.61.179) by AM4PR0501CA0063.eurprd05.prod.outlook.com (2603:10a6:200:68::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Thu, 14 May 2020 06:31:27 +0000
X-Originating-IP: [213.127.61.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69377693-0ec9-4667-00be-08d7f7d070e2
X-MS-TrafficTypeDiagnostic: BY5PR11MB4211:
X-Microsoft-Antispam-PRVS: <BY5PR11MB42112EACD2D7D328BEE12E2EAABC0@BY5PR11MB4211.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YsnSSPfVuiyncfh0GTvtGU1Y6RTcOBJ7fOYw9MKTe3l/Dh9PmQ97aqdCjbAX2H7sMGEBdRaAvcMIeuayCEx9l1K9hmN62vNHjhgHFKVQfD6OgK0Tko1P/kMRkZJ11GDxkqrIfNJB0nqNxlEu+Oi2YN1Y9GT8FL+jb1EqJIjWlGrip3kMvuusyWIc5hjcu/iqSJGbvRzr/U0nnzNQoQZ90Q9HcArntc/BTvsVI6ZDAro6oGRdMxpxVl2leql6+HgnxUHc2GEEOZM7k+vVIktTgCpu2c2CQ3OiJ+rqeQkURXmN0JGLxYrHX8Ine3bSLPua/CBJipcMzKp4KvFTze9gww95s1CpA0Sk7cQOSVbFQZwFdBhh69/GdSANHIAPnmCo/F8eTHoLKAYQji8MKXUsb8Yn8yoRaCZHcZFCoBDskBR2Lq4mNrK88ZueomULQwJIxCbs6Vz4Y/Ksc4HkWau5DOBz8Xl3qdZETe6IfE7Ft1g0wy8IN6rkcE6B8m5nftf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(136003)(39840400004)(346002)(376002)(16526019)(6666004)(26005)(8936002)(110136005)(235185007)(16576012)(316002)(956004)(186003)(2616005)(8676002)(66556008)(54906003)(66476007)(66946007)(53546011)(564344004)(4326008)(31686004)(7416002)(6486002)(52116002)(36756003)(31696002)(2906002)(508600001)(86362001)(5660300002)(33964004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: K0ZZ+mPpUVv734RxOaT7lR27yHOKNZWpS0kRA2lFvyaAb8UPviUpMfj4fmWnRSvAZxZCeP5TpXnCVpP33q7xNmPCX+YwTltTBwQyyBZwjm7ChD/SjrHrxIq3smwBaubfZyArI7AeON32T3f73RXjJHZ7k7nFv7T0XsXlI/T3JoY9wsbWnsNg2mFmsLuA6cCj6jMUgB0SpCTv3jte0EV5yeTlo3VYi4AMpqG4/N09sWQa0EKqJu11WX4xk8wG6v8OS05MHA76x6l4oJHi3U3S0gXfPpqOOJVJFIg8zKgBaXBaJxZ7CZ1P59CFdfPoDcx68IrQNuQrsQcd2SpPQGwiww9WpPQVwkfl3jCqpaujWCKPzBVih+GUamjjYf/8TWqokX1DZDBusSz1Opnw4Yf1bv/zOu8qf4u+G5gKDUimo6Iu3LcO08lPYUgIbxzpeRToD2i+zuCBxA2UnAQkAMcIudZkt2qmp0VCI8SVeIBO3RvuO2J9VrmnWJxfjD6O4QoT
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69377693-0ec9-4667-00be-08d7f7d070e2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 06:31:31.7840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qnkhn0dMU6kOCnQAY3XRgXFshFkFuXiip6LV+HNUY5/z1dxSQd2ko1j7vV6EXmE80qq6Eay7gjFHT2DHIQ142Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4211
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020901080807080700030501
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-05-14 00:14, Jarkko Sakkinen wrote:
> General question: maybe it would be easiest that I issue a pull request=

> once everyone feels that the series is ready to be pulled and stop send=
ing
> new versions of the series?

Sounds good

--
Jethro Beekman | Fortanix


--------------ms020901080807080700030501
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
C54wggVPMIIEN6ADAgECAhAFFr+cC0ZYZTtbKgQCBwyyMA0GCSqGSIb3DQEBCwUAMIGCMQsw
CQYDVQQGEwJJVDEPMA0GA1UECAwGTWlsYW5vMQ8wDQYDVQQHDAZNaWxhbm8xIzAhBgNVBAoM
GkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBB
dXRoZW50aWNhdGlvbiBDQSBHMTAeFw0xOTA5MTYwOTQ3MDlaFw0yMDA5MTYwOTQ3MDlaMB4x
HDAaBgNVBAMME2pldGhyb0Bmb3J0YW5peC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDHWEhcRGkEl1ZnImSqBt/OXNJ4AyDZ86CejuWI9jYpWbtf/gXBQO6iaaEKBDlj
Vffk2QxH9wcifkYsvCYfxFgD15dU9TABO7YOwvHa8NtxanWr1xomufu/P1ApI336+S7ZXfSe
qMnookNJUMHuF3Nxw2lI69LXqZLCdcVXquM4DY1lVSV+DXIwpTMtB+pMyqOWrsgmrISMZYFw
EUJOqVDvtU8KewhpuGAYXAQSDVLcAl2nZg7C2Mex8vT8stBoslPTkRXxAgMbslDNDUiKhy8d
E3I78P+stNHlFAgALgoYLBiVVLZkVBUPvgr2yUApR63yosztqp+jFhqfeHbjTRlLAgMBAAGj
ggIiMIICHjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFH5g/Phspz09166ToXkCj7N0KTv1
MEsGCCsGAQUFBwEBBD8wPTA7BggrBgEFBQcwAoYvaHR0cDovL2NhY2VydC5hY3RhbGlzLml0
L2NlcnRzL2FjdGFsaXMtYXV0Y2xpZzEwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNv
bTBHBgNVHSAEQDA+MDwGBiuBHwEYATAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hY3Rh
bGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMIHo
BgNVHR8EgeAwgd0wgZuggZiggZWGgZJsZGFwOi8vbGRhcDA1LmFjdGFsaXMuaXQvY24lM2RB
Y3RhbGlzJTIwQ2xpZW50JTIwQXV0aGVudGljYXRpb24lMjBDQSUyMEcxLG8lM2RBY3RhbGlz
JTIwUy5wLkEuLzAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRI
Q0wtRzEvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUAXkM7yNq6pH6j+IC/7IsDPSTMnowDgYDVR0P
AQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4IBAQC8z+2tLUwep0OhTQBgMaybrxTHCxRZ4/en
XB0zGVrry94pItE4ro4To/t86Kfcic41ZsaX8/SFVUW2NNHjEodJu94UhYqPMDUVjO6Y14s2
jznFHyKQdXMrhIBU5lzYqyh97w6s82Z/qoMy3OuLek+8rXirwju9ATSNLsFTzt2CEoyCSRtl
yOmR7Z9wgSvD7C7XoBdGEFVdGCXwCy1t9AT7UCIHKssnguVaMGN9vWqLPVKOVTwc4g3RAQC7
J1Aoo6U5d6wCIX4MxEZhICxnUgAKHULxsWMGjBfQAo3QGXjJ4wDEu7O/5KCyUfn6lyhRYa+t
YgyFAX0ZU9Upovd+aOw0MIIGRzCCBC+gAwIBAgIILNSK07EeD4kwDQYJKoZIhvcNAQELBQAw
azELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5B
Li8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENB
MB4XDTE1MDUxNDA3MTQxNVoXDTMwMDUxNDA3MTQxNVowgYIxCzAJBgNVBAYTAklUMQ8wDQYD
VQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4v
MDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENB
IEcxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwPzBiVbZiOL0BGW/zQk1qygp
MP4MyvcnqxwR7oY9XeT1bES2DFczlZfeiIqNLanbkyqTxydXZ+kxoS9071qWsZ6zS+pxSqXL
s+RTvndEaWx5hdHZcKNWGzhy5FiO4GZvGlFInFEiaY+dOEpjjWvSeXpvcDpnYw6M9AXuHo4J
hjC3P/OK//5QFXnztTa4iU66RpLteOTgCtiRCwZNKx8EFeqqfTpYvfEb4H91E7n+Y61jm0d2
E8fJ2wGTaSSwjc8nTI2ApXujoczukb2kHqwaGP3q5UuedWcnRZc65XUhK/Z6K32KvrQuNP32
F/5MxkvEDnJpUnnt9iMExvEzn31zDQIDAQABo4IB1TCCAdEwQQYIKwYBBQUHAQEENTAzMDEG
CCsGAQUFBzABhiVodHRwOi8vb2NzcDA1LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMB0GA1Ud
DgQWBBR+YPz4bKc9Pdeuk6F5Ao+zdCk79TAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
FFLYiDrIn3hm7YnzezhwlMkCAjbQMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUFBwIB
FiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwgeMGA1UdHwSB2zCB2DCB
lqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRo
ZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIw
OTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0
cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAO
BgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQELBQADggIBAE2TztUkvkEbShZYc19lifLZej5Y
jLzLxA/lWxZnssFLpDPySfzMmndz3F06S51ltwDe+blTwcpdzUl3M2alKH3bOr855ku9Rr6u
edya+HGQUT0OhqDo2K2CAE9nBcfANxifjfT8XzCoC3ctf9ux3og1WuE8WTcLZKgCMuNRBmJt
e9C4Ug0w3iXqPzq8KuRRobNKqddPjk3EiK+QA+EFCCka1xOLh/7cPGTJMNta1/0u5oLiXaOA
HeALt/nqeZ2kZ+lizK8oTv4in5avIf3ela3oL6vrwpTca7TZxTX90e805dZQN4qRVPdPbrBl
WtNozH7SdLeLrcoN8l2EXO6190GAJYdynTc2E6EyrLVGcDKUX91VmCSRrqEppZ7W05TbWRLi
6+wPjAzmTq2XSmKfajq7juTKgkkw7FFJByixa0NdSZosdQb3VkLqG8EOYOamZLqH+v7ua0+u
lg7FOviFbeZ7YR9eRO81O8FC1uLgutlyGD2+GLjgQnsvneDsbNAWfkory+qqAxvVzX5PSaQp
2pJ52AaIH1MN1i2/geRSP83TRMrFkwuIMzDhXxKFQvpspNc19vcTryzjtwP4xq0WNS4YWPS4
U+9mW+U0Cgnsgx9fMiJNbLflf5qSb53j3AGHnjK/qJzPa39wFTXLXB648F3w1Qf9R7eZeTRJ
fCQY/fJUMYID9jCCA/ICAQEwgZcwgYIxCzAJBgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8x
DzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5Njcx
LDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZY
ZTtbKgQCBwyyMA0GCWCGSAFlAwQCAQUAoIICLzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMDA1MTQwNjMxMjFaMC8GCSqGSIb3DQEJBDEiBCDk5dOyRZbU
v9sCiVovQsWJwnOgaaphgmtJiRLhlNunyTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAEnWXjrd75H07UGhbG0r5X585tOMQztpyYDrpgREj9NFeILjIR+wTSxmw
rR6jhh4ckCj7ppvLqeNvrBcgsydq55fvl0Iy5JdiI2iAasA5Qnqt58eRvPynv3dxhWBAjUNq
RC+lPz5jh9290gmFYDzI7LZ2tZgV0xGeqiv2nRmMCdv/fTBhSNfOiR6yoDDnCAcIzHOhZfWO
sm54UxlkD+d5tfBNGCbTufejdc/XA8ruBCCcUcfbRVxqpVJGwbkgK3nPEKtTd23StutLbHRm
jyM/HDS0kgRO8nX2e2KbOfB5CTpEDI/wUy0yk//Nwkzm4rFiZZP/FbpBK8k6OXid20bwhAAA
AAAAAA==

--------------ms020901080807080700030501--
