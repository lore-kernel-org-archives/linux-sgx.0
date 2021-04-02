Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF57C433ED
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 18:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D86A7610F7
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 18:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbhDBSbj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Apr 2021 14:31:39 -0400
Received: from mail-mw2nam12on2097.outbound.protection.outlook.com ([40.107.244.97]:57825
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230092AbhDBSbj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Apr 2021 14:31:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfjhO178vzBuieA9DImCkDNSWlprDIemicNTYzhByhI/8ke4WEJOItzF0Nx58dY2M5DCYGvxfS81bwlsyIRSMwwHMOvcqQBmPwLiDzDmLWZSwry/tFsHl2XNIZ614B2E16fdI/6rHfJS6Ui7klCBnvVhGDttJz20DRXzCmCwjKKoDIty2u7jR7x4htMPSmXKmde0KyVw7rjFbJvGQFTUE/Uh5n0BW1n9u6jPusXLC7oGuc4Jdr/lK58KaREDRqlSjELCkY9vGj4OztIKKELCXVz32XiydUD/TymAgk31esvWdN14l14peS2B5ISNoCiM+cVZ/L3lr2AZuccRsIXXkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6GiJNnx/yQptwuQ5b3N7meHKKWiQoVUJe4Kp87IfjE=;
 b=XHK/SynchrnSMR7B3BdfecrQYbpz2IL1Ij0y7b/Unt+mMQ1qBkkTMP5joq+ozaosR7HJQrEzSDjcCeVOa7FKZL3qurcoYqxjSdms8BCBjHeQ7lQQkwDJre/pXnUEF0WtdEFdRywTg1Z/U6+RMYZwjtGjOBzmSlIsLj6saMYJ1YEhIe0TL3NTdDNtaun148MSM3+Uft21qCJPKz4xH8yiagtgKgXOS0gqep+QAE0e7ZbCujxM0TlfYB/vEftizvmJbwgHEKO4BHYcXeSl1N1Ku36bzWjPZiTpVBdjDydBeVHLAZh4EOAPbn/6Aq/FwSdC/z42RrNf4kGYjrd853KmiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6GiJNnx/yQptwuQ5b3N7meHKKWiQoVUJe4Kp87IfjE=;
 b=k/fWurUnI+TVEaVPwYTlqd3sJoGGhb8c15PLCoJK7q4r58VzJRStAnzNPKX73lkCKEUKsFwKwqqr+gLw0BjAFeVf+6F8H4w4xSBj/yIFB7B3EXXrosg2/rGBVqFWymfIXwmekyWwVow1xS4Hk0eziKBcPAnb9+GuNHxXmUT2dlQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB3895.namprd11.prod.outlook.com (2603:10b6:a03:18e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 18:31:36 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.3977.033; Fri, 2 Apr 2021
 18:31:35 +0000
Subject: Re: [PATCH RESEND 0/3] x86/sgx: eextend ioctl
To:     Dave Hansen <dave.hansen@intel.com>,
        Raoul Strackx <raoul.strackx@fortanix.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <9688abee-6ba7-e1d9-701e-a5cabac36269@fortanix.com>
 <c7b19652-3b5a-e864-1e0e-3e3d26944398@intel.com>
 <ece49a38-c84d-dba7-6039-b409511e7303@fortanix.com>
 <0498080e-6fdc-ed6d-8efa-d9c3265fe7e5@intel.com>
 <9d15aae0-078a-ed72-6c14-155cd1bf27c5@fortanix.com>
 <247ffbee-0ef6-1b6f-75aa-2dc06df42d5d@intel.com>
 <f94e05f7-e6d0-9253-d74c-09cd200702af@fortanix.com>
 <4a122198-054f-609e-e96c-b69ff941c8a7@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <9a841584-65e8-31e9-6bd4-0140b33434e8@fortanix.com>
Date:   Fri, 2 Apr 2021 20:31:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <4a122198-054f-609e-e96c-b69ff941c8a7@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020300010607090309040003"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM0PR02CA0185.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::22) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM0PR02CA0185.eurprd02.prod.outlook.com (2603:10a6:20b:28e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Fri, 2 Apr 2021 18:31:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 876369cb-4b0c-46e5-aa23-08d8f6058bda
X-MS-TrafficTypeDiagnostic: BY5PR11MB3895:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR11MB3895B82AE59EE1D57824EF9DAA7A9@BY5PR11MB3895.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: El8n85Hp+8gRsd6d+Vds8UFP/wCODJn3Gy32IvkBjhKVR7cSKNujVJMHipVw95kdolCVCrBKtwi4RK844V7SaWikERXptMqdoepwrCE3GJfSdeoAGxcyXUG48g3o9LEBJypl3vLZjCTa4XzOg1MkBfxMaKP5lrWI4zbUnCTu5NOOjH0IIVRKG/A4rjsuZdl0pxzas76oUT3Ua8JqwES5UjcG47yi38cZwsdv8Snt5W1odEOdcxr3Plz6SYScrTaRs9fx31qBSGdhXONq2SXRSuAP28JN1tHQnQoIcN6pgbQe3E1gyRA/dtCmpVUkRscpD/le1G1SLyH0OJ7FpC3O+t55QFLG/U+YcR7iVvN2RMmGqV7Xfpkgwv9Y943cvsNGOAA2/tsam8ZFyDsLXqbrSXqVjY5cCeCd5nmFjJxBYwRQ2J2JZa84HgbWEyLjnJ6Evhe+JPJlpHtoo20wZvx0Vpp0W9caSw6xHOvYQ4H2tSkJVWSkDfTwWUZEmjwLhS1qLqFJFKXxa8KJBU+uMvvNYCiTw6XqIKhbvMELXKR3v+F4uv4hpUtGk9zahGrRRIwvzvr6UZm4WxK/qwFdc0UuksNnrUm2nWpfaTvDw5SewDTnz9Rsd+s7ZfU561GoKaLyTFVPNKQ6dwpUrmiOu2Gcdilgi92k5e4KDVW4PNNkSC8TswEYCLSQhqcePaojCHeOZCOhOLRKhgmamQ3LEPY0nzoTIUlwMTDXfwG1OwqAPyk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(396003)(366004)(346002)(376002)(8936002)(921005)(53546011)(110136005)(235185007)(52116002)(2906002)(2616005)(16576012)(316002)(7416002)(6666004)(31696002)(83380400001)(16526019)(33964004)(38100700001)(26005)(186003)(66946007)(5660300002)(8676002)(66556008)(478600001)(956004)(6486002)(86362001)(66476007)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NHVsWGpUeHVUUUtEbWwzVS9DeWlvZWFKd3JYbWxRZ3NIRmJHSENPdXJhTUJZ?=
 =?utf-8?B?U3RqT2tJN3BoRzkrZjJhQnUzUGppRlBhMFpINVI5dlpKbWRsbEU5M3Rhc1Ny?=
 =?utf-8?B?VWlGbmF0cmFWclVZZGJjRUozN3p5aHZYYUYyOWdRNEJhQzhMUGtPa1R1TURn?=
 =?utf-8?B?cSs2SzNqNTlMcTNIQW9xampLTlVuSmlDbmJCL0hRcVlqT1hzbDV6RUk2akhw?=
 =?utf-8?B?OGo1WllHd0pOK0VPVXhLbVFaVWE2M2RqVnlRdmoyN0tvaVdid01ieHFyTnJT?=
 =?utf-8?B?ZERpRTBMbS92TjNkVHN4TG02SUwwVmxqZHhMQWVpNDhTUkRkcFdoQnJtMkFD?=
 =?utf-8?B?eXUzMXlxREpSb0cwYiswdmZ4eUcvQU9QZmM2eS96V055VlloSnhGQTdhbUdK?=
 =?utf-8?B?K0NjbVlKWDRQcDg4Sjg0V2MvWnExbktNS2pWelRQYnA1Ujlma0wzOWRvTW11?=
 =?utf-8?B?b25kTDEvRkYzRDNHSVU0MEhNYkFpZDZGL3hJWVNISGNaaXdGRzU5cG9GNk5t?=
 =?utf-8?B?a1RXWTRDRjMrTDZpcXpnSXNJa3NRSTM3N1ArVDNuV1hLM3ZzLzJQZHRWZGY5?=
 =?utf-8?B?STBpOWhsRkJFMzkyanR5WVpoTVFxeDRBWUFNaHRUYmJPVTRCY3BGTUozY01X?=
 =?utf-8?B?N2NvWlBPdEhRdXJXa0hsV2F5VTVYdk9PRkQxcFVKdW4rMk05aXNjYzVWV1RH?=
 =?utf-8?B?NUZXTzJJenVNaWd6MnlmTk9WY1p3d2tGNzlkamovN3B6bTZaT3g1TlRXeEpK?=
 =?utf-8?B?V24rQUVMZHhndHRHZGRuUS82a1h2eW9GeGNhNW9LdVRnVlAvWXJhdXRpWGVD?=
 =?utf-8?B?NGxGaHVzUUQxLzJxbENnTGtrUjV2ek5xOEpkVlhKVkZZVnZqc0p0ZWp0enh6?=
 =?utf-8?B?RjZoL29jUWFGMXJKYlV1eGZadjFZRzQwcmlydmloQ3RCNjJmVnBucU4rdCtJ?=
 =?utf-8?B?R0lUZWhNc0NCUDMzK0RxV0htV3NUbFBuTUNsR284T3ZDZUgvOStrbEVkUVRr?=
 =?utf-8?B?NXNtb3NNQmJONktrWjcyVHhNN2x5b25kQWNkNWMvUDF3QXdsc3N2S092czBZ?=
 =?utf-8?B?YitYdWwwNWc5VUFMSlE5SVVPaDlTK1dLbngzeXErY2lHU0dkM3orL29wT0o2?=
 =?utf-8?B?amJpSzZqZzE5enFoUjExMmZnUjJIZWxOSG1TREZRUEw4V1lOMldSOGhUQk9U?=
 =?utf-8?B?aDdzVnFJb2JRSmpwS2lrZFIya1FNK1c1RWJjZzFlRng1S0VtTXBOUTZGeHdM?=
 =?utf-8?B?bFJtNTdveEJ1dy9paS8rd29tcERFSkpYUnNDWE8wN3l1N0ZJUm0rSTBsYS9t?=
 =?utf-8?B?NXAvN204MlN4dnFKYis4Z2ZCU0xmNFBTYW83V2puU1ZWTGExaVFoZTdTQVlV?=
 =?utf-8?B?Sjl6b1dVVDd5M000VXJmcmFEeExTU1hkY0w5ODJDM2Z6cGVMUWIwc3lydlNG?=
 =?utf-8?B?SERMUDFRVkY2TVdlRGJmYk91WmxqVU5qZXZZV05WNGhROEpRLzU1K09TMzNo?=
 =?utf-8?B?eTZ5ZDlBVFd6RllzWTR1MDNlSEZyR01CM1VielB5czZnNld5Y3YvNUdsTDJu?=
 =?utf-8?B?TGl1dVJUZlVVTVRSNGdUYUhaakJnY3hzVmN0KysraWhjQmtVVVZmMWdXcGdY?=
 =?utf-8?B?TlIvekY4ZHh1YUpvMWt4WitZM2QwWm4wMCtxTzBMUnpWblEyQ2JOOG05QjY4?=
 =?utf-8?B?bzJ2U0VTaGhJdUF0enN0SEdMNWJ3a2x3QmM4cS9pQzZEdXVldS9aUy9qdU1M?=
 =?utf-8?Q?gBdyXDfvxpQH5dWBCPJVDzU8mmsfhOA6mmcCw48?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 876369cb-4b0c-46e5-aa23-08d8f6058bda
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 18:31:35.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZ/hbMNxa0LmjqOewlJ8jbQaQLzKbVILF35UEcnlhmnN6hVM59FoCtai4tTsA37ibWV3stBqH2ymTLkw8kkbqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3895
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020300010607090309040003
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-02 17:53, Dave Hansen wrote:
> On 4/2/21 1:38 AM, Jethro Beekman wrote:
>>> So, we're talking here about pages that have been EEADDED, but for
>>> which we do not want to include the entire contents of the page?
>>> Do these contents always include the beginning of the page, or can
>>> the holes be anywhere?
>> Holes can be anywhere, and EEXTEND calls need not be sequential in
>> memory address or even relate to the most recently EADDed page.
>=20
> I think you're referring to the SGX architecture itself here.  The
> architecture permits this, right?

Yes.

> But, why would an enclave loader application ever do this?=20

e.g. to save space

> Is this something we want to support in Linux?

Why not? Is there a good reason to not fully support this part of the CPU=
 architecture?

--
Jethro Beekman | Fortanix


--------------ms020300010607090309040003
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MDIxODMxMTlaMC8GCSqGSIb3DQEJBDEiBCBR
qGx3+WDg2N1xIS2SoCPmQIPc5Hns/hJIEob3KsUmcjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAD6g0SIQmdFelL6AtxrZIjXTaAPpDYgvofngaBdacsEMqaBZk7Mk
cSHtoOPZu2/zOH9fYY+OaUo4Dzpdvj1IcLTFmDaaBG9+FgIaQ9ce0b0MnpCXtA91fpUCy7XR
BdhZEswQNwrm73EQtA/hX3lzu1bC3pk5XU/9UBrX9w6J1uASfGrAImjRg+hxjIZVosjlLpGG
3KkHbK0s77lRF+cfVnCJShfNUqpJJGTtydZHJeUYabB5e3Pl9Fgs4Zp49UNytlFFlq3CN5vj
jSZVmFsjLDnwXJaMhUiqlr2yEEG13iNH4NxfX7zmtiKUh7DgGn4MJH50rbhpcVr51ZF06rlp
zB0AAAAAAAA=

--------------ms020300010607090309040003--
