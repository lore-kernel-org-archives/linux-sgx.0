Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF453C433B4
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 09:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C57F0613AE
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 09:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbhDLJGq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Apr 2021 05:06:46 -0400
Received: from mail-dm6nam12on2125.outbound.protection.outlook.com ([40.107.243.125]:21408
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240142AbhDLJFA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsrG9CgZEgtLMhfspBfiPumfuXSle4uhoZy5pRMaIy+XiuGD8wRlCHjm/VS3lkvRDkFp+piSdMIHz/bb4Z8UO5quEqkcKyvp6Fn0rkzfhnQh18z+s8AiR/OeBYzTZEusgmUVjd3LzhYKNF0mxmNOo5Ak8K7qQAq6nJWVxBPnHWjhEwtfulhQWI/Cbzvlyr5VJ6tiirj+4/MBnOluIF3RZlaKz9P1wdf+8XPz1MkqEd9h9OPEzoTFtkjg9vQbwRdGgIQr3NJBhxMzIJ6ylGKDy/y1sePULsntG4PjcqLCVR3Rw6RHI/NZxgsTKzsalw/1qpdbO58KT1BQzoTjVgrBrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fc8Kck0rI90sPNfPmxxpUXA58/NsgLxjYBmzfGOsevI=;
 b=X5u/Q74AlxjvPxMvmMSoDk4zl63Ejg4M049kb4o0m7oYcjWNQymtMr6b1q4t2DCbyVo0TgwKGfO/nVND8CPd62f0pfcf236BbUnZKOffKcHfPjEYU9qwAhlgs5nlWNQnO7NMyUvCNrRBJQ6rUBPsr/+Gw/h6NgUVK5c+siT38jWrpnDZ8s0fhXyyO3PVplPOYQA7yDQZL/w5jHzduIKYU811L5YBvQ0u/Y7xsawLuwlkNh//6R6WFKKPapVYyGrxEJlLLnSyMRVmtgYXpP3rAKhMJAp8rTlrIUGw59iJwKPTn3lg9/mjPJRwmB+vjfjaM7A4P3GW3pGn97tHd71pMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fc8Kck0rI90sPNfPmxxpUXA58/NsgLxjYBmzfGOsevI=;
 b=Izj3WrK3lQkMI+/RoDtEjbTHBxJix/FBj33BsMeM+vBjDfkv3TuGgDbZNehlub0+QXxN9kaNRWzlGolz7Fg7a1Zenic1tWUW1deVXs8rtZKQgr7oporaN5uMYcY6RZRw7hUwNCH1dTeeieV4Gl/SyMqe9ZIJifEvBActT6dgHsI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR11MB1384.namprd11.prod.outlook.com (2603:10b6:903:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 09:04:41 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::f052:14fe:c2a9:5fb1]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::f052:14fe:c2a9:5fb1%3]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 09:04:41 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH v2 1/3] x86/sgx: Adding eextend ioctl
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
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
Message-ID: <67471818-fe87-32a9-ae9e-26a21ebd37e4@fortanix.com>
Date:   Mon, 12 Apr 2021 11:04:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM0PR10CA0057.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::37) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM0PR10CA0057.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Mon, 12 Apr 2021 09:04:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a48bbbfa-6622-416e-e440-08d8fd9201d2
X-MS-TrafficTypeDiagnostic: CY4PR11MB1384:
X-Microsoft-Antispam-PRVS: <CY4PR11MB1384D1FD15AF130B20D8EF358B709@CY4PR11MB1384.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:248;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d567Lp/2nVNeNeSiwaodXrzhIHFUU1xjs00nMayB1kkxlqWB5C+w56f3qK+QdqrkDUBVUmNl7Ejv14PxltB58XEF3krY73eSsrWpBwWh4B9e3Xu0l8YryWzstR59oxGwhydBA96TZ8KpSJrYOesavEkB48LDh/ujlQNrm7e8idVkru2UwRlAVFyNrneBq4TOcZmBOPHF0ow7gPsVdiTgYdQkJjLXw4beU2uV4qRZXYmDU75Wd/G6roIc/aNjrAVvZKze6KesDWekUk4IO+9Ybs3nRrlvm9qRckRrwx1M7ihXRURYMVvzTyRtEnca2K6FSCbpt2wtjLhoA3Pe8vETCvQidvP/V9otnldtSjXuiPNHWXQWVG86wh+rNxvJcPwq4WdrIlDQk1jy+3sdYZXhEJLV2+Jmn3sfSop4dO54nc3MCqd8P0OMFFx5x5lB3kro+AK/NrTY3o2+PSDeKagNelxu4CUH3xESLRilhxIZ3egZ2Pb4cOeK0GcSSVVOqlqx990mYzZkzUpBuEBcTFpEf6B8zkHWC3tAFc5tT9U8sCGrNZ9dX5p98QShPvw/OJ3KM7m1CTvW8ghw5sk2WEtSG3UuHremTsDBhJNkCQfpk7QxzilDVcCly33VSIYlQR/SGKbY0BTdPOzvYBGhkMTb3o3n1W0sco2+TePdcD5reEWS+TlLN5qO5O980oxsDkHN2kJzb50FVo/M/rd/VIg0C9mM6Al6cLCJn/hAXyj/XVE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39830400003)(376002)(136003)(396003)(366004)(26005)(66476007)(6486002)(186003)(16526019)(66556008)(44832011)(5660300002)(2616005)(38350700002)(316002)(86362001)(6666004)(956004)(66946007)(52116002)(31686004)(8936002)(8676002)(110136005)(36756003)(16576012)(2906002)(83380400001)(478600001)(38100700002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YndpMTZoVXFwaWpjaVo5VG5Eb1g1a1NRdVJkSWRBSVJaS2lGa0pPeXkyZk9a?=
 =?utf-8?B?OTBxSzBHVWxpRExiVk1oUEROakg4b1VCWW9OOWFnekE4RVRLMmRHWVBiMzVU?=
 =?utf-8?B?WGtDSmlSNmkrTUVGbmp3U0drM1VFTld1dmZlbndsVnBiNFB2NFJ5WFNtVnQr?=
 =?utf-8?B?T3drMkMrZE4zT1JKTEcyaEpaY2IzQ3ZkRzZvZjlKUGpXaHlRWUxTOEV6Tzkr?=
 =?utf-8?B?U2NSOGlhQVI2aHRnRUdQYk5pU2h6TE5mMW85MDNjak5CcVczQ3lPYlc1QTFj?=
 =?utf-8?B?ZnQ3OE05ckRkanhEakw5UzV5STl4RHFudktjeThZNmFRZi9ySmZ0QlBtQ0VP?=
 =?utf-8?B?UjhvZ0NXcTJsQVB2b28zQ0JmQVBaQTFvNGlmUFVFTXd1ZlNBOWpYbmpjRVZy?=
 =?utf-8?B?UmIxbURMZ1UxNEY3VkNXdzh3VFMxY2R5dFhkZzJpeElndGtlVHQ2cG53VFNn?=
 =?utf-8?B?bmZsU0s2UzdUMVVSbk00L2RrcWZLQXo0NG5uTloyUisyYkt3NGN1VWRtV1E4?=
 =?utf-8?B?UW9uamU3NTRqMzlucVFzNzFuZ011ays5MXpuOU9aVmYwaUFyMDdmQ3l1bkJD?=
 =?utf-8?B?Vnk1anFpdlRWQXJKVmhFWGhmQ1U0QStMdG10UlFzWDFuYnNaS2x0dGk1eWNh?=
 =?utf-8?B?NGt3eE1sTk1Zc1Q1dWRuckU0Tlg1NENNZ2NhcC9zb1hmWVdhT3dMQitGNkpm?=
 =?utf-8?B?dEVIZ3M1OTdxN0dnUGxXTDlubTJxT1hFcWQrTFJjMjlkanNmYSsvU21DTXBB?=
 =?utf-8?B?MGJabzlEekY3YnlSQ1l5WEJqZ1VTVzEyc0VSTENPTDQ3b1BOamlndHZ3Zlh3?=
 =?utf-8?B?cUdHNUlJak15ZUNsZFd4bCsxend4eGgrZFFqd3JpMW9rc0NFTHJLejQxVkNp?=
 =?utf-8?B?SFp1ZGljRHVDN0hueDM0VHlpR0ROTldNdmk4ZkZFU0RPdlE0dDFZYUd6YlQ3?=
 =?utf-8?B?Z2tGdVJaamRCYzZTLytzanlYMG0vbW1zclgyWFBQNmVsMCtTN3YwaXNTTkdn?=
 =?utf-8?B?NTc1TXpxeDgrYlNQd2RMbFV4R2UwQmVGYUdUdTFUVHdqeld6cmRTSFZlbFdQ?=
 =?utf-8?B?NGIwYVZObUR1NTgyb3gzSVBhSGl0NU9hbGp0NGRSL3loUDkvdmUxQnhtZW9u?=
 =?utf-8?B?dWNiWDk4dk94TE9SYnlzQS85dEs2UzFTb2pYbXpJMU1tdlZNOWtNSVZMNFB0?=
 =?utf-8?B?cUJ2TUw5eUJkMGVBY2FRa1JldEdsSmFrVTdwVjlST0hLc2pZaDEycUVCQVpn?=
 =?utf-8?B?NURRUkcxamp5d3JIb2dCQW9UNGNVNVFlQXlmc2FKTEtBMHkvaGZ3YW5UTFo4?=
 =?utf-8?B?WUF2Nk43dnJrSVBXRDJTbG9qSEFBZy9LMjc2NXN5a1gvRjJLdmd1bGNJMGp4?=
 =?utf-8?B?STJnN1FVa0t0SThCSzF3d283NC9heWN2Qkg5OVYvaTNCSmxvYkU0ajEyMGhL?=
 =?utf-8?B?WGRTV3NMWHdVMW1hQW5jRWEzRDYwN1g2cCtuOXpSSEJGclBNTlRHRXFHemt2?=
 =?utf-8?B?NDhyd05EMEU5UklQNy8wcVloTDBWK0dTZFpLMmN1L0g2YUJGK2IyeURHR2kw?=
 =?utf-8?B?enI0VzNVRlBmQzZUb3RPTnNrV0x5YzhkRHdCaFFmbDljTWIrUngyckRTMk5E?=
 =?utf-8?B?L0JnQ3gyMURVNVFiTStLLzJ6Q3Jwb3IvcHpiaSs0dnpXTE50WkhST01LTkFY?=
 =?utf-8?B?cEszUlNWaGI5T2lwa2Z6RWtkenlFaExwVXJMSkc0WXBHc0lDL0VVZForMVRC?=
 =?utf-8?Q?QqUDYjcm7XqAlHkuSzvx/GgT9DvBqHrus+UZTob?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a48bbbfa-6622-416e-e440-08d8fd9201d2
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 09:04:41.2844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LqDf0WIXnGLkM06rTrMaRDECPCCIbZYKpp20cFBWYqICgxGzlIICGj6g6pUwd1IlucZCqt+As37KOLa2riz54xz6c9s+mUT4045PCi4tic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1384
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGXv1 enclaves can be created by an ECREATE, followed by any number of
EADD and EEXTEND functions. It is finalized by an EINIT. The SGX enclave
vendor defines the order of these invocations when the enclave is being
developed, and cannot be changed later on. Currently enclave measurements
can only be extended per 4K measurements immediately after the page has
been added by the EADD instruction. This commit adds a new ioctl to
execute the EEXTEND leaf function per 256 bytes of enclave memory. In
combination with the SGX_IOC_ENCLAVE_ADD_PAGES ioctl (without the
SGX_PAGE_MEASURE flag), this enables the driver to load all SGXv1
compatible enclaves.

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
index 90a5caf..69521e9 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -261,20 +261,20 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
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
+	if (!size || !IS_ALIGNED(size, SGX_EEXTEND_BLOCK_SIZE))
+		return -EINVAL;
+
+	secs_addr = sgx_get_epc_virt_addr(encl->secs.epc_page);
+	for (offset = 0; offset < size; offset += SGX_EEXTEND_BLOCK_SIZE) {
+		ret = __eextend(secs_addr,
+				chunk + offset);
 		if (ret) {
 			if (encls_failed(ret))
 				ENCLS_WARN(ret, "EEXTEND");
@@ -286,6 +286,19 @@ static int __sgx_encl_extend(struct sgx_encl *encl,
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
+
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

