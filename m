Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25453C433ED
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D44E961994
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhCaMva (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:51:30 -0400
Received: from mail-dm3nam07on2112.outbound.protection.outlook.com ([40.107.95.112]:3947
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235450AbhCaMvQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 31 Mar 2021 08:51:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CF624KOzM6j3Qouv4Z80PR50v3KDLcqnhPMyMPXNdJf7p+bpvj29ndEDMRMgGskD9uD5dkqsqw6P6fyGlsrtE/jRMPkrG6kbr9PhFnyqvNQPj1SMv/226wMjP6AvXADZ3jctQUJg/5WVIY+H5av5/aYAm006+NsjH8SytA2hQff4lTO4McQP4wENsKAbKfdwlwfJn4cOUFcTxie/IZq8+XU/rasd4gPRe5ItMQtKJAgqwDwEXLQix+5iq3iMEozkg/Gplk31Zr4UCGin67FJ3+1tAMNAlkTkO/50GyQJACnXKDzrZWVl1rXSf/fndPJmq4ZdXsbsAWG6KogiroNQfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqIDBIId0r/jciEbDQvNbqQw3t1U1ULHQU6gI9otkho=;
 b=lafz78+kv5kOuJIlWSIlhhar+2NI72cncIxenhXmFoN/+jivK/FKIZWOq/Z1V6mumCM9r1wkpIll+oCzGCWKQjwHnnTZOOeLm7udSNivI45PeDgI+57pMHu2LTcwQpodBKlfTJDUY9+BAxfy1uf0NXQdXeeyY5oNNtp0ADEj0HC720Aar9mXKYhdA48yCLppsL3F0c39AGlqMrgbSxwI1bAkS2D9Jfeeun6DXn7BEuWJvXvzGC6MWadHtfn9qP7/d/oLsnmFRyoI9hSi2YTHrqVHoIjGDSP7m2qWJP4mcdZB2YCh95fFLtxTrnKANBLUGe+FG5cwjvEr0X5EMjUwqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqIDBIId0r/jciEbDQvNbqQw3t1U1ULHQU6gI9otkho=;
 b=DxMrAhovt/7bt/XbpcYHwqEiSQRx7EoxGPPm5MytB8AfEMDRFJXB20xEDqw5fYKSZ/O4hJ/hxX4hz8Q1Q2ZbWSYv6wfpS6Jzce0Jqr0+3nW+an2s+243IkiMcxgu/4+e9tm1/663adJ2wezJj1Y5Ka8jsilAbiiHzgtj8ocowEc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR11MB0037.namprd11.prod.outlook.com (2603:10b6:910:77::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 31 Mar
 2021 12:51:15 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe%10]) with mapi id 15.20.3977.035; Wed, 31 Mar
 2021 12:51:15 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH RESEND 1/3] x86/sgx: Adding eextend ioctl
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1617194795.git.raoul.strackx@fortanix.com>
Autocrypt: addr=raoul.strackx@fortanix.com; keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUlOQkYyb2lmOEJFQURN
 UkFMT1ZjRkYyTlQva1FsWTBtVnN3YlMrYi9WNzR1azZFcDdxenpoNHpHbEtSS1pzClplS0I4
 WmpFT2h5Q2pZaExwdnJHTVh2cTV1bm5pWENIbG9BR1hZRm9rN0Q0SGd2Q0djYnlTYVRMQjds
 NHc4MFIKOStYUkp2SnJpMEdPSmVubjRnNUpIQU5RN2h5YWl5RlRIYTVERU5CMjc2VG9kZUFQ
 bnVidGl1VmRDT0lnQVJVbAp1dzJHemFsbmY0WmZ1TGdEaHg5YzIza2pjZTFBQkFWbWdxUEtN
 TkVUSnhyZFdLQUt5QkVIWGJ0Snh6YnR4bFI1CnFUZU8yTExCU2V4TFBDbTRZOTZzRHlGK3JJ
 a2FpRk5JQWk2b3RrTFBxYkROUlB4OTdLTTkzcmh5dVpIaWVQM1gKNWY5dG8vN0xEcGhqV0ds
 L0ZBcldmT2U1QTgxTnhoTG5GNm9kakMrN2JwakdkNXdvM2E5TTkya2wyelJ1bEhSUAoreFFY
 T2Z4NkNoNnBMSVkvbmRtSGZOVDA2ZTBCUkt1MlZxWEw4Y2Y1a2pkMW4waW1vU0FxOElGNmFq
 UThBdHl0CkR1T3JpTk82WGFQRVlqaHVvTzF5YnBFeDJCWE95N3J4aUN5WFlkSldJVmY3T29a
 c0xEM0wzTHBYM2Q4K1hZYXUKeWxab2dVaFErMHpoWlhBVnExSEkzc2duNnFIZ2RTT0J6aUJI
 cnhycGFvUnRhQkREL0I5WFhyM0FOTDhZWG9BegpISzJ4bDhhQTg1eWt0THlBNVc5WU1GS2Jj
 UXIrR1VuNStCNWRlOFN4SDgzTkR6TkljNnhtYUtKTU9xdGFiK2hHCmhRUEdtcDlmNDdGQmQ2
 QkhLYzFBSHJ2OElteDAyNVdYc1lBakpZbkVlMzI1dW5MeXlUTlB5VFo0NFFBUkFRQUIKdENw
 U1lXOTFiQ0JUZEhKaFkydDRJRHh5WVc5MWJDNXpkSEpoWTJ0NFFHWnZjblJoYm1sNExtTnZi
 VDZKQWp3RQpFd0VJQUNjRkFsMm9pZjhDR3lNRkNRbG1BWUFGQ3drSUJ3SUdGUWdKQ2dzQ0JC
 WUNBd0VDSGdFQ0Y0QUFDZ2tRCkFrY1ROU0RvS1ZoU1B3LzQ4T0FoUExHVndWSGtsSnE0QktK
 ckUrc0xTMjY4RnIyeEg5SlNaN3B5YU83bm5aYXcKcjNHL0dEVmN6L0FWZVZCQXY1OW8xMW9y
 TmFZdFAvUzdhOWFFbUl2bVZJZitvaW9ZaXh5eXlNZk9obFNmZnloagplWkg4ZC9OZDJTajJ3
 SXJ5S1BxNm9rYWY1N2pVR1dlbEFaNUZaUWJQNzFlU2E2dzNtcmQ5L1NOTFdFVTNPNWloCjRs
 em9HT1Fob2R6Qms2Yzh4UjZsQzJ3OHVyRkYrRnRhcmxwNkhxbWVBeHdXeHVQVDh4ZDhCMERl
 ODFFbjZIMFYKNjA0ekdsa0dYS1VTdXZJVHltdzEzYTJqYXQzTTRFTjNRb0lsbG5hN3N3ckly
 K3l4aTB3NzgvczZEU2dtVmFIZgozd0lncllMNDEwRnpCeVY1RzBDTlVuZ3lnL0d5ZWFiUVl0
 ZU04NHMwRXdMRFFkWSsrYXBZN1FYVEE1d1J6bFJNClRyc0s0MDBndlF5d2lPandST2x3U1oy
 L2QwSjBJdXNFdnpzQXIzbUNIQTRXWnNaeWpsT3Z1UXE4LzR0ekNKN1UKVTRvVUxMWll4ZkQ3
 Y1BVQXRTanBnNTFiVGhoai9nZXJDN1p4Sk1nSDM1MWR6RlowS2xsVUpHRU5QSmJkRFZ3WgpW
 c2lHRjdtcXVXVEwwQmpLYXl3ekgwZWdLVlh2ek56NXlrbjhJMDlTM3VvY09jSjU1bnNhR3pT
 WXlnZ3k3eGRoCitTMjVEVjMzWXNobU0vcGdXWW5IL3BUQzRDQUpmaGVpU0Yyd2EyR1g1bUZF
 QVBaQmh2Q0I2SzlXdkNKbEZXVzcKZTZ0dUpPRGdNUklQLzJ0SHJIMEFiMmFyVWJFWjhpaEdM
 L1pXcUIyRHlkeTJDVjU2ZjdjWVZBSndJTGtDRFFSZApxSW4vQVJBQXVEbXlwU3U1K3BFdlRt
 QzBBY2NUbVZnbm8xKzA0SllzckcvbVVuMG11cmFHM0xnZWtWMWVJWTVQCjVpYW05OEhiL2pI
 MU9kVXM5R1VCNCtLU1d4SnJERmNXNkZOcjJiZ1V1Y24wZm1XRHdOWU5oWGxJd0ZHMGRaV3MK
 SzNuRWlNSXJTTnhnSzBmS21jU2lpaTJhZlRMMkFTVm5JM09RcUN0RGhpU0VEWkJ3eW5BeDIx
 Nk4ydklNRFJVMQpiS05oVzRvNnk2R3BHNUdVQ2VBZnZ6SE5lMUNEbzQyQm5CRXUrVmlZYUE0
 cERrZ3hjaC8ydk5YQTBtc25rY1BiClJmcVlhOElpSVVTUG91WWVneHZ5dVJjbEhadFA3TW5n
 V2ZRSmxwQVlIOHdJWExUSTlScUpmTTM1K0xZRTNQR3kKS0RYZmE3MWFFUjkxcUJWMDQzMkNn
 KzFQN3pJUERTR0w2TEZJaFRBTE5TV05TRFU2NXpKWlNkY1NVQ21raytWZApqZkdGbk5LeEpW
 OGl2ckN2TGZMY2VpQWFWK2RHaGc0WkFWWStscVdFSGxYNW03V1JXQ1Jjb3pDNUd1TlVIeW90
 CngydVpHQys2TDVPTGVXeTZoUlhGSWdZWURLaWNnYTAzZjQ2WWorcDdKaTlWTGxvYWIyU0xO
 YlJFOERpK0xUWmQKempBMjQ4cDNTMDJpM1h5K3cxeGs4Q1VzOHVtMjlYNTVEaGtDSXdDdk5i
 Y3ZZcGtneTNjU3dZL2JmMm4xUnZ4aAo3MldxM2JBYXlVdC9yV0JFRTlTWkZ0cXRITUpCWVFX
 eDh3S244TVl5MU54YmpWZ0J0cVVaakdycW5OV3lnRStNCmFJZ3RpcUM4Q1VaU1c3dThMVW5a
 OUlaaGEzL2h1c0pJNXRmTHc5RmhTNXMvRzh6bWl3OEFFUUVBQVlrQ0pRUVkKQVFnQUR3VUNY
 YWlKL3dJYkRBVUpDV1lCZ0FBS0NSQUNSeE0xSU9ncFdHMlpELzQ1dFpmOFlvUkUxcHRQd3ov
 OQo5S3BIdFp5TUt5NFZLNmxXWDRCNnpHZ0hpcXpIQi9lekpwOEEzaitNc2FjM0hMZmtHdjVN
 UWYwRnNYUnBCZWhJClYrU0FBUmw3SktzM3pUck13TDU4QXpnNk5nbG5DZDNaYXQxU2hlWkhQ
 dVdXTUdCeERPMUg2UFI2NmRGWVJIM2MKODVaZHNHdWFobnJVSFBLemhZbWx4dUhDQ3FCZ3RK
 am9wS2NWVGsxRnRLVGUyZHJ3Z25Bb1M2dkh4bTdRTWxJVwpaMTluS25GOFAyN0pFanU0ckdX
 Z1h3NkgxSmFKMTF4YVVkZG9qdk53T1RKRVcvb3Jhd2tuUUF1ZW5EYnpBR1Z1CkdMV0w3T2ov
 RGZyTFBBemNXV25GblV2VVc2NEFEWFNBOTh0SWNBY3lod05uY2lqYnNIUkFTQlJidkg5RFhJ
 c2wKaEwxMDArdzZNTWNMeFpNVmJ4UHBTWWVHaGp4SjdNUysyeGp3eDB4MWlMNmszZk5UNHNT
 Q3dZa0xRZjJlKzhxYwpFYjNTa0Q0VFR3RDQxUW85SFNuUlkwdnRqblNyZkwyQ3JhVmptOXhh
 MXhmNlJDQ3kvaXpKNU5TQTZZMXduT0U3Ck1IOHorcVFUM1NxMld0a0NzU1M5K1U2VU9OWmFK
 dFN5MWNvZ1ZhMDV1QWdRY0tHT3FvcHg3QWlmZUhIUFpqZnIKakVNaHJZQ3Q5WXgzR1VET0hs
 MnRObDJIOStqZC9BVjByMDRKUTNxSHRWM1Z5UTNxN0N1UTlCTTdnQzVpK1JleQpHSU14Zm0v
 a09GWTRLRUxOeVYrV01PK2lXRHpZS21tTUxnUkVXNitqZk5jMzhrYWhaQjI2RmJOZTh6QmxU
 cVpPCmhxYmNZR1ZZNW9Ec004YSthbkwyZDhmaStnPT0KPW9ZT0QKLS0tLS1FTkQgUEdQIFBV
 QkxJQyBLRVkgQkxPQ0stLS0tLQo=
Message-ID: <143372db-9d6d-6cfb-71c6-e21aba5f3adc@fortanix.com>
Date:   Wed, 31 Mar 2021 14:51:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <cover.1617194795.git.raoul.strackx@fortanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: PR3P189CA0043.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::18) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by PR3P189CA0043.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Wed, 31 Mar 2021 12:51:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56ab2256-d593-4d64-7686-08d8f443ab42
X-MS-TrafficTypeDiagnostic: CY4PR11MB0037:
X-Microsoft-Antispam-PRVS: <CY4PR11MB003709D6F8A33663A7E5B3F88B7C9@CY4PR11MB0037.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SKzOvSutDFHyR/4osueCKB8WpOuJmQc2y5hmXw8PDv4JS4/yOhvKiNRqEK7csPOk1CxNmoOXQOIpsGLLVhNa9m2Vp1Iq1t0mow5tZr8a18nONCergpzMmJcrXU2MKKa74gwpVQEBeGZeTXhvuj0EAFSTlZe/AXb+f+XEnopw+F6F9reZM6cAi+5eAucUcmZXIWLmfUoPfCnvMsl9BdBDMpND6w12LuHSOJhwRPQ/h9Y5/rU+GPhDvUpUFga8BCiwJeX8jru2AQkwXMH4Y5CPs4J4ogJZkObxGbGbGO/YF57WCtGZS8M3mm15SKAawLVpKZScwTSOlJvVD8QDO8045xO+wup5rG4jBWLeSYBUnvVJ/d8qcF1GoggiWTk2K4nJ/+v0Aq59iJnN0YmwhWqo3oP5GMDPQAUsViH90TgdDkhN3RKyRYjc3DZXABAZ15nK0k5fF0RrUwmrDftAsR/N74nkGTHmI0a90UQOaXa0U+EwBD/8lTVdWXoWNLrXhyHryZT9CgE8mAM1I55MAI4VlBkbDLzMTb9vfxUZS76y38BT+M8vAmMPtwZ+qAvtCXI9EzrZ6kIItKcUGrSK+DMNz9xpjL4BuZUV9tiGr2BbNg2RmD/wzNzce+H6kp1b+xvrR468kAn7A6AP8aBzggX+hw9fKafPOadB2Q2k+RBo6a1sfcBLaAOC65ibS+M/ERNanK98ZX3prBWclHKMKWkgmdrcg1nkpoDIoCe+MrloABI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(346002)(39840400004)(8936002)(110136005)(2616005)(44832011)(6666004)(8676002)(16526019)(26005)(52116002)(83380400001)(36756003)(956004)(16576012)(31686004)(38100700001)(31696002)(186003)(2906002)(478600001)(66946007)(5660300002)(66556008)(66476007)(86362001)(6486002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RWNNNlYvVndNWUwwQXVibnVKRUZ2QTFabGFRaFRHUkhiZCthdUhVRTFxUk1I?=
 =?utf-8?B?NGxnamlQODRpdEZrTlp0RWNySGlFQVB4NXVhTjZuUCsyZUNWa0dSb3ZrZThu?=
 =?utf-8?B?dmo4YXVpSlBWcmxkTnhCYUREbTY1VjhudUtvZUVteG1iRW93QUk0Sm5jQjkx?=
 =?utf-8?B?NkJwSE5BaVgyVzdQT3MrWU5Yekl1MEEwVTlzMy9ubWE1OWxlbDYzaEFFMVJR?=
 =?utf-8?B?d1lBOEhWeVJoenFPbkFjeVc1dWhudnNYbExadENSM3o3Q0wzOG4yb2xvc3Yx?=
 =?utf-8?B?MFFKTGVPc2xrNm9aOFBzVUxhaVRVakhSTXExS2FDUHMrUDV3bHFscFJyU0Nx?=
 =?utf-8?B?YjlncjUzdUlSNEJQbGZKR21LZGtQRTBpMWFtWWtxOHB1ZG9rdC9Xc0N6b2tj?=
 =?utf-8?B?dU04MzdtUnowQkhPL3I4ajJscGk5d3lQN25vMU4yaWFudGNKc1pZTFA0TTFl?=
 =?utf-8?B?L0tKUFFVaWdXY0FLN2tiWHFlRVVNa29GdmFNMVB0aW5RWGZYMzlVQndWSUpW?=
 =?utf-8?B?YVN3VlZ3ZGxNckU0OWFCR25KMmNJWUxiQXRMdkhmOTNkb2RMTW5jS2xFUG9L?=
 =?utf-8?B?MW1LS2tTbTlEcnRXdUlDVEtSUmVicGowWTZiY0pudGdhTXN4aUd6bUcvaHNv?=
 =?utf-8?B?QzFJb2E0dDhMUVJrM2dDdGhBNlZXZk1LNWQ2Q3dyWnU4R21vMmMxVzJNc21x?=
 =?utf-8?B?VHZBWm92RUQ0NDBIbTJLaDE2RUtUYVF3QnFZd2d0QW04Q05WSGhZZW9EODU2?=
 =?utf-8?B?YkJjUGwwZ3FzdGVKWjRmQ1VEc2x3MS9YUXZpRktUM0szTk4wU2pVT2lpQU5r?=
 =?utf-8?B?bGE5bWFML3d2YUNabm5nRkYyWW1ueHNBVkFFR3ZjTFVrZ0Rad3VBdHcwSjk2?=
 =?utf-8?B?ekxGYi9nRFp2blp3V2pGSzAzNUtVbVU1Q0FZVHJKNjdVV3JvRVZIQjRiejN4?=
 =?utf-8?B?MW1YTFRVQ2RycnVLclViUTBUOWQ0K29hRk1COFAxSHFSSjRUUFNzUXhrRE9D?=
 =?utf-8?B?WldGeFlZZHcwYUorSXp6cSsyQ3ZwMmh1YzUxc0Vacy9zK2RzTHE4cXV6L1Nz?=
 =?utf-8?B?ZUkyL0djUS8vTEQ0ck1pdzc5R29KUVVyYjB3RkdiOCtlZVpDMlJJTkxycnBm?=
 =?utf-8?B?Ym9zMUFGUHVMelRFREZYeGJuYTZsTXJDbnhYU3czR1llbmp4TnNVZ0RvUlM0?=
 =?utf-8?B?aHAzREtBSFVGaXlqZUtGNmFkTmNFUXRuSlFWL0Vpa3lVWnFKamoyNEdvbUdU?=
 =?utf-8?B?V2JQbGx1a3NFUjU3UXQ2b2dyeG9DTmtNTlA1dW1qYUpIV28zUFdPU3hOUjRY?=
 =?utf-8?B?d21sTnZINUdvVHZiUEJqYkt0TlA1RWZrZElQRFdEdmhGMXhWQ3NzbHNGcmhZ?=
 =?utf-8?B?Y0xCYk9DRUNiRkxJK3BHVldOZmxlL1YrWkdXZ2ZaY3lOWmxyeXpGb0pLMlFw?=
 =?utf-8?B?R2JvMzlLQ3BENGRjUEpOckt6N1VsTDJEOHF2cXBhdnB6S1BEMUlTWkVER0cw?=
 =?utf-8?B?NGU1dGFDRUkvS1JYZVBCbHJpVzRIbFF1WHN3VklTYjZLbGN5Z2M4TVU1VUMw?=
 =?utf-8?B?Y0lxTjdxayt2cUZKRWxLTldDakI1dEgzUjZUQjJlSG8xeTJwVHJsdXkwL3Vi?=
 =?utf-8?B?NXVXMEcvSWR2OTlGL3pqekw0N25JWEpIbm5MWlJZV3hLdFVjclFTYnJDZVFa?=
 =?utf-8?B?SGh0NVFsVEE0WnlvcklpYkdhdGRNc2RRbjR3ZWI0dGRpK0xBZGRZM3lrOG1O?=
 =?utf-8?Q?G+Ocnne/x1NSI6mbs3fgVXlF7KrEloIq/wVYzHg?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56ab2256-d593-4d64-7686-08d8f443ab42
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 12:51:14.7960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53OSc9J4iwxd6iKOFCx6awn6LtpqxDlF2P71QMmymq8QIQDWHT3Q39y/JXYIn3pEHwsxqk8bcBXC/NLXrLCyAM8MSRcbixaPdHCZxt3HAQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0037
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The current sgx driver can only launch enclaves that always measure 4K pages. That may not necessarily be the case. This patch adds an ioctl to enable users to add the enclave measurement per 256 byte.

Signed-off-by: Raoul Strackx <raoul.strackx@fortanix.com>
---
 arch/x86/include/uapi/asm/sgx.h | 11 ++++++
 arch/x86/kernel/cpu/sgx/ioctl.c | 81 +++++++++++++++++++++++++++++++++++------
 2 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9034f30..121ca5f 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -27,6 +27,8 @@ enum sgx_page_flags {
 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
 #define SGX_IOC_ENCLAVE_PROVISION \
 	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_provision)
+#define SGX_IOC_ENCLAVE_EXTEND \
+	_IOW(SGX_MAGIC, 0x04, struct sgx_enclave_extend)
 
 /**
  * struct sgx_enclave_create - parameter structure for the
@@ -57,6 +59,15 @@ struct sgx_enclave_add_pages {
 };
 
 /**
+ * struct sgx_enclave_extend - parameter structure for the
+ *                             %SGX_IOC_ENCLAVE_MEASURE ioctl
+ * @offset:	offset of the data from the start address for the data
+ */
+struct sgx_enclave_extend {
+	__u64 offset;
+};
+
+/**
  * struct sgx_enclave_init - parameter structure for the
  *                           %SGX_IOC_ENCLAVE_INIT ioctl
  * @sigstruct:	address for the SIGSTRUCT data
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf..a21d3e7 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -261,20 +261,21 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 	return ret ? -EIO : 0;
 }
 
-/*
- * If the caller requires measurement of the page as a proof for the content,
- * use EEXTEND to add a measurement for 256 bytes of the page. Repeat this
- * operation until the entire page is measured."
- */
-static int __sgx_encl_extend(struct sgx_encl *encl,
-			     struct sgx_epc_page *epc_page)
+static int __sgx_encl_extend_chunk(struct sgx_encl *encl,
+				   void *chunk, unsigned long size)
 {
 	unsigned long offset;
 	int ret;
+	void *secs_addr;
 
-	for (offset = 0; offset < PAGE_SIZE; offset += SGX_EEXTEND_BLOCK_SIZE) {
-		ret = __eextend(sgx_get_epc_virt_addr(encl->secs.epc_page),
-				sgx_get_epc_virt_addr(epc_page) + offset);
+	if (!size || !IS_ALIGNED(size, SGX_EEXTEND_BLOCK_SIZE)) {
+		return -EINVAL;
+	}
+
+	secs_addr = sgx_get_epc_virt_addr(encl->secs.epc_page);
+	for (offset = 0; offset < size; offset += SGX_EEXTEND_BLOCK_SIZE) {
+		ret = __eextend(secs_addr,
+				chunk + offset);
 		if (ret) {
 			if (encls_failed(ret))
 				ENCLS_WARN(ret, "EEXTEND");
@@ -286,6 +287,18 @@ static int __sgx_encl_extend(struct sgx_encl *encl,
 	return 0;
 }
 
+/*
+ * If the caller requires measurement of the page as a proof for the content,
+ * use EEXTEND to add a measurement for 256 bytes of the page. Repeat this
+ * operation until the entire page is measured."
+ */
+static int __sgx_encl_extend_page(struct sgx_encl *encl,
+			     struct sgx_epc_page *epc_page)
+{
+	void *chunk = sgx_get_epc_virt_addr(epc_page);
+	return __sgx_encl_extend_chunk(encl, chunk, PAGE_SIZE);
+}
+
 static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 			     unsigned long offset, struct sgx_secinfo *secinfo,
 			     unsigned long flags)
@@ -346,7 +359,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	encl->secs_child_cnt++;
 
 	if (flags & SGX_PAGE_MEASURE) {
-		ret = __sgx_encl_extend(encl, epc_page);
+		ret = __sgx_encl_extend_page(encl, epc_page);
 		if (ret)
 			goto err_out;
 	}
@@ -466,6 +479,49 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	return ret;
 }
 
+static long sgx_ioc_enclave_extend(struct sgx_encl *encl, void __user *user_arg)
+{
+	struct sgx_enclave_extend arg;
+	struct sgx_encl_page *encl_page;
+	void *chunk;
+	long ret = 0;
+
+	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
+	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
+		return -EINVAL;
+
+	if (copy_from_user(&arg, user_arg, sizeof(arg)))
+		return -EFAULT;
+
+	if (!arg.offset || !IS_ALIGNED(arg.offset, SGX_EEXTEND_BLOCK_SIZE)) {
+		pr_info("offset not a multiple of 256: %llu\n", arg.offset);
+		return -EINVAL;
+	}
+
+	encl_page = xa_load(&encl->page_array, PFN_DOWN(encl->base + arg.offset));
+
+	if (!encl_page) {
+		pr_info("enc page not found\n");
+		return -EFAULT;
+	}
+
+	mmap_read_lock(current->mm);
+	mutex_lock(&encl->lock);
+	sgx_unmark_page_reclaimable(encl_page->epc_page);
+
+	chunk = sgx_get_epc_virt_addr(encl_page->epc_page) + (arg.offset & (PAGE_SIZE - 1));
+
+	if (__sgx_encl_extend_chunk(encl, chunk, SGX_EEXTEND_BLOCK_SIZE)) {
+		pr_info("extend returned an error\n");
+		ret = -EFAULT;
+	}
+
+	sgx_mark_page_reclaimable(encl_page->epc_page);
+	mutex_unlock(&encl->lock);
+	mmap_read_unlock(current->mm);
+	return ret;
+}
+
 static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
 			      void *hash)
 {
@@ -706,6 +762,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case SGX_IOC_ENCLAVE_PROVISION:
 		ret = sgx_ioc_enclave_provision(encl, (void __user *)arg);
 		break;
+	case SGX_IOC_ENCLAVE_EXTEND:
+		ret = sgx_ioc_enclave_extend(encl, (void __user *)arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
-- 
2.7.4

