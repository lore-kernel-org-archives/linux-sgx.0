Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04EF5C433B4
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B31C461935
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhCaMvY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:51:24 -0400
Received: from mail-dm3nam07on2094.outbound.protection.outlook.com ([40.107.95.94]:7265
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235600AbhCaMvJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 31 Mar 2021 08:51:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kA1b3bD19+p3mcnSQ5ZmB8psLhgK+ay4kamCdm1lzDAxKtaSdIhGfb+4uRUqkfSeRgzlLq3dMIueBulGUTpvATiL1V/d+WV/B+LXIN24iGEcsbz4FShD1DyEfn41FfSXcMHeETLqMfdSsPMDac8J4F62KFslxaCfh6RIoIcY+6f0s96bR5jfsm4GxOain1g9jS3WBpeETWusFInLtV/u4PZ+Kaw9D9a77PJfW52QvVAQcJQgyhUWWcbzSECh4FMbxmLooqn6UAfjzZ+Egk+toN/H6M32cRhWp9X5w+eE8ThoCO+0S9/RhkgiSjjpYRMm/GWS0gMX1Gkcnd9FbC+MQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88a0e+cYuWar3AUrJ6t5ZxghgZw4rmR/pbsuI/wxGnM=;
 b=Pv31GHZFzmG6EBE2yZivDCLXoEM5Ly5ddYHC0z4IlWWi/y8Ciz2KZiHKab7s5HTDoGX0leuTOi+q7lyALCUoIuqxjDTbaLA11eSglOu36/qgtjITsafFHQ0viwTKHDLNVNBC1IB15PCBbw9zDWgbgoHNGwXAj1FAnB4aPcWLxjVW3moDjtq4zSEjjdOvlymQQPxCNnNF3V2Z8PXaSY/SPtZz3gwvzLH3+XgO+ODaC2GorvCGULLnWs1SBE25XlMHymhAUUum3Cg7rnsbh9u4NE9j0SWAs+2qp6J0HsQY4Hewag407E4ZvirrlT0K1AD0qZKrduGRs63be24g4E0DJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88a0e+cYuWar3AUrJ6t5ZxghgZw4rmR/pbsuI/wxGnM=;
 b=n8AOE3UZPvyGdA3TZg1cD7FjHvB5H8camRyotISGJR87+vfS87BBJ/kxanFe23c7lPlBsy2KiGdrfd3rG4vTwJP5HN4rI7oQ9wifPyAIEfMyousoK+IWlI7qxS/ucLDYEBKpIUZFdmqVVZSm2QHcWcNVvknETt57dSZJ5IKd3sE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR11MB0037.namprd11.prod.outlook.com (2603:10b6:910:77::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 31 Mar
 2021 12:51:05 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe%10]) with mapi id 15.20.3977.035; Wed, 31 Mar
 2021 12:51:05 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH RESEND 0/3] x86/sgx: eextend ioctl
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
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
Message-ID: <9688abee-6ba7-e1d9-701e-a5cabac36269@fortanix.com>
Date:   Wed, 31 Mar 2021 14:50:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: PR3P189CA0056.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::31) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by PR3P189CA0056.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 31 Mar 2021 12:51:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee50e0b1-4dc7-40d6-70ed-08d8f443a58f
X-MS-TrafficTypeDiagnostic: CY4PR11MB0037:
X-Microsoft-Antispam-PRVS: <CY4PR11MB00373B8793F52C0EABAE8D348B7C9@CY4PR11MB0037.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0K/KO5UKP8kows4CX98JsWSWCv/ld5qp5os3gOo44RAz/9vB7rD6udYrFd0HY8qGKc1Hh7rj6TJAuU0QHn0B+uiQJCRnp3G9426/uZ80Ixzrv+34TzvavTpIpCNbtF8nXk66CoGh22d0BdVaUGfNso0PYTkgn0STLT+SvVWvpMXqZxwqXXaZ6c7FSGpsi1s6D0fM0n1bgOpUEumTyTzJwzUkgGpnY1V9WuEUkx9DV+NYhvd/LMKDv7g82jrV+nHZYJgFuTtvD07+yDWKMMqqq6HxUbWxvPbUrY1SNIdpMcBd0FxWZOobFot68NwgtMKCUydchGrHvJyLtvL4vGXr4J7q9phgNcTMcwXL5OEYwQw/iDy9KrAPy+33ESUKIAod8dS6sNfvqdL90onfAKNutPQnjUE64/QmJsB+02QMCHrKHkqHE3EMGBF6RaDRJot4oHElfNL+DwdWGDpTJhTBGW/HqjcFx9YzzrmoMJ6WDhVRwmWSXn+mBSuSvftVRJJIECu1J3uRhJ4UWK7RoCzdd6Xs4UUcnUfWsWn4aZ8RAZqVHgGf20hyaFb6F3FZJwV30AxD0s+3ei5I5jxH0vjcXEvfSTwG1MrRleHCcifpr8JEMMm5IqxRzmCyh3QmU/bOQm7FoMfdxv26rlMSZJa4vnW83Fsc8LpKvXXiEjT3ve2gxTxIZJrhGtntMr3xAY5j0z/10HENwsundHEMoRvR1P0iF/DkttLz7Mj9bgVDoSFZUmgZlztuwFSeApt/DP05jWfBEPVSzQ51Vl55PmbJaBxn9whQVmFAjdtyWnFU61Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(346002)(39840400004)(8936002)(110136005)(2616005)(44832011)(6666004)(8676002)(16526019)(26005)(52116002)(83380400001)(36756003)(956004)(16576012)(31686004)(38100700001)(31696002)(186003)(2906002)(478600001)(66946007)(5660300002)(966005)(66556008)(66476007)(4744005)(86362001)(6486002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TjBkb1ZYd0FLRWxuT0wvTklmeVcvQVA0Y0RvZmIwUVdacFVuRUlsSm9PQWo2?=
 =?utf-8?B?SCtSemVwaUhvL0hkSmk2cTdCWXErRklFZW5WMk5NVjBSWnM0L1EvYU9XTHFk?=
 =?utf-8?B?czhyOHVhRm5HSGp3ZDVvRkZ6UjVKUDA1RzFuREY5TnM3NW56M3VoS0V3T3JU?=
 =?utf-8?B?NGYveUxjR3RFWXZNeTl0eEtRcUtHYURGN1hLZnVDT0RJQWQwREFITnFLZTJU?=
 =?utf-8?B?YUVIckZyQUpFZWRLNGJ5bGVneXVnd0VDaHRGTjR3KzVSdlUyTUlFdmJmWDBk?=
 =?utf-8?B?ckxHUCtvYW55Wis5VzQwRDJQbmF3NkJFekZ0MjZNK1ltM2F3RExwYW90cXk3?=
 =?utf-8?B?dlAxUlFmejFkSlBudnRaSnV5MmwvZ1ZPTTMxem1OdlkzbWovNk1pMFh2TUpm?=
 =?utf-8?B?aDJQY25EZ2IxZDg4ditIUFdqVkZ2bzVWMjF2VU9sN3JNYmFiUUd5UmtpWWty?=
 =?utf-8?B?QkFrQzVDSjd3N3YwZWZkdERxTUtra056NkJkRlk1eGJubllwT2dnRHBZZ1Mw?=
 =?utf-8?B?TGdmTEhDOUdpN3JYemxuQ1dqMlJqRVB1c1N2cExsK0hOdHJ3djkwbzV5UzFr?=
 =?utf-8?B?Qm1VZzViYVZoYXN2Ym5uOHhqQUxzUXRtOTlPcFVjbUcrQk1SNVB5TVhFTDVx?=
 =?utf-8?B?TStRQzJpZzVWSGN0eGQwb0EyT05mbk5zaE1OSGVJRFVXV1I1Z0x0aXJzU0xW?=
 =?utf-8?B?QTd0NUNENktKSVg4ZEUxRmpIQlVYZFFzRmVZTldUcFlTT2R1K0IvVm9lOWUy?=
 =?utf-8?B?TzUrWVdtalgvNzlCSUg3c2ZTTHp0N0RVT2paMzF1c0tSKzZkc0xHYlJJUzho?=
 =?utf-8?B?cE5nSit3QkdXRGxiL0ZkK0pzQXQ1RGNZLzY4T21UN0Ryd3dST0N2Q3JIY21q?=
 =?utf-8?B?azYwL1k5cHIrc2RyRVpCR0pQYi9TVDdEdThMTE0vcFUvYVRHODAzRXRwaDlv?=
 =?utf-8?B?bGFYV3l1VUhETVpjdG9POE45OUl1TE5SL1JZaE1XRGpVTVBtNG5GUDR3T0Mz?=
 =?utf-8?B?TUxqc2VuLzYvOTgrR2g3S1ovQjJEOHJKZ2dGRzVremNaZ3ZzT1BSNDRxV3Mw?=
 =?utf-8?B?OVVSQ2F4Vk43ZVRtUDZ5R3h5aGw0MWUrUXNsVU81dlpYdld3UVJkTVBQdlhN?=
 =?utf-8?B?Q0g0YmNmRDZzTVd0VDk4SS9hUVBGajJsbzU1cE1kR3BGV0lWVUR1SEdoV2wr?=
 =?utf-8?B?SDg2VjRRRnhYSStFMm5BbWUrWnJ2SUVMTG1kdjU0RksyNlUyTTRaTVVVcUcy?=
 =?utf-8?B?a2hzWUdwVmhtU0JLaExnYmlPdkd4TnlPV3N1QjcvQTNxcldtNlVpOFVVeGVT?=
 =?utf-8?B?Y212SDU0MjJUd3JqL0Jvd3ZEZ0h1UkRhK3BHbzFKVEZRQ05Oemk0b21yQUho?=
 =?utf-8?B?M1NpRnM4bjVzaHo1eE56VmM3SThPSTNCUTliMm5kRHFsemREbTdNYzRkTmp0?=
 =?utf-8?B?MWVueWRMaW9BY3FSQzZWaXplUkFtcE10dVVTTEt0NHAyUlgxY3Q5MTVJM3FO?=
 =?utf-8?B?NFZHWlVUUU9zMlV5N3FZTVc3cHhXQmUxbEVsUFNuVHNESVV1bk5pR2IxS0xL?=
 =?utf-8?B?MUh2RVAxQVJFVG9oRm56MUwrM3B2azd1MEI2SFNJeVZjSExmc1RlVkQyRTJJ?=
 =?utf-8?B?UTJ6YlFCancvTEYrMXZadlRpREZIa0NxUlc5UEprS1Z5cVNJSlFoUUsrTXFM?=
 =?utf-8?B?OFRFMVovcWlHNWlwN1BUc3VuZUt5MjdpckNQdjJJR1FJZXBZQld6dTBSTXhh?=
 =?utf-8?Q?6zCPA781nv/ii0G0Tn+mI96DLxWMb0nCBHO3rKe?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee50e0b1-4dc7-40d6-70ed-08d8f443a58f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 12:51:05.1891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TFi4AZn0ND7BsIbI6V0v5DNhw/zLGbEvi4pyOMUbOB07nVvYHUoP4FbQ3KaXOtFnVzyqfWzVy63R7lUdHi/za0RYD43GbDoZbXBWqIIxSqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0037
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The sgx driver can only load enclaves whose pages are fully measured. This may exclude existing enclaves from running. This patch adds a new ioctl to measure 256 byte chunks at a time. Such a requirement has been discussed before:

https://lore.kernel.org/linux-sgx/20200220221038.GA26618@linux.intel.com/T/#m93597f53d354201e72e26d93a968f167fcdf5930


Raoul Strackx (3):
  x86/sgx: Adding eextend ioctl
  x86/sgx: Fix compatibility issue with OPENSSL < 1.1.0
  x86/sgx: eextend ioctl selftest

 arch/x86/include/uapi/asm/sgx.h         | 11 +++++
 arch/x86/kernel/cpu/sgx/ioctl.c         | 81 ++++++++++++++++++++++++++++-----
 tools/testing/selftests/sgx/defines.h   |  1 +
 tools/testing/selftests/sgx/load.c      | 55 ++++++++++++++++++----
 tools/testing/selftests/sgx/main.h      |  1 +
 tools/testing/selftests/sgx/sigstruct.c | 43 ++++++++---------
 6 files changed, 152 insertions(+), 40 deletions(-)

-- 
2.7.4

